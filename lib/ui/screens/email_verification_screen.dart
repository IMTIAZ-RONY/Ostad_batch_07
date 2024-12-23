import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/ui/screens/pin_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_up_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';
import 'package:ostad_batch_07/ui/widgets/screen_background.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String name= "/EmailVerificationScreen";
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
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
                  "Your Email Address",
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "A 6 digits verification otp will be sent to your email address.",
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildVerifyEmailForm(),
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

  Widget _buildVerifyEmailForm() {
    return Column(
      children: [
        TextFormField(
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
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => const PinVerificationScreen()));
  }
}
