import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/data/models/login_model.dart';
import 'package:ostad_batch_07/data/models/network_response.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/ui/controllers/auth_controllers.dart';
import 'package:ostad_batch_07/ui/screens/email_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_up_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/screen_background.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';

import '../../data/utils/urls.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 82,
                ),
                Text(
                  "Start with us",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSignInForm(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: _onTapForgetPasswordButton,
                          child: const Text(
                            "Forget Password",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                      const SizedBox(
                        height: 4,
                      ),
                      _buildSignUpSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your E-mail',
              suffixIcon: Icon(
                Icons.email_outlined,
                size: 20,
              ),
              labelText: 'E-mail',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Insert your valid e-mail.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your Password',
              suffixIcon: Icon(
                Icons.remove_red_eye_outlined,
                size: 20,
              ),
              labelText: 'Password',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Insert your valid e-mail.";
              }
              if (value!.length >= 6) {
                return "Enter a password more than 6 letters";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !_inProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapNextButton,
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
          text: "Do n't have an account?",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: "Sign UP",
              style: const TextStyle(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUp,
            )
          ]),
    );
  }

  void _onTapSignUp() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  void _onTapForgetPasswordButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const EmailVerificationScreen()));
  }

  void _onTapNextButton() {
    _signIn();

  }

  /*Future<void> _signIn() async {
    if (!mounted) return;
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    try {
      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.login,
        body: requestBody,
      );
      if (!mounted) return;
      setState(() {
        _inProgress = false;
      });
      if (response.isSuccess) {
        LoginModel loginModel=LoginModel.fromJson(response.responseData);
        await AuthController.saveAccessToken(loginModel.token!);
        await AuthController.saveUserData(loginModel.data!);
        _clearTextFields();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainBottomNavBarScreen()),
                (value) => false);
        if (!mounted) return;
        ShowSnackBarMessage(context, "Successfully login");
        if (!mounted) return;
      } else {
        ShowSnackBarMessage(context, response.errorMessage, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inProgress = false;
        });
      }
      ShowSnackBarMessage(context, "Something went wrong :$e", true);
    }
  }*/
  Future<void> _signIn() async {
    if (!mounted) return;
    setState(() {
      _inProgress = true;
    });

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    try {
      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.login,
        body: requestBody,
      );

      if (!mounted) return;
      setState(() {
        _inProgress = false;
      });

      if (response.isSuccess) {
        LoginModel loginModel = LoginModel.fromJson(response.responseData);

        // Ensure token and user data are not null
        if (loginModel.token != null && loginModel.data != null) {
          await AuthController.saveAccessToken(loginModel.token!);
          await AuthController.saveUserData(loginModel.data!);

          _clearTextFields();

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainBottomNavBarScreen()),
                (value) => false,
          );

          if (!mounted) return;
          ShowSnackBarMessage(context, "Successfully logged in");
        } else {
          ShowSnackBarMessage(context, "Invalid response from server", true);
        }
      } else {
        ShowSnackBarMessage(context, response.errorMessage, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _inProgress = false;
        });
      }
      ShowSnackBarMessage(context, "Something went wrong: $e", true);
    }
  }

  void _clearTextFields(){
    _emailTEController.clear();
    _passwordTEController.clear();
  }
}
