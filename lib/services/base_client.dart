import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BaseClient {
  /// Returns the decoded reponse.
  static Future<dynamic> get(String url) async {
    var uri = Uri.parse(url);
    try {
      var response = await http.get(uri);
      return _processResponse(response);
    } on SocketException {
      throw _MyException("No internet connection");
    }
  }
  /// Returns the decoded reponse.
  static Future<dynamic> post(String url, Map payloadInput) async {
    try {
      var response =
          await http.post(Uri.parse(url), body: json.encode(payloadInput));
      return _processResponse(response);
    } on SocketException {
      throw _MyException("No internet connection");
    }
  }

  /// Decode response.
  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
        break;
      case 201:
        var responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
        break;
      case 400:
        throw _MyException(
            "${utf8.decode(response.bodyBytes)}, ${response.request!.url}");
      case 401:
      case 403:
        throw _MyException(
            "${utf8.decode(response.bodyBytes)}, ${response.request!.url}");
      case 422:
        throw _MyException(
            "${utf8.decode(response.bodyBytes)}, ${response.request!.url}");
      case 500:
      default:
        throw _MyException(
            'Error occured with code : ${response.statusCode}, ${response.request!.url.toString()}');
    }
  }
}

class _MyException {
  _MyException(this.message);
  String message;
  @override
  String toString() {
    return message;
  }
}
