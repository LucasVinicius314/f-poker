import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:f_poker/exceptions/invalid_data_exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static String get host => dotenv.env['API_URL'] ?? 'localhost:4001';

  static String get path => '/api/';

  static Uri scheme({
    required String uri,
    Map<String, dynamic>? queryParameters,
  }) =>
      kReleaseMode
          ? Uri.https(host, '$path$uri', queryParameters)
          : Uri.http(host, '$path$uri', queryParameters);

  static Future<Map<String, String>> get getHeaders async {
    return {
      'Content-type': 'application/json',
      'x-access-token': await getToken() ?? '',
    };
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-access-token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-access-token', token);
  }

  static Future<void> unsetToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('x-access-token');
  }

  static Future get(
    String uri,
    Map<String, String>? queryParameters, {
    bool prevent = false,
    required BuildContext? context,
  }) async {
    final headers = await getHeaders;
    final response = await http.get(
      scheme(uri: uri, queryParameters: queryParameters),
      headers: headers,
    );

    final decoded = _treat(
      uri: uri,
      response: response,
      headers: headers,
      prevent: prevent,
      method: 'GET',
    );

    return decoded;
  }

  static Future post(
    String uri,
    Map<String, dynamic> body, {
    bool prevent = false,
    required BuildContext? context,
  }) async {
    final headers = await getHeaders;
    final response = await http.post(
      scheme(uri: uri),
      headers: headers,
      body: jsonEncode(body),
    );

    final decoded = await _treat(
      uri: uri,
      response: response,
      headers: headers,
      prevent: prevent,
      method: 'POST',
    );

    return decoded;
  }

  static Future put(
    String uri,
    Map<String, String> body, {
    bool prevent = false,
    required BuildContext? context,
  }) async {
    final headers = await getHeaders;
    final response = await http.put(
      scheme(uri: uri),
      headers: headers,
      body: jsonEncode(body),
    );

    final decoded = await _treat(
      uri: uri,
      response: response,
      headers: headers,
      prevent: prevent,
      method: 'PUT',
    );

    return decoded;
  }

  static _log({
    required String uri,
    required http.Response response,
    required String method,
    required Map<String, String> headers,
  }) {
    print(
      '$method $path$uri ${((response.contentLength ?? 0) / 1000).toStringAsFixed(2)}KB',
    );
    print('>>>>>>>>>');
    print(headers);
    print('<<<<<<<<<');
    print(response.headers);
    print(response.body);
  }

  static Future<void> _updateHeaders({required http.Response response}) async {
    final _xAccessToken = response.headers['x-access-token'];
    if (_xAccessToken != null) await setToken(_xAccessToken);
  }

  static Future<String?> networkImageToBase64(String url) async {
    final response = await http.get(Uri.parse(url));
    return base64Encode(response.bodyBytes);
  }

  static Future<dynamic> _treat({
    required String uri,
    required http.Response response,
    required Map<String, String> headers,
    required bool prevent,
    required String method,
  }) async {
    _log(uri: uri, response: response, method: method, headers: headers);
    if (!prevent) await _updateHeaders(response: response);

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 299)
      throw InvalidDataException(message: decoded['message']);

    return decoded;
  }
}
