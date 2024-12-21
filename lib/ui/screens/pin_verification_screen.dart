import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/ui/screens/email_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/set_password_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_up_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';
import 'package:ostad_batch_07/ui/widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme
        .of(context)
        .textTheme;
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
                  "PIN Verification",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8,),
                Text(
                  "A 6 digits verification otp has been sent to your email address.",
                  style: textTheme.titleSmall
                      ?.copyWith(color: Colors.grey),
                ),

                const SizedBox(
                  height: 24,
                ),
                _buildPinVerificationForm(),
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

  Widget _buildPinVerificationForm() {
    return Column(
      children: [
        PinCodeTextField(
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
            inactiveFillColor: Colors.white,
            selectedFillColor: Colors.white,


          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,

          enableActiveFill: true,
          appContext: context,
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: _onTapNextButton,
          child: const Text("Verify"),
        ),
      ],
    );
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
          text: "Have an account?",
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
              recognizer: TapGestureRecognizer()
                ..onTap = _onTapSignIn,
            )
          ]),
    );
  }

  void _onTapSignIn() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const SignInScreen()), (
        _) => false);
  }

  void _onTapNextButton() {
    Navigator.push(context, MaterialPageRoute(builder:(_)=>const SetPasswordScreen() ));
  }


}
