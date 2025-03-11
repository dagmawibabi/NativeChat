import 'package:google_generative_ai/google_generative_ai.dart';

final String googleAIStudioURL = "https://aistudio.google.com/app/apikey";
final String github = "https://github.com/dagmawibabi/NativeChat";

final List promptSuggestions = [
  "What's the latest news",
  "Show me some memes",
  "What's the top post on r/AskReddit",
  "What are some side projects being built?",
  "Get my network state and information",
  "Show me 3 beautiful math equations",
  "Show me my device's specs in table form",
  'Tell me my unread text messages?',
  'How many cores does my phone have?',
  'What is the longest call I had?',
  'Is my phone charging?',
  'Do I have any recent missed calls?',
  'What is the sweetest text I got recently?',
  'How many apps do I have?',
  'Write code to find the Fibonacci sequence in Zig?',
  "Write a Python script to check if a number is prime",
  "Show me the latest quotes from famous philosophers",
  "Generate a workout plan for a beginner",
  "Tell me a fun fact about space exploration",
  "How much storage is available on my device?",
  "Generate a random inspirational quote",
  "Write a JavaScript function to reverse a string",
  "Give me a brief history of AI development",
  "Show me the calorie count of a cheeseburger",
  "CSS snippet to create a responsive navigation bar",
  "Generate a to-do list with time slots for productivity.",
  "Give me a summary of the apps I've installed recently",
  "What was the total duration of all calls made today?",
  "Tell me the time zone of my device",
  "How many unread messages do I have?",
  "Summarize my last 3 call in a table?",
  "Give me a summary of my last 5 text messages",
  "Let's play a game",
];

final String systemPrompt = '''
You are an intelligent and proactive AI assistant on the user's phone. Your goal is to provide helpful, insightful, and dynamic responses to any query, whether through direct reasoning, code generation, using provided context or using available function calls.

Core Directives:
- Be Autonomous & Proactive - Do not overly rely on function calls. If the available functions do not cover the request, use logical deduction, generate a possible response, or write relevant code.
- Coding Capabilities - You can write, analyze, and debug code in multiple languages without needing function calls. Always strive for correctness, best practices, and clarity- your code output.
- Context Awareness - Utilize any contextual information given to you before considering function calls. Apply reasoning, infer logical responses, and provide creat- problem-solving.
- Adaptive Communication - Explain your reasoning clearly when needed, be concise when appropriate, and adjust your tone based on the user's style and preference.
- Fallback & Intelligent Guessing - If no function exists to complete a request, intelligently generate a likely response based on common sense, data patterns, or a well-reaso- assumption.
- Decision-Making - If you believe a function call is necessary but unavailable, attempt to approximate the expected outcome through text or code rather than failing outright.
- Multi-Modal Capability - You can write text, code, structured data (like JSON or Markdown), and explanations seamlessly without unnecessary dependencies.

Function Call Usage:
- Use function calls when beneficial, but do not depend on them exclusively.
- If function calls lack necessary details, compensate by generating reasonable responses based on logic and prior knowledge.
- Prioritize efficiency, combining multiple sources of context, logic, and available tools for the best possible answer.

Markdown & LaTeX Support:
- When outputting LaTeX, use pure LaTeX syntax without embedding it inside Markdown.
- For Markdown responses, strictly use pure Markdown without LaTeX formatting.
- For mathematical explanations, use standalone LaTeX documents or environments when needed.
- When outputting LaTeX, use inline LaTeX syntax using '\$...\$' for formulas.
- For mathematical expressions, use inline math (e.g., '\$x^2 + y^2 = z^2\$') rather than block math unless specifically requested.
- Ensure clarity with LaTeX for inline mathematical explanations in all contexts. 

Reddit Links
- Format image and media link in markdown instead of just the URL. So it can be displayed properly. 
- You can display media in markdown using the following syntax: ![Alt text](URL)
- You can display images in markdown using the following syntax: ![Alt text](URL)

Time & System Awareness:
- You can access the current time and use it when relevant.
- Adapt responses dynamically to real-world context, schedules, and logical sequences.

You are not just an assistant; you are an autonomous AI problem solver, coder, and knowledge source.
''';

final functionDeclarations = [
  // TIME
  FunctionDeclaration(
    "getDeviceTime",
    "Gets the current date and time of the device, including the timezone.",
    Schema.object(properties: {
      'dateTime': Schema.string(
          description: "The current date and time in ISO 8601 format"),
      'timezone': Schema.string(description: "Includes the device's timezone."),
    }),
  ),

  // SPECS
  FunctionDeclaration(
    "getDeviceSpecs",
    "Gets all system specifications and hardware details about the device.",
    Schema.object(properties: {
      'kernelArchitecture': Schema.string(
          description:
              "The architecture of the device's kernel (e.g., x86_64, arm64)."),
      'kernelBitness': Schema.integer(
          description: "The bitness of the kernel (e.g., 32 or 64)."),
      'kernelName': Schema.string(
          description:
              "The name of the kernel (e.g., Linux, Darwin, Windows)."),
      'kernelVersion': Schema.string(
          description: "The version of the kernel installed on the device."),
      'operatingSystemName': Schema.string(
          description:
              "The name of the operating system running on the device."),
      'operatingSystemVersion': Schema.string(
          description:
              "The version of the operating system installed on the device."),
      'userDirectory': Schema.string(
          description: "The home directory path of the current user."),
      'userId': Schema.string(
          description: "The user ID of the currently logged-in user."),
      'userName': Schema.string(
          description: "The username of the currently logged-in user."),
      'userSpaceBitness': Schema.integer(
          description: "The bitness of the user space (e.g., 32 or 64)."),
      'totalPhysicalMemoryMB': Schema.integer(
          description: "Total amount of physical memory (RAM) in megabytes."),
      'freePhysicalMemoryMB': Schema.integer(
          description: "Available physical memory (RAM) in megabytes."),
      'totalVirtualMemoryMB': Schema.integer(
          description: "Total virtual memory size in megabytes."),
      'freeVirtualMemoryMB':
          Schema.integer(description: "Available virtual memory in megabytes."),
      'virtualMemorySizeMB': Schema.integer(
          description: "The size of allocated virtual memory in megabytes."),
      'numberOfProcessors': Schema.integer(
          description: "The number of processor cores available."),
      'coresInfo': Schema.array(
          items:
              Schema.string(description: "Details about each processor core.")),
    }),
  ),

  // CALL LOGS
  FunctionDeclaration(
    "getCallLogs",
    'Gets a list call history with details about each message. Which you can use to do more inference and statistics from.',
    Schema.object(properties: {
      'callLogs': Schema.array(
        items: Schema.object(properties: {
          'name': Schema.string(
              description:
                  "The contact name associated with the call, if available."),
          'callType': Schema.string(
              description: "The type of call: incoming, outgoing, or missed."),
          'number': Schema.string(
              description: "The phone number associated with the call."),
          'cachedNumberLabel': Schema.string(
              description: "The cached label for the number, if available."),
          'duration': Schema.integer(
              description: "The duration of the call in seconds."),
          'timestamp': Schema.string(
              description: "The timestamp of the call in ISO 8601 format."),
          'simDisplayName': Schema.string(
              description: "The name of the SIM card used for the call."),
        }),
      ),
    }),
  ),

  // SMS
  FunctionDeclaration(
    "getSMS",
    "Gets a list of the user's text messages with details, including sender, content, date, and whether the message was read. This list could contain private, work, transactional, bank, ISP, financial and many more information that can be used for further analysis and statistics.",
    Schema.object(properties: {
      'messages': Schema.array(
        items: Schema.object(properties: {
          'id': Schema.string(
              description: "A unique identifier for the message."),
          'from': Schema.string(
              description: "The sender's phone number or contact name."),
          'content':
              Schema.string(description: "The body of the text message."),
          'date': Schema.string(
              description:
                  "The timestamp when the message was sent or received, in ISO 8601 format."),
          'isRead': Schema.boolean(
              description:
                  "Indicates whether the message has been read (true) or not (false)."),
          'kind': Schema.string(
              description:
                  "Specifies if the message was 'Sent' or 'Received'."),
        }),
      ),
    }),
  ),

  // BATTERY
  FunctionDeclaration(
    "getDeviceBattery",
    "Gets the user's device battery level in percentage and its charging state.",
    Schema.object(properties: {
      'batteryLevel': Schema.integer(
          description: "The current battery level as a percentage (0-100)."),
      'batteryState': Schema.string(
          description:
              "The current state of the battery: charging, discharging, full, connectedNotCharging, or unknown."),
    }),
  ),

  // APPS
  FunctionDeclaration(
    "getDeviceApps",
    "Gets a count and list of all installed apps on the device. Use this function to check if a specific app is installed by searching for it in the returned list.",
    Schema.object(properties: {
      'installedApps': Schema.array(
        items: Schema.object(properties: {
          'appName': Schema.string(
              description: "The display name of the installed application."),
          'packageName': Schema.string(
              description: "The unique package identifier of the application."),
          'versionName': Schema.string(
              description:
                  "The human-readable version name of the application."),
          'versionCode': Schema.integer(
              description: "The internal version code of the application."),
          'installedTimestamp': Schema.string(
              description:
                  "The timestamp of when the application was installed, in ISO 8601 format."),
        }),
      ),
    }),
  ),

  //NETWORK STATE
  FunctionDeclaration(
    "getDeviceNetworkInfo",
    "Retrieves the current network connection details of the device, including connection type, WiFi details, and network interface information.",
    Schema.object(properties: {
      'networkDetails': Schema.object(properties: {
        'Network Connection Type': Schema.string(
            description:
                "The type of network connection (e.g., WiFi, Cellular, Ethernet)."),
        'Is Connected': Schema.boolean(
            description:
                "Indicates whether the device is currently connected to a network."),
        'WiFi Name': Schema.string(
            description: "The SSID (name) of the connected WiFi network."),
        'WiFi BSSID': Schema.string(
            description:
                "The BSSID (MAC address) of the connected WiFi network."),
        'WiFi IP': Schema.string(
            description:
                "The IPv4 address assigned to the device on the WiFi network."),
        'WiFi IPv6': Schema.string(
            description:
                "The IPv6 address assigned to the device on the WiFi network."),
        'WiFi Submask': Schema.string(
            description: "The subnet mask of the connected WiFi network."),
        'WiFi Broadcast': Schema.string(
            description:
                "The broadcast address of the connected WiFi network."),
        'WiFi Gateway': Schema.string(
            description:
                "The gateway (router) address of the connected WiFi network."),
        'Network Interface': Schema.string(
            description: "The name of the active network interface."),
      }),
    }),
  ),

  // NO CONTEXT
  FunctionDeclaration(
    "clearConversation",
    'Clears the current conversation history.',
    Schema.object(
      properties: {'clear': Schema.string()},
    ),
  ),

  // API Calls
  FunctionDeclaration(
    "getReddit",
    "Fetches the top daily content from a specific subreddit.",
    Schema.object(
      properties: {
        'subreddit': Schema.enumString(
          enumValues: [
            "Adventuretime",
            "AskBiology",
            "AskEngineers",
            "AskHistorians",
            "AskPhysics",
            "AskReddit",
            "AskRedditAfterDark",
            "AskScience",
            "askmath",
            "askpsychology",
            "Astronomy",
            "Astronomy_Help",
            "aws",
            "basketball",
            "beer",
            "biology",
            "biotech",
            "books",
            "business",
            "changemyview",
            "chemistry",
            "chemhelp",
            "cleanjokes",
            "coding",
            "computerscience",
            "compsci",
            "cooking",
            "dadjokes",
            "damnthatsinteresting",
            "dankmemes",
            "dataisbeautiful",
            "datascience",
            "dotnet",
            "dotnetcore",
            "economy",
            "EducationalGIFs",
            "elixir",
            "emacs",
            "entertainment",
            "erlang",
            "fitness",
            "flutter",
            "food",
            "football",
            "gadgets",
            "gaming",
            "groovy",
            "hackernews",
            "hacking",
            "haskell",
            "haskellquestions",
            "history",
            "howto",
            "humor",
            "interesting",
            "IWantToLearn",
            "java",
            "javahelp",
            "javascript",
            "Jokes",
            "learnjava",
            "learnjavascript",
            "learnprogramming",
            "lifehacks",
            "lisp",
            "linux",
            "localnews",
            "machinelearning",
            "MathHelp",
            "math",
            "memes",
            "mildlyinteresting",
            "MLQuestions",
            "movies",
            "music",
            "news",
            "node",
            "nostupidquestions",
            "offmychest",
            "oneliners",
            "OpenEd",
            "Physics",
            "politics",
            "productivity",
            "ProgrammerHumor",
            "ProgrammingLanguages",
            "programming",
            "psychology",
            "puns",
            "qualitynews",
            "reactjs",
            "regionalnews",
            "rust",
            "satisfying",
            "science",
            "scala",
            "selfimprovement",
            "showerthoughts",
            "SideProject",
            "softwaredevelopment",
            "solidity",
            "sports",
            "standupshots",
            "statistics",
            "technews",
            "technology",
            "tennis",
            "todayilearned",
            "travel",
            "tvshows",
            "weightlifting",
            "webdev",
            "worldnews",
            "YouShouldKnow"
          ],
          description: "The subreddits to fetch content from.",
        ),
        'time': Schema.enumString(
          enumValues: ["hour", "day", "week", "month", "year", "all"],
          description: "The time range for fetching content.",
        ),
        'listing': Schema.enumString(
          enumValues: ["new", "hot", "rising", "best", "random", "top"],
          description: "The sorting for fetching content.",
        ),
      },
    ),
  )
];

final String remarks =
    "This uses Gemini 2.0 Flash from google with a 1 million token context window. You can get a free api key from their website which will be sufficient for most of your tasks. \n\nUsing the free tier lets Google access your conversation history and private information so if you'd like a private version consider switching to a paid tier";
