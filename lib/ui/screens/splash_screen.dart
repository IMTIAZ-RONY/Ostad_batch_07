import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ostad_batch_07/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import 'package:ostad_batch_07/ui/utils/assets_path.dart';
import '../../bussiness_logic/controllers/auth_controllers.dart';
import '../widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name='/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    _moveToNextScreen();
    super.initState();
  }
 Future<void> _moveToNextScreen()async{
   await Future.delayed(const Duration(seconds:3 ),);
   await AuthController.getAccessToken();
   if(AuthController.isLoggedIn()){
     await AuthController.getUserData();
     Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=>const MainBottomNavBarScreen()) ,
     );
   }else {
     Navigator.pushReplacement(
         context, MaterialPageRoute(builder: (_) => const SignInScreen()));
   }
 }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:ScreenBackground(
        child:Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center ,
            children: [
              SvgPicture.asset(
                AssetsPath.logoSvg,width:120,
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}


