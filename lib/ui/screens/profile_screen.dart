import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/data/utils/urls.dart';
import 'package:ostad_batch_07/ui/controllers/auth_controllers.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/tm_app_bar.dart';

import '../../data/models/network_response.dart';
import '../../data/models/user_model.dart';
import '../widgets/show_snack_bar_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;

  @override
  void initState() {
    setUserData();
    super.initState();
  }

  void setUserData() {
    _emailTEController.text = AuthController.userData?.email ?? '';
    _firstNameTEController.text = AuthController.userData?.firstName ?? '';
    _lastNameTEController.text = AuthController.userData?.lastName ?? '';
    _mobileTEController.text = AuthController.userData?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const TMAppBar(
        isProfileScreenOpen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                "Update Profile ",
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 32,
              ),
              _buildUpdateForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPhotoPicker(),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            enabled: false,
            controller: _emailTEController,
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
              if (value?.trim().isEmpty ?? true) {
                return "Enter your email";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _firstNameTEController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              hintText: 'Write your first name',
              labelText: 'First Name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return "Enter your first Name";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _lastNameTEController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.green,
            decoration: const InputDecoration(
              hintText: 'Write your last name',
              labelText: 'Last Name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return "Enter your last name";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _mobileTEController,
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
              if (value?.trim().isEmpty ?? true) {
                return "Enter your mobile number";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _passwordTEController,
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
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !_updateProfileInProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapUpdateButton,
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

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody["password"] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody['photo'] = convertedImage;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.userProfileUpdate,
      body: requestBody,
    );
    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      ShowSnackBarMessage(context, "Profile has been updated!");
    } else {
      ShowSnackBarMessage(context, response.errorMessage);
    }
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Photo",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(_getSelectedPhotoTitle()),
          ],
        ),
      ),
    );
  }

  String _getSelectedPhotoTitle() {
    if (_selectedImage != null) {
      return _selectedImage!.name;
    }
    return "Selected Photo ";
  }

  Future<void> _pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
  }

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }
}
