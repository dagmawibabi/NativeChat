import 'package:google_generative_ai/google_generative_ai.dart';

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

  // Dark Mode
  FunctionDeclaration(
    "toggleDarkMode",
    'Turns darkmode on or off.',
    Schema.object(
      properties: {
        'mode': Schema.enumString(
          enumValues: ['dark', 'light', 'toggle'],
          description:
              "The theme mode to switch between. Choose toggle mode when unspecified.",
        ),
      },
    ),
  ),

  // Toggle One Sided Mode
  FunctionDeclaration(
    "toggleOneSidedChatMode",
    'Turns if the chat layout is one sided or in bubble format.',
    Schema.object(
      properties: {
        'isOneSided': Schema.boolean(
          description: "if the chat layout is one sided or in bubble format.",
        ),
      },
    ),
  ),

  // API Calls
  FunctionDeclaration(
    "getReddit",
    "Fetches the top daily content from a relevant subreddit. If the user does not specify a subreddit, one will be chosen automatically based on the context.",
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
            "gardening",
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
          description:
              "The subreddit to fetch content from. If unspecified, an appropriate subreddit will be chosen automatically.",
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
  ),

  // LOCATION
  FunctionDeclaration(
    "getCurrentLocation",
    "Gets the user's current location and address which includes latitude and longitude",
    Schema.object(
      properties: {
        'location': Schema.string(
          description: "The current location.",
        ),
      },
    ),
  ),

  // Save Memory
  FunctionDeclaration(
    "saveMemory",
    "Saves something about the user in your memory for future reference.",
    Schema.object(
      properties: {
        'newMemory': Schema.string(
          description:
              "The new memory you found in your chat to save in the memory bank.",
        ),
      },
    ),
  ),

  // Get Memories
  FunctionDeclaration(
    "getMemories",
    "Retrieves everything you remember about the user from previous conversations.",
    Schema.object(
      properties: {
        'memory': Schema.string(
          description: "The old memory you found saved.",
        ),
      },
    ),
  ),

  // Remove One Memory
  FunctionDeclaration(
    "forgetOneMemory",
    "Delete a particular memory about the user from memory.",
    Schema.object(
      properties: {
        'memory': Schema.string(
          description: "The sppecific memory you are removing",
        ),
      },
    ),
  ),

  // Remove Memories
  FunctionDeclaration(
    "forgetMemories",
    "Deletes everything you remember about the user from memory.",
    Schema.object(
      properties: {
        'memory': Schema.string(
          description: "The old memory you found saved.",
        ),
      },
    ),
  ),
];
