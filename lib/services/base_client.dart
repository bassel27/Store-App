import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exception.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 5;
  //TODO: get, patch and put use the same functioon
  /// Returns the decoded reponse's body.
  static Future<dynamic> get(String url) async {
    try {
      var response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: TIME_OUT_DURATION));

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', url);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Check your internet connection and try again');
    } catch (e) {
      Exception('An error occurred. Contact system administrator');
    }
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> put(String url, Map payloadInput) async {
    try {
      var response = await http
          .put(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Check your internet connection and try again', url);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Check your internet connection and try again', url);
    } catch (e) {
      Exception('An error occurred. Contact system administrator');
    }
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> post(String url, Map payloadInput) async {
    try {
      var response = await http
          .post(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Check your internet connection and try again', url);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Check your internet connection and try again', url);
    } catch (e) {
      Exception('An error occurred. Contact system administrator');
    }
  }

  /// Returns the decoded reponse.
  static Future<dynamic> patch(String url, Map payloadInput,
      {timeOutDuration = TIME_OUT_DURATION}) async {
    try {
      var response = await http
          .patch(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(Duration(seconds: timeOutDuration));

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', url);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Check your internet connection and try again', url);
    } catch (e) {
      Exception('An error occurred. Contact system administrator');
    }
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> delete(String url) async {
    try {
      var response = await http
          .delete(Uri.parse(url))
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
          'Check your internet connection and try again', url);
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Check your internet connection and try again', url);
    } catch (e) {
      Exception('An error occurred. Contact system administrator');
    }
  }

  /// Decode response.
  static dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJsonBody = json.decode(response.body);
        return responseJsonBody;

      case 201:
        var responseJsonBody = json.decode(response.body);
        return responseJsonBody;

      case 400:
        throw BadRequestException(
            "${json.decode(response.body)}, ${response.request!.url}");
      case 401:
      case 403:
        throw UnAuthorizedException(
            "${json.decode(response.body)}, ${response.request!.url}");
      case 422:
        throw BadRequestException(
            "${json.decode(response.body)}, ${response.request!.url}");
      case 500:
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}, ${response.request!.url.toString()}');
    }
  }

  static String getObjectIdByResponse(Map responseDecodedBody) {
    return responseDecodedBody["name"];
  }
}
