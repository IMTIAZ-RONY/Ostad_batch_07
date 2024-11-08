

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class AuthController {
  static const String _accessTokenKey = 'access-token';
  static const String _userDataKey = 'user-data';

  static String? accessToken;
  static UserModel? userData;

  // Method to reset password with API call
  static Future<NetworkResponse> resetPassword(String newPassword, String otp, String email) async {
    final response = await NetworkCaller.postRequest(
      url: Urls.recoverResetPassword,
      body: {
        'email': email,
        'OTP': otp,
        'password': newPassword
      },
    );
    return response;
  }

  // Method to request OTP using email and OTP
  static Future<NetworkResponse> requestOTP(String email, String otp) async {
    final response = await NetworkCaller.getRequest(
      url: Urls.requestOtp(email, otp),
    );
    return response;
  }

  // Verify email recovery with API call
  static Future<NetworkResponse> recoverVerifyEmail(String email) async {
    final response = await NetworkCaller.getRequest(
      url: Urls.recoverVerifyEmail(email),
    );
    return response;
  }

  // Save access token in SharedPreferences
  static Future<void> saveAccessToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
    print("Token saved: $token");  // Debug print
  }

  // Save user data in SharedPreferences
  static Future<void> saveUserData(UserModel userModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(userModel.toJson()));
    userData = userModel;
  }

  // Retrieve access token from SharedPreferences
  static Future<String?> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString(_accessTokenKey);
    print("Token retrieved: $accessToken");  // Debug print
    return accessToken;
  }

  // Get user data from SharedPreferences
  static Future<UserModel?> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userEncodedData = sharedPreferences.getString(_userDataKey);
    if (userEncodedData == null) {
      return null;
    }
    userData = UserModel.fromJson(jsonDecode(userEncodedData));
    return userData;
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return accessToken != null;
  }

  // Clear only access token and user data from SharedPreferences
  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove(_accessTokenKey);
    await sharedPreferences.remove(_userDataKey);
    accessToken = null;
    print("User data and token cleared");  // Debug print
  }
}
