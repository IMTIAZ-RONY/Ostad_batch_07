import 'package:get/get_state_manager/get_state_manager.dart';

import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controllers.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool?> signIn(String email, String password) async {
    _inProgress = true;
    update(); // Notify UI about the loading state

    bool isSuccess = false;

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    try {
      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.login,
        body: requestBody,
      );

      if (response.isSuccess) {
        LoginModel loginModel = LoginModel.fromJson(response.responseData);

        if (loginModel.token != null && loginModel.data != null) {
          await AuthController.saveAccessToken(loginModel.token!);
          await AuthController.saveUserData(loginModel.data!);
          isSuccess = true;
        } else {
          _errorMessage = "Invalid response from server";
        }
      } else {
        _errorMessage = response.errorMessage;
      }
    } catch (e) {
      _errorMessage = "Something went wrong: $e";
    } finally {
      _inProgress = false;
      update(); // Notify UI about the completion
    }

    return isSuccess;
  }
}
