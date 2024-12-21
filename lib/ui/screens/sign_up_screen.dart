import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/data/models/network_response.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';
import 'package:ostad_batch_07/ui/utils/assets_path.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/screen_background.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';

import '../../data/utils/urls.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
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
                  "Join With Us",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSignUpForm(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
                      _buildSignInSection(),
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

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
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
                return "Enter valid email";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _firstNameTEController,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your first name',
              labelText: 'First Name',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Enter First Name";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _lastNameTEController,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your last name',
              labelText: 'Last Name',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Enter Last Name";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _mobileTEController,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
            keyboardType: TextInputType.phone,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your mobile number',
              suffixIcon: Icon(
                Icons.mobile_friendly_rounded,
                size: 20,
              ),
              labelText: 'Mobile',
            ),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Enter valid mobile number";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode:AutovalidateMode.onUserInteraction ,
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
                return "Enter your password";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !_inProgress,
            replacement:const CenteredCircularProgressIndicator(),
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

  Widget _buildSignInSection() {
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
              text: "Sign In",
              style: const TextStyle(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
            )
          ]),
    );
  }

  void _onTapSignIn() {
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    if(!mounted)return;// Ensure the widget is still in the widget tree.
    setState(() {
      _inProgress = true;
    });
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    try{
      NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.registration,
      body: requestBody,
    );
    if(!mounted)return;
    setState(() {
      _inProgress = false;
    });
    if (response.isSuccess) {
      _clearTextFields();
      ShowSnackBarMessage(context, 'Created New User');
    } else {
      ShowSnackBarMessage(context, response.errorMessage, true);
    }
    }catch(e){
      if (mounted) {
        setState(() {
          _inProgress = false;
        });
        ShowSnackBarMessage(context, 'Something went wrong: $e', true);
      }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }
}
