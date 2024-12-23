import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ostad_batch_07/ui/screens/pin_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_up_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';
import 'package:ostad_batch_07/ui/widgets/screen_background.dart';

class SetPasswordScreen extends StatefulWidget {
  static const String name="/SetPasswordScreen";
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() =>
      _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
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
                  "Set Your Password",
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Minimum number of password should be 8 letters .",
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSetPassWordForm(),
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

  Widget _buildSetPassWordForm() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          cursorColor: Colors.green,
          decoration: const InputDecoration(
            hintText: 'Set your password',
            suffixIcon: Icon(
              Icons.remove_red_eye,
              size: 20,
            ),
            labelText: 'Password',
          ),
        ),
        const SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.text,
          cursorColor: Colors.green,
          decoration: const InputDecoration(
            hintText: 'Confirm your password',
            suffixIcon: Icon(
              Icons.remove_red_eye,
              size: 20,
            ),
            labelText: 'Confirm Password',
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
          text: "have an account?",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          children: [
            TextSpan(
              text: "Sign in",
              style: const TextStyle(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignIn,
            )
          ]),
    );
  }

  void _onTapSignIn() {
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const SignInScreen()), (_)=>false);
    Get.offAll(SignInScreen.name);
  }

  void _onTapNextButton() {
   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(_)=>const SignInScreen()), (_)=>false);
  Get.offAll(SignInScreen.name);
  }
}
