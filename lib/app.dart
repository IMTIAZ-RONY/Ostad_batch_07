import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ostad_batch_07/ui/screens/home_screens.dart';

class TaskManagersApp extends StatefulWidget {
  const TaskManagersApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

  @override
  State<TaskManagersApp> createState() => _TaskManagersAppState();
}

class _TaskManagersAppState extends State<TaskManagersApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),  // Base Design for Responsiveness
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        );
      },
    );
  }

}
