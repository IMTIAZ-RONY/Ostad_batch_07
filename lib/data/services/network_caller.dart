//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../app.dart';
// import '../../ui/controllers/auth_controllers.dart';
// import '../../ui/screens/sign_in_screen.dart';
// import '../models/network_response.dart';
// import '../utils/urls.dart';
// class NetworkCaller {
//
//   static Future<NetworkResponse> getRequest({required String url}) async {
//     try {
//       Uri uri = Uri.parse(url);
//
//       // Fetch token from SharedPreferences if not already set
//       String? token = AuthController.accessToken;
//       if (token == null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         token = prefs.getString('access-token');
//         AuthController.accessToken = token; // Cache it in AuthController for future requests
//       }
//
//       Map<String, String> headers = {
//         'Authorization': 'Bearer $token', // Attach token to Authorization header
//         'Content-Type': 'application/json',
//       };
//
//       printRequest(url, null, headers);
//       final Response response = await get(uri, headers: headers);
//       printResponse(url, response);
//
//       if (response.statusCode == 200) {
//         final decodeData = jsonDecode(response.body);
//         return NetworkResponse(
//           isSuccess: true,
//           statusCode: response.statusCode,
//           responseData: decodeData,
//         );
//       } else if (response.statusCode == 401) {
//         _moveToLogin();
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Unauthenticated!',
//         );
//       } else {
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Failed with status code: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       return NetworkResponse(
//         isSuccess: false,
//         statusCode: -1,
//         errorMessage: e.toString(),
//       );
//     }
//   }
//
//   static Future<NetworkResponse> postRequest({
//     required String url,
//     Map<String, dynamic>? body,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//
//       // Fetch token from SharedPreferences if not already set
//       String? token = AuthController.accessToken;
//       if (token == null) {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         token = prefs.getString('access-token');
//         AuthController.accessToken = token;
//       }
//
//       Map<String, String> headers = {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       };
//
//       printRequest(url, body, headers);
//       final Response response = await post(
//         uri,
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       printResponse(url, response);
//
//       if (response.statusCode == 200) {
//         final decodeData = jsonDecode(response.body);
//
//         if (decodeData['status'] == 'fail') {
//           return NetworkResponse(
//             isSuccess: false,
//             statusCode: response.statusCode,
//             errorMessage: decodeData['data'],
//           );
//         }
//
//         return NetworkResponse(
//           isSuccess: true,
//           statusCode: response.statusCode,
//           responseData: decodeData,
//         );
//       } else if (response.statusCode == 401) {
//         _moveToLogin();
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Unauthenticated!',
//         );
//       } else {
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Failed with status code: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       return NetworkResponse(
//         isSuccess: false,
//         statusCode: -1,
//         errorMessage: e.toString(),
//       );
//     }
//   }
//
//   static void printRequest(
//       String url, Map<String, dynamic>? body, Map<String, String>? headers) {
//     debugPrint(
//       'REQUEST:\nURL: $url\nBODY: $body\nHEADERS: $headers',
//     );
//   }
//
//   static void printResponse(String url, Response response) {
//     debugPrint(
//       'URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}',
//     );
//   }
//
//   static Future<void> _moveToLogin() async {
//     await AuthController.clearUserData();
//     Navigator.pushAndRemoveUntil(
//       TaskManagerApp.navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
//           (route) => false,
//     );
//   }
// }
///ssdd
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../app.dart';
// import '../../ui/controllers/auth_controllers.dart';
// import '../../ui/screens/sign_in_screen.dart';
// import '../models/network_response.dart';
// import '../utils/urls.dart';
//
// class NetworkCaller {
//   Future<void> sendRequestWithToken(String email) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('access-token');
//     if (token == null) {
//       print("Token is missing");
//       return;
//     }
//     final response = await NetworkCaller.getRequest(
//       url: Urls.recoverVerifyEmail(email),
//     );
//
//     if (response.isSuccess) {
//       print("Request successful");
//     } else {
//       print("Failed to fetch data: ${response.errorMessage}");
//     }
//   }
//
//   static Future<NetworkResponse> getRequest({required String url}) async {
//     try {
//       Uri uri = Uri.parse(url);
//
//       // Set up headers
//       String? token = AuthController.accessToken;
//       Map<String, String> headers = {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       };
//
//       printRequest(url, null, headers);
//       final Response response = await get(uri, headers: headers);
//       printResponse(url, response);
//
//       if (response.statusCode == 200) {
//         final decodeData = jsonDecode(response.body);
//         return NetworkResponse(
//           isSuccess: true,
//           statusCode: response.statusCode,
//           responseData: decodeData,
//         );
//       } else if (response.statusCode == 401) {
//         _moveToLogin();
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Unauthenticated!',
//         );
//       } else {
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//         );
//       }
//     } catch (e) {
//       return NetworkResponse(
//         isSuccess: false,
//         statusCode: -1,
//         errorMessage: e.toString(),
//       );
//     }
//   }
//
//   static Future<NetworkResponse> postRequest({
//     required String url,
//     Map<String, dynamic>? body,
//   }) async {
//     try {
//       Uri uri = Uri.parse(url);
//
//       // Set up headers
//       String? token = AuthController.accessToken;
//       Map<String, String> headers = {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       };
//
//       printRequest(url, body, headers);
//       final Response response = await post(
//         uri,
//         headers: headers,
//         body: jsonEncode(body),
//       );
//       printResponse(url, response);
//
//       if (response.statusCode == 200) {
//         final decodeData = jsonDecode(response.body);
//
//         if (decodeData['status'] == 'fail') {
//           return NetworkResponse(
//             isSuccess: false,
//             statusCode: response.statusCode,
//             errorMessage: decodeData['data'],
//           );
//         }
//
//         return NetworkResponse(
//           isSuccess: true,
//           statusCode: response.statusCode,
//           responseData: decodeData,
//         );
//       } else if (response.statusCode == 401) {
//         _moveToLogin();
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//           errorMessage: 'Unauthenticated!',
//         );
//       } else {
//         return NetworkResponse(
//           isSuccess: false,
//           statusCode: response.statusCode,
//         );
//       }
//     } catch (e) {
//       return NetworkResponse(
//         isSuccess: false,
//         statusCode: -1,
//         errorMessage: e.toString(),
//       );
//     }
//   }
//
//   static void printRequest(
//       String url, Map<String, dynamic>? body, Map<String, String>? headers) {
//     debugPrint(
//       'REQUEST:\nURL: $url\nBODY: $body\nHEADERS: $headers',
//     );
//   }
//
//   static void printResponse(String url, Response response) {
//     debugPrint(
//       'URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}',
//     );
//   }
//
//   static Future<void> _moveToLogin() async {
//     await AuthController.clearUserData();
//     Navigator.pushAndRemoveUntil(
//       TaskManagerApp.navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (context) => const SignInScreen()),
//           (p) => false,
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app.dart';
import '../../ui/controllers/auth_controllers.dart';
import '../../ui/screens/sign_in_screen.dart';
import '../models/network_response.dart';
import '../utils/urls.dart';

class NetworkCaller {
  Future<void> sendRequestWithToken(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access-token');
    if (token == null) {
      print("Token is missing");
      return;
    }
    final response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyEmail(email),
    );

    if (response.isSuccess) {
      print("Request successful");
    } else {
      print("Failed to fetch data: ${response.errorMessage}");
    }
  }

  // Fetch token if needed
  static Future<String?> getOrFetchToken() async {
    if (AuthController.accessToken == null) {
      await AuthController.getAccessToken(); // Fetch from SharedPreferences if not in memory
    }
    return AuthController.accessToken;
  }

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);

      // Fetch token
      String? token = await getOrFetchToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      printRequest(url, null, headers);
      final Response response = await get(uri, headers: headers);
      printResponse(url, response);

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodeData,
        );
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthenticated!',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      Uri uri = Uri.parse(url);

      // Fetch token
      String? token = await getOrFetchToken();
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      printRequest(url, body, headers);
      final Response response = await post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      printResponse(url, response);

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);

        if (decodeData['status'] == 'fail') {
          return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: decodeData['data'],
          );
        }

        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodeData,
        );
      } else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: 'Unauthenticated!',
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static void printRequest(
      String url, Map<String, dynamic>? body, Map<String, String>? headers) {
    debugPrint(
      'REQUEST:\nURL: $url\nBODY: $body\nHEADERS: $headers',
    );
  }

  static void printResponse(String url, Response response) {
    debugPrint(
      'URL: $url\nRESPONSE CODE: ${response.statusCode}\nBODY: ${response.body}',
    );
  }

  static Future<void> _moveToLogin() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
      TaskManagerApp.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (p) => false,
    );
  }
}


