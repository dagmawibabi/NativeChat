import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// Reddit
Future<String> getReddit(parameters) async {
  var subreddit = parameters['subreddit'].toString().trim();
  var time = parameters['time'].toString().trim();
  var listing = parameters['listing'].toString().trim();
  var baseURL =
      'https://www.reddit.com/r/$subreddit/$listing.json?t=$time&limit=20';

  var dio = Dio();
  var result = await dio.get(baseURL);
  var feed = result.data['data']['children'];

  var advancedContext =
      "HERE'S THE CONTENT FROM THE SUBREDDIT $subreddit: $feed";
  return advancedContext;
}

// OPEN STREET MAP
Future<String> getCurrentLocation() async {
  await Permission.location.request();

  Position position = await Geolocator.getCurrentPosition();
  var latitude = position.latitude;
  var longitude = position.longitude;

  var baseURL =
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude";

  var dio = Dio();
  var result = await dio.get(baseURL);
  dynamic address = result.data;

  var advancedContext =
      "BASED ON THE CURRENT LATITUDE AND LONGITUDE OF ($latitude,$longitude) YOUR ADDRESS IS ${jsonEncode(address)}. IF ADDRESS IS IDENTIFIED STATE THAT THE DATA WAS OBTAINED FROM [OPENSTREETMAP](openstreetmap.org/copyright)";
  return advancedContext;
}
