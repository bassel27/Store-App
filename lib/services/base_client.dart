import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/constants.dart';
import 'app_exception.dart';

class BaseClient {
  static Future<dynamic> _tryProcessResponseAndCatchForm(
      Function sendHttpRequest, String url) async {
    try {
      var response = await sendHttpRequest();
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(kErrorMessage, url);
    } on TimeoutException {
      throw ApiNotRespondingException(kErrorMessage);
    } catch (e) {
      throw Exception();
    }
  }

  /// Returns the decoded reponse's body.
  ///
  /// Returns null if there's no objects.
  static Future<dynamic> get(String url) async {
    return await _tryProcessResponseAndCatchForm(() async {
      return await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: kDefaultTimeOutDuation));
    }, url);
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> put(String url, Map payloadInput,
      {int timeOutDuration = kDefaultTimeOutDuation}) async {
    return await _tryProcessResponseAndCatchForm(() async {
      return await http
          .put(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(Duration(seconds: timeOutDuration));
    }, url);
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> post(String url, Map payloadInput) async {
    return await _tryProcessResponseAndCatchForm(() async {
      return await http
          .post(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(const Duration(seconds: kDefaultTimeOutDuation));
    }, url);
  }

  /// Returns the decoded reponse.
  static Future<dynamic> patch(String url, Map payloadInput,
      {timeOutDuration = kDefaultTimeOutDuation}) async {
    return await _tryProcessResponseAndCatchForm(() async {
      return await http
          .patch(Uri.parse(url), body: json.encode(payloadInput))
          .timeout(Duration(seconds: timeOutDuration));
    }, url);
  }

  /// Returns the decoded reponse's body.
  static Future<dynamic> delete(String url,
      {int timeoutDuration = kDefaultTimeOutDuation}) async {
    return await _tryProcessResponseAndCatchForm(() async {
      return await http
          .delete(Uri.parse(url))
          .timeout(Duration(seconds: timeoutDuration));
    }, url);
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
