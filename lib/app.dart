import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:ostad_batch_07/ui/screens/home_screens.dart';

import 'business_logic/controllers/counter_controller.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),  // Base Design for Responsiveness
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding:ControllerBinder() ,
          home: const HomeScreen(),
        );
      },
    );
  }

}
class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(CounterController());
  }

}
