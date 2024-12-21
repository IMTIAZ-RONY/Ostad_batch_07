import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/ui/screens/splash_screen.dart';
import 'package:ostad_batch_07/ui/utils/app_colors.dart';

class TaskManagersApp extends StatefulWidget {
  const TaskManagersApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

  @override
  State<TaskManagersApp> createState() => _TaskManagersAppState();
}

class _TaskManagersAppState extends State<TaskManagersApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home:const SplashScreen(),

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
