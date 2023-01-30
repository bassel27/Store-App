import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BaseClient {
  static const int TIME_OUT_DURATION = 2;

  /// Returns the decoded reponse.
  static Future<dynamic> get(String url) async {
    try {
      var response = await http.get(Uri.parse(url));

      return _processResponse(response);
    } on SocketException {
      throw _MyException('No internet connection');
    }
  }

  /// Returns the decoded reponse.
  static Future<dynamic> post(String url, Map payloadInput) async {
    try {
      var response = await http
          .post(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw _MyException("No internet connection");
    }
  }

  /// Decode response.
  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return responseJson;

      case 201:
        var responseJson = json.decode(response.body);
        return responseJson;

      case 400:
        throw _MyException(
            "${json.decode(response.body)}, ${response.request!.url}");
      case 401:
      case 403:
        throw _MyException(
            "${json.decode(response.body)}, ${response.request!.url}");
      case 422:
        throw _MyException(
            "${json.decode(response.body)}, ${response.request!.url}");
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
