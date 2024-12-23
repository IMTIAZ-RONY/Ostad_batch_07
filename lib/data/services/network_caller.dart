import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ostad_batch_07/app.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import '../../bussiness_logic/controllers/auth_controllers.dart';
import '../models/network_response.dart';

class NetworkCaller {
  /// Get Request
  static Future<NetworkResponse> getRequest({required String url}) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": AuthController.accessToken.toString(),
    };
    printRequest(url, null, headers);
    final Response response = await get(uri,headers:headers );
    printResponse(url, response);

    try {
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "Unauthenticated!");
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }
  /// Post Request
  static Future<NetworkResponse> postRequest({required String url, Map<String, dynamic>? body}) async {
    Uri uri = Uri.parse(url);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": AuthController.accessToken.toString(),
    };
    printRequest(url, body, headers);
    final Response response = await post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    printResponse(url, response);

    try {
      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        if (decodeData['status'] == 'fail') {
          return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              responseData: decodeData['data']);
        }

        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodeData);
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "Unauthenticated!");
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void printRequest(
      String url, Map<String, dynamic>? body, Map<String, dynamic>? headers) {
    debugPrint("Request:$url\nbody:$body,\nheaders:$headers");
  }

  static void printResponse(String url, Response response) {
    debugPrint(
        "$url\nResponse CODE:${response.statusCode}\nBody:${response.body}");
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(TaskManagersApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const SignInScreen()), (p) => false);
  }
}
