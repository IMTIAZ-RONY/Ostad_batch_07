import 'package:flutter/material.dart';
import 'package:ostad_batch_07/ui/screens/profile_screen.dart';

import '../controllers/auth_controllers.dart';
import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AuthController.userData?.fullName ?? "",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
                Text(AuthController.userData?.email ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  )),
            ]),
          ),
          IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => SignInScreen()),
                    (_) => false);
              },
              icon: const Icon(Icons.logout))
        ]),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
