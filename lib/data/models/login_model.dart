
import 'package:ostad_batch_07/data/models/user_model.dart';

class LoginModel {
  String? status;
  UserModel? data; // Changed from List<UserModel>? to UserModel?
  String? token;

  LoginModel({this.status, this.data, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null; // Adjusted to handle single object
    token = json['token'];
  }
}
