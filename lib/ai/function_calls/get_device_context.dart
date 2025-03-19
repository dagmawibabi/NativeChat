import 'package:battery_plus/battery_plus.dart';
import 'package:call_log_new/call_log_new.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_info2/system_info2.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

// Limits
var callsLimit = 100;
var smsLimit = 100;
Future<String> getDeviceNetworkInfo() async {
  await Permission.location.request();
  await Permission.nearbyWifiDevices.request();
  final info = NetworkInfo();

  // Initialize network detail variables.
  String wifiName = 'Unavailable';
  String wifiBSSID = 'Unavailable';
  String wifiIP = 'Unavailable';
  String wifiIPv6 = 'Unavailable';
  String wifiSubmask = 'Unavailable';
  String wifiBroadcast = 'Unavailable';
  String wifiGateway = 'Unavailable';

  try {
    wifiName = await info.getWifiName() ?? 'Unavailable';
  } on PlatformException {
    wifiName = 'Failed to retrieve Wifi Name';
  }
  try {
    wifiBSSID = await info.getWifiBSSID() ?? 'Unavailable';
  } on PlatformException {
    wifiBSSID = 'Failed to retrieve Wifi BSSID';
  }
  try {
    wifiIP = await info.getWifiIP() ?? 'Unavailable';
  } on PlatformException {
    wifiIP = 'Failed to retrieve Wifi IP';
  }
  try {
    wifiIPv6 = await info.getWifiIPv6() ?? 'Unavailable';
  } on PlatformException {
    wifiIPv6 = 'Failed to retrieve Wifi IPv6';
  }
  try {
    wifiSubmask = await info.getWifiSubmask() ?? 'Unavailable';
  } on PlatformException {
    wifiSubmask = 'Failed to retrieve Wifi Submask';
  }
  try {
    wifiBroadcast = await info.getWifiBroadcast() ?? 'Unavailable';
  } on PlatformException {
    wifiBroadcast = 'Failed to retrieve Wifi Broadcast';
  }
  try {
    wifiGateway = await info.getWifiGatewayIP() ?? 'Unavailable';
  } on PlatformException {
    wifiGateway = 'Failed to retrieve Wifi Gateway';
  }

  // Determine connection state using the WiFi IP.
  bool isConnected = wifiIP != 'Unavailable' && !wifiIP.startsWith('Failed');
  String connectionType = isConnected ? 'wifi' : 'none';
  String networkInterface = isConnected ? 'wlan0' : 'none';

  Map<String, String> networkDetails = {
    'Network Connection Type': connectionType,
    'Is Connected': isConnected.toString(),
    'WiFi Name': wifiName,
    'WiFi BSSID': wifiBSSID,
    'WiFi IP': wifiIP,
    'WiFi IPv6': wifiIPv6,
    'WiFi Submask': wifiSubmask,
    'WiFi Broadcast': wifiBroadcast,
    'WiFi Gateway': wifiGateway,
    'Network Interface': networkInterface,
  };

  // Build the advancedContext string.
  String advancedContext = "Here is your device network information:\n";
  for (var entry in networkDetails.entries) {
    advancedContext += "${entry.key}: ${entry.value}\n";
  }
  return advancedContext;
}

Future<String> getDeviceApps(installedAppsLength, installedAppsString) async {
  // Get Installed Apps
  if (installedAppsString == '') {
    await Permission.storage.request();
    List<AppInfo> apps = await InstalledApps.getInstalledApps();
    installedAppsLength = apps.length;
    for (var eachApp in apps) {
      installedAppsString +=
          'AppName: ${eachApp.name} PackageName:${eachApp.packageName} VersionName: ${eachApp.versionName} VersionCode:${eachApp.versionCode} InstalledTimestamp:${eachApp.installedTimestamp.toString()} \n';
    }
  }
  var advancedContext =
      "YOU HAVE $installedAppsLength APPS INSTALLED ON YOUR DEVICE AND HERE THEY ARE: $installedAppsString. NEVER LIST ALL THE APPS UNLESS SPECIFICALLY ASKED, IF ASKED ABOUT TIMESTAMPS CONVERT THEM TO HUMAN READABLE FORMATS.";

  return advancedContext;
}

Future<String> getDeviceSpecs() async {
  // Get System Info
  // var platformVersion = await DeviceInformation.platformVersion;
  // var imeiNo = await DeviceInformation.deviceIMEINumber;
  // var modelName = await DeviceInformation.deviceModel;
  // var manufacturer = await DeviceInformation.deviceManufacturer;
  // var apiLevel = await DeviceInformation.apiLevel;
  // var deviceName = await DeviceInformation.deviceName;
  // var productName = await DeviceInformation.productName;
  // var cpuType = await DeviceInformation.cpuName;
  // var hardware = await DeviceInformation.hardware;

  const int megabyte = 1024 * 1024;
  var coresInfo = '';
  final processors = SysInfo.cores;
  for (var processor in processors) {
    coresInfo +=
        'Architecture: ${processor.architecture} Name: ${processor.name} Socket: ${processor.socket} Vendor: ${processor.vendor}';
  }

  var systemInfo =
      'Kernel architecture: ${SysInfo.kernelArchitecture} Kernel bitness: ${SysInfo.kernelBitness} Kernel bitness: ${SysInfo.kernelBitness} Kernel name: ${SysInfo.kernelName} Kernel version: ${SysInfo.kernelVersion} Operating system name: ${SysInfo.operatingSystemName} Operating system version: ${SysInfo.operatingSystemVersion} User directory: ${SysInfo.userDirectory} User id: ${SysInfo.userId} User name: ${SysInfo.userName} User space bitness: ${SysInfo.userSpaceBitness} Total physical memory: ${SysInfo.getTotalPhysicalMemory() ~/ megabyte} MB Free physical memory: ${SysInfo.getFreePhysicalMemory() ~/ megabyte} MB Total virtual memory: ${SysInfo.getTotalVirtualMemory() ~/ megabyte} MB Free virtual memory: ${SysInfo.getFreeVirtualMemory() ~/ megabyte} MB Virtual memory size: ${SysInfo.getVirtualMemorySize() ~/ megabyte} MB Number of processors : ${processors.length} And info about each core: $coresInfo';

  // PlatformVersion: $platformVersion IMEI: $imeiNo ModelName: $modelName Manufacturer: $manufacturer API Level: $apiLevel DeviceName: $deviceName ProductName: $productName CPU Type: $cpuType Hardware: $hardware';

  var advancedContext =
      "HERE IS THE DEVICE'S SYSTEM INFORMATION AND SPECS $systemInfo";

  return advancedContext;
}

Future<String> getCallLogs() async {
  // Request permissions
  await Permission.phone.request();
  await Permission.contacts.request();

  final callLogs = await CallLog.fetchCallLogs();
  var messageString = '';
  var dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  for (var eachCallLog in callLogs) {
    var name = eachCallLog.name ?? 'Unknown Number';
    var callType = eachCallLog.callType?.name ?? 'Type unknown';
    // Convert timestamp into a human readable format
    var dateTime = DateTime.fromMillisecondsSinceEpoch(eachCallLog.timestamp!);
    var formattedTime = dateFormat.format(dateTime);
    var simDisplayName = eachCallLog.simDisplayName ?? 'Unknown SIM';
    var cachedNumberLabel = eachCallLog.cachedNumberLabel ?? 'Unknown Label';
    var duration = eachCallLog.duration ?? 00.00;
    messageString +=
        'Name: $name callType: $callType Number: ${eachCallLog.number} cachedNumberLabel: $cachedNumberLabel duration: $duration timestamp: $formattedTime simDisplayName: $simDisplayName \n';
  }

  var advancedContext =
      'YOUR LAST ${callLogs.length} CALL HISTORY: $messageString';
  return advancedContext;
}

Future<String> getSMS() async {
  await Permission.sms.request();

  // Get SMS
  SmsQuery query = SmsQuery();
  var allSMS = await query.querySms(
    count: smsLimit,
    kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
  );

  var messageString = '';
  for (var eachMessage in allSMS) {
    messageString +=
        'ID: ${eachMessage.id} From:${eachMessage.sender!} Content:${eachMessage.body!} Date:${eachMessage.date.toString()} isRead: ${eachMessage.isRead} kind(Sent or Recived): ${eachMessage.kind} \n';
  }

  var advancedContext = 'YOUR LAST $smsLimit SMS HISTORY: $messageString';
  return advancedContext;
}

Future<String> getDeviceBattery() async {
  // Get Battery Level and State
  var battery = Battery();
  var batteryLevel = await battery.batteryLevel;
  var batteryState = await battery.batteryState;

  var advancedContext =
      'THE BATTERY LEVEL IS $batteryLevel% AND IT IS ${batteryState.name}.';

  return advancedContext;
}

Future<String> getDeviceTime() async {
  // Get Device Time
  var now = DateTime.now();
  var advancedContext =
      'THE CURRENT DATE AND TIME IS ${now.toString()} AND THE TIMEZONE IS ${now.timeZoneName} FORMAT THIS TO HUMAN READABLE WHEN YOU RESPOND.';

  return advancedContext;
}