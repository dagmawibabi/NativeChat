import 'dart:async';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import 'package:nativechat/components/apikey_input.dart';
import 'package:nativechat/components/attachment_preview/attachment_preview.dart';
import 'package:nativechat/components/chat_feed/conversation_feed.dart';
import 'package:nativechat/components/home_appbar.dart';
import 'package:nativechat/components/input_box/input_box.dart';
import 'package:nativechat/components/prompt_suggestions.dart';
import 'package:nativechat/components/remarks.dart';
import 'package:nativechat/constants/constants.dart';
import 'package:nativechat/utils/api_calls.dart';
import 'package:nativechat/utils/get_device_context.dart';
import 'package:nativechat/utils/tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:image_picker/image_picker.dart';

import '../components/attach_file_popup_menu/attach_file_popup_menu.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController userMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  late GenerativeModel model;
  var chatHistory = [];
  bool _loading = false;
  var installedAppsString = '';
  var installedAppsLength = 0;
  bool _showingAttachmentOptions = false;
  Uint8List? attachedImageBytes;
  Uint8List? attachedFileBytes;
  String? attachedMime;
  String? attachedFileName;
  void addUserInputToChatHistory(userInput) {
    setState(() {
      chatHistory.add({
        "from": "user",
        "content": userInput,
      });
    });
  }

  void gotResponseFromAI(content, isNewMessage) {
    if (isInVoiceMode) {
      speak(content);
    }
    setState(() {
      if (isNewMessage) {
        chatHistory.add({
          "from": "ai",
          "content": content,
        });
        chatHistory.removeAt(chatHistory.length - 2);
      } else {
        chatHistory.last["content"] = content;
      }
    });
  }

  var appFunctions = ['clearConversation'];

  Future<void> functionCallHandler(userInput, functionCalls) async {
    var advancedContext = '';
    for (var eachFunctionCall in functionCalls) {
      var functionCallName = eachFunctionCall.name.toString().trim();

      if (appFunctions.contains(functionCallName)) {
        if (functionCallName == 'clearConversation') {
          clearConversation();
        }
      } else {
        if (functionCallName == "getDeviceTime") {
          setSystemMessage('getting device time...');
          final deviceTime = await getDeviceTime();
          advancedContext += deviceTime;
        } else if (functionCallName == "getDeviceNetworkInfo") {
          setSystemMessage('getting network info...');
          final networkInfo = await getDeviceNetworkInfo();
          advancedContext += networkInfo;
        } else if (functionCallName == "getCurrentLocation"){
          setSystemMessage("getting current location...");
          final locationInfo = await getCurrentLocation();
          advancedContext += locationInfo;

        } else if (functionCallName == "getDeviceSpecs") {
          setSystemMessage('getting device specs...');
          final deviceSpecs = await getDeviceSpecs();
          advancedContext += deviceSpecs;
        } else if (functionCallName == "getDeviceApps") {
          setSystemMessage('getting installed apps...');
          final deviceApps =
              await getDeviceApps(installedAppsLength, installedAppsString);
          advancedContext += deviceApps;
        } else if (functionCallName == "getCallLogs") {
          setSystemMessage('getting call logs...');
          final callLogs = await getCallLogs();
          advancedContext += callLogs;
        } else if (functionCallName == "getSMS") {
          setSystemMessage('getting text messages...');
          final sms = await getSMS();
          advancedContext += sms;
        } else if (functionCallName == "getDeviceBattery") {
          setSystemMessage('getting battery level and status...');
          final batteryInfo = await getDeviceBattery();
          advancedContext += batteryInfo;
        } else if (functionCallName == "getReddit") {
          setSystemMessage('reading reddit posts...');
          final headlines = await getReddit(eachFunctionCall.args);
          advancedContext += headlines;
        }
        await continueFromFunctionCall(userInput, advancedContext);

      }

    }

    print(advancedContext);
  }

  Future<void> continueFromFunctionCall(userInput, context) async {
    final chat = model.startChat(history: []);
    final content = Content.text(
        "$userInput CONTEXT: $context. CHAT-HISTORY: ${chatHistory.toString()}");

    final stream = chat.sendMessageStream(content);
    String accumulatedResponse = '';
    bool isFirstChuck = true;
    await for (final response in stream) {
      if (response.text != null && response.text!.isNotEmpty) {
        accumulatedResponse += response.text!;
        if (isFirstChuck) {
          gotResponseFromAI(accumulatedResponse, isFirstChuck);
          isFirstChuck = false;
        } else {
          gotResponseFromAI(accumulatedResponse, isFirstChuck);
        }
      }
    }
    animateChatHistoryToBottom();
  }

  void animateChatHistoryToBottom() {
    scrollController.animateTo(
      scrollController.position.extentTotal,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void setSystemMessage(
    systemMessage, {
    isError = false,
  }) {
    setState(() {
      if (chatHistory[chatHistory.length - 1]['from'] == 'system') {
        chatHistory.removeAt(chatHistory.length - 1);
      }
      chatHistory.add({
        "from": "system",
        "content": systemMessage.toString().trim().toLowerCase(),
        "isError": isError,
      });
    });
  }

  void summarizeText({fromUserInput = false}) async {
    final model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      systemInstruction: Content(
        'ai',
        [TextPart('Summarize the texts given to you as short as possible.')],
      ),
    );
    var userInput = '';

    // Input from user
    if (fromUserInput == true &&
        userMessageController.text.trim().isEmpty == false) {
      userInput = userMessageController.text.trim();
      userMessageController.clear();
      addUserInputToChatHistory(userInput);
      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final stream = chat.sendMessageStream(content);
      String accumulatedResponse = '';
      bool isFirstChuck = true;
      await for (final response in stream) {
        if (response.text != null && response.text!.isNotEmpty) {
          accumulatedResponse += response.text!;
          if (isFirstChuck) {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
            isFirstChuck = false;
          } else {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
          }
        }
      }
      animateChatHistoryToBottom();
    } else if (sharedList != null &&
        sharedList!.isNotEmpty &&
        sharedList![0].value != null) {
      // Shared from another app
      var sharedString = '';
      for (var eachSharedContent in sharedList!) {
        sharedString += '${eachSharedContent.value!} ';
      }
      userInput = sharedString;
      addUserInputToChatHistory(userInput);
      final chat = model.startChat(history: []);
      final content = Content.text(userInput);
      final stream = chat.sendMessageStream(content);
      String accumulatedResponse = '';
      bool isFirstChuck = true;
      await for (final response in stream) {
        if (response.text != null && response.text!.isNotEmpty) {
          accumulatedResponse += response.text!;
          if (isFirstChuck) {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
            isFirstChuck = false;
          } else {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
          }
        }
      }
      animateChatHistoryToBottom();
    }
  }

  bool areMessagesInContext = false;
  bool areCallsInContext = false;
  bool isDeviceInContext = false;
  bool areAppsInContext = false;
  bool isBatteryInContext = false;
  bool isSummarizeInContext = false;

  void toggleSummarizeContext() {
    setState(() {
      isSummarizeInContext = !isSummarizeInContext;
    });
  }

  void clearConversation() {
    setState(() {
      chatHistory = [];
    });
  }

  dynamic isOneSidedChatMode = true;
  void toggleOneSidedChatMode() async {
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode") ?? true;

    setState(() {
      isOneSidedChatMode = !isOneSidedChatMode;
    });
    await settingBox.put("isOneSidedChatMode", isOneSidedChatMode);
    Hive.close();
  }

  final SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  bool isInVoiceMode = false;
  void toggleVoiceMode() async {
    setState(() {
      isInVoiceMode = !isInVoiceMode;
    });
    if (isInVoiceMode == false) {
      await flutterTts.stop();
    }
  }

  void startListening() async {
    speak("", stopSpeaking: true);
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      userMessageController.text = lastWords;
    });
    if (speechToText.isNotListening) {
      chatWithAI();
    }
  }

  String apiKey = '';
  bool isAddingAPIKey = false;
  TextEditingController apiKeyController = TextEditingController();

  Future<void> getSettings() async {
    // Is One Sided Chat Mode
    Box settingBox = await Hive.openBox("settings");
    isOneSidedChatMode = await settingBox.get("isOneSidedChatMode") ?? true;

    // Get API Key
    apiKey = await settingBox.get("apikey") ?? "";
    if (apiKey == "") {
      isAddingAPIKey = true;
    } else {
      isAddingAPIKey = false;
    }
    setState(() {});

    // Close
    await Hive.close();

    // Model Initialization
    modelInitialization();
  }

  bool isImageFile(String? extension) {
    if (extension == null) return false;
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  Future<void> _pickFile() async {
    setState(() {
      _loading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final file = result.files.first;
      attachedFileName = file.name;
      // Use isImageFile to confirm if the file is an image.
      setState(() {
        attachedFileBytes = file.bytes;
        attachedMime = _determineMimeType(file.extension);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _loading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() {
          _loading = false;
        });
        return;
      }
      setState(() {
        // Only update attachment state, do not add to chatHistory
        attachedImageBytes = result.files.first.bytes;
        attachedMime = _determineMimeType(result.files.first.extension);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

// dart
  Future<void> _pickAudioFile() async {
    setState(() {
      _loading = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final file = result.files.first;
      attachedFileName = file.name;
      attachedFileBytes = file.bytes;
      // Set MIME type based on extension.
      if (file.extension?.toLowerCase() == 'mp3') {
        attachedMime = 'audio/mpeg';
      } else if (file.extension?.toLowerCase() == 'm4a') {
        attachedMime = 'audio/m4a';
      } else {
        attachedMime = 'application/octet-stream';
      }
      setState(() {
        // Do not add to chatHistory immediately.
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _captureImageFromCamera() async {
    setState(() {
      _loading = true;
    });
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      attachedImageBytes = await image.readAsBytes();
      attachedMime = _determineMimeType(image.path.split('.').last);
      setState(() {
        // Do not add to chatHistory immediately.
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void chatWithAI() async {
    final userInput = userMessageController.text.trim();
    if (userInput.isEmpty &&
        attachedFileBytes == null &&
        attachedImageBytes == null) {
      // No input to process.
      return;
    }

    userMessageController.clear();
    final Map<String, dynamic> message = {
      "from": "user",
      "content": userInput,
    };

    Content content;
    // Check if an attachment exists.
    if ((attachedFileBytes != null || attachedImageBytes != null) &&
        attachedMime != null) {
      Uint8List attachmentData = attachedFileBytes ?? attachedImageBytes!;

      // Create a multi-part message.
      content = Content.multi([
        TextPart(userInput),
        DataPart(attachedMime!, attachmentData),
      ]);

      // Update message with attachment preview.
      if (attachedImageBytes != null && attachedMime!.startsWith('image/')) {
        message["image"] = attachedImageBytes;
      } else {
        message["file"] = {
          "name": attachedFileName,
          "bytes": attachmentData,
          "mime": attachedMime,
          "isAudio": attachedMime!.startsWith('audio/'),
        };
      }
    } else {
      // For text-only input, send just the text.
      content = Content.text(userInput);
    }

    // Add user message to chat history.
    setState(() {
      chatHistory.add(message);
    });

    // Clear any pending attachment state.
    removeAttachment();
    final List<Content> chatHistoryContent = chatHistory
        .map<Content>((msg) => Content.text(msg['content'] as String))
        .toList();
    try {
      setSystemMessage("getting response...");

      final chat = model.startChat(history: chatHistoryContent);
      final stream = chat.sendMessageStream(content);
      String accumulatedResponse = '';
      bool isFirstChuck = true;
      await for (final response in stream) {
        if (response.text != null && response.text!.isNotEmpty) {
          accumulatedResponse += response.text!;
          if (isFirstChuck) {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
            isFirstChuck = false;
          } else {
            gotResponseFromAI(accumulatedResponse, isFirstChuck);
          }
        }
        if (response.functionCalls.isNotEmpty) {
          await functionCallHandler(userInput, response.functionCalls);
        }
      }
      animateChatHistoryToBottom();
    } catch (e) {
      setSystemMessage(e, isError: true);
      if (isInVoiceMode) {
        speak(e.toString());
      }
    }
  }

// dart
  String _determineMimeType(String? extension) {
    if (extension == null) return 'application/octet-stream';

    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
        return 'audio/m4a';
      default:
        return 'application/octet-stream';
    }
  }

  void modelInitialization() {
    // Model
    model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 1,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 8192,
        responseMimeType: 'text/plain',
      ),
      // systemInstruction: Content('ai', [TextPart(advancedContext)]),
      systemInstruction: Content('system', [TextPart(systemPrompt)]),
      tools: [
        Tool(
          functionDeclarations: functionDeclarations,
        ),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: FunctionCallingConfig(
          mode: FunctionCallingMode.auto,
        ),
      ),
    );
  }

// dart
  void removeAttachment() {
    setState(() {
      // Remove pending attachment from chatHistory if it exists as the last message.
      if (chatHistory.isNotEmpty) {
        final lastMessage = chatHistory.last;
        if (lastMessage['from'] == "user" &&
            (lastMessage.containsKey('file') ||
                lastMessage.containsKey('image')) &&
            (lastMessage['content'] as String).isEmpty) {
          chatHistory.removeLast();
        }
      }
      // Clear attachment state
      attachedImageBytes = null;
      attachedFileBytes = null; // Clear file bytes as well
      attachedMime = null;
    });
  }

  void initializations() async {
    // Clear Chat
    chatHistory = [];

    // Get Preferences
    await getSettings();

    // Init TTS
    await speechToText.initialize();

    // Get Shared Files
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = FlutterSharingIntent.instance
        .getMediaStream()
        .listen((List<SharedFile> value) {
      setState(() {
        sharedList = value;
        summarizeText();
      });
      // print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {});

    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance
        .getInitialSharing()
        .then((List<SharedFile> value) {
      // print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      setState(() {
        sharedList = value;
        summarizeText();
      });
    });

    _intentDataStreamSubscription.onDone(() => summarizeText());
  }

  late StreamSubscription _intentDataStreamSubscription;
  List<SharedFile>? sharedList;
  @override
  void initState() {
    super.initState();
    initializations();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppbar(
        toggleAPIKey: () {
          setState(() {
            isAddingAPIKey = !isAddingAPIKey;
          });
        },
        toggleOneSidedChatMode: toggleOneSidedChatMode,
        isOneSidedChatMode: isOneSidedChatMode,
        clearConversation: clearConversation,
      ),
      // Chat
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          isAddingAPIKey == true
              ? Remarks()
              : chatHistory.isEmpty
                  ? PromptSuggestionsFeed(
                      chatWithAI: chatWithAI,
                      userMessageController: userMessageController,
                      isOneSidedChatMode: isOneSidedChatMode,
                    )
                  : ConversationFeed(
                      isOneSidedChatMode: isOneSidedChatMode,
                      scrollController: scrollController,
                      chatHistory: chatHistory,
                    ),
          Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showingAttachmentOptions)
                  AttachFilePopupMenu(
                    onPickFile: () {
                      _pickFile();
                      setState(() {
                        _showingAttachmentOptions = false;
                      });
                    },
                    onPickImage: () {
                      _pickImageFromGallery();
                      setState(() {
                        _showingAttachmentOptions = false;
                      });
                    },
                    onPickAudio: () {
                      _pickAudioFile();
                      setState(() {
                        _showingAttachmentOptions = false;
                      });
                    },
                    onPickCamera: () {
                      _captureImageFromCamera();
                      setState(() {
                        _showingAttachmentOptions = false;
                      });
                    },
                  ),

                // Attachment Preview
                AttachmentPreview(
                  attachedFileBytes: attachedFileBytes,
                  attachedImageBytes: attachedImageBytes,
                  attachedMime: attachedMime,
                  attachedFileName: attachedFileName,
                  removeAttachment: removeAttachment,
                ),

                // Main Input Box
                isAddingAPIKey == true
                    ? APIKeyInput(
                        getSettings: getSettings,
                      )
                    : InputBox(
                        chatWithAI: chatWithAI,
                        onPickFile: () {
                          _pickFile();
                        },
                        onPickImage: () {
                          _pickImageFromGallery();
                        },
                        onPickAudio: () {
                          _pickAudioFile();
                        },
                        onPickCamera: () {
                          _captureImageFromCamera();
                        },
                        summarizeText: summarizeText,
                        isSummarizeInContext: isSummarizeInContext,
                        userMessageController: userMessageController,
                        startListening: startListening,
                        stopListening: stopListening,
                        speechToText: speechToText,
                        toggleVoiceMode: toggleVoiceMode,
                        isInVoiceMode: isInVoiceMode,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
