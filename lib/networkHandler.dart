import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // logger used for arrange the result and error

class NetworkHandler {
  String baseurl = "http://fda.intertoons.com/api/V1";
  var log = new Logger(); // creating instance  for logger

  Future get(dynamic url) async {
    url = formatter(url);
    var response = await http
        .get(url, headers: {"Authorization": "Bearer akhil@intertoons.com"});
    log.i(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
  }

  Future post2(dynamic url, var body) async {
    url = formatter(url);
    var uri = Uri.parse(url);
    var response = await http.post(uri,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer akhil@intertoons.com"
        },
        body: json.encode(body));
    // log.i(response.body);
    return json.decode(response.body);
  }

  NetworkImage getImage(String path) {
    return NetworkImage(path);
  } // this is for accessing image from backend

  String formatter(String url) {
    return baseurl + url;
  }
}
