import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ostad_batch_07/ui/screens/add_new_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/cancelled_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/completed_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/email_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:ostad_batch_07/ui/screens/new_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/pin_verification_screen.dart';
import 'package:ostad_batch_07/ui/screens/profile_screen.dart';
import 'package:ostad_batch_07/ui/screens/progress_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/set_password_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_in_screen.dart';
import 'package:ostad_batch_07/ui/screens/sign_up_screen.dart';
import 'package:ostad_batch_07/ui/screens/splash_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';

import 'bussiness_logic/bindings/controller_bindings.dart';

class TaskManagersApp extends StatefulWidget {
  const TaskManagersApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

  @override
  State<TaskManagersApp> createState() => _TaskManagersAppState();
}

class _TaskManagersAppState extends State<TaskManagersApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey:TaskManagersApp.navigatorKey ,
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        colorSchemeSeed:AppColors.themeColor ,
        textTheme:const TextTheme(),
        inputDecorationTheme:_buildInputDecorationTheme() ,
        elevatedButtonTheme: _buildElevatedButtonThemeData(),
        useMaterial3:true,
    ),
      darkTheme:ThemeData(
        colorSchemeSeed:AppColors.themeColor ,
        textTheme:const TextTheme(),
        inputDecorationTheme:_buildInputDecorationTheme() ,
        elevatedButtonTheme: _buildElevatedButtonThemeData(),
        useMaterial3:true,

      ) ,
      themeMode:ThemeMode.system,
      initialBinding: ControllerBinder() ,
      initialRoute:"/" ,
      routes: {
        SplashScreen.name :(context)=>const SplashScreen(),
        MainBottomNavBarScreen.name :(context)=>const MainBottomNavBarScreen(),
        ProfileScreen.name :(context)=>const ProfileScreen(),
        AddNewTaskScreen.name:(context)=>const AddNewTaskScreen(),
        CancelledTaskScreen.name:(context)=>const CancelledTaskScreen(),
        CompletedTaskScreen.name:(context)=>const CompletedTaskScreen(),
        NewTaskScreen.name:(context)=>const NewTaskScreen(),
        EmailVerificationScreen.name:(context)=>const EmailVerificationScreen(),
        PinVerificationScreen.name:(context)=>const PinVerificationScreen (),
        ProgressTaskScreen.name:(context)=>const ProgressTaskScreen (),
        SetPasswordScreen.name:(context)=>const SetPasswordScreen (),
        SignInScreen.name:(context)=>const SignInScreen (),
        SignUpScreen.name:(context)=>const SignUpScreen (),

      },

        );
  }

  static ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style:ElevatedButton.styleFrom(
        backgroundColor:AppColors.themeColor,
        foregroundColor:Colors.white,
        fixedSize:const Size.fromWidth(double.maxFinite) ,
        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(8) ,
        ) ,
      ) ,
    );
  }




  static InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(

      alignLabelWithHint:true ,
     fillColor:Colors.white,
     filled: true,
     hintStyle:const TextStyle(fontWeight:FontWeight.w300 ) ,
     border:_outlineInputBorder(),
     errorBorder:_outlineInputBorder() ,
     enabledBorder:_outlineInputBorder() ,
     focusedBorder: _outlineInputBorder(),
    );
  }

 static OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
   borderSide:BorderSide.none,
   borderRadius:BorderRadius.circular(8) ,


);
  }
}
