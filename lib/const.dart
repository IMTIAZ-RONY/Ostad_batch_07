import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final TextStyle largeFont =
TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.black);
final TextStyle normalFont =
TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black);

final TextStyle smallFont =
TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.grey);

SnackBar customSnackBar(BuildContext context) => SnackBar(
  content: Text(
    'Button Pressed!',
    style: normalFont.copyWith(color: Colors.white),
  ),
  backgroundColor: Colors.lightBlueAccent,
  action: SnackBarAction(
      label: "Close",
      textColor: Colors.yellow,
      onPressed: () {
        Navigator.canPop(context);
      }),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  behavior: SnackBarBehavior.floating,
  margin: const EdgeInsets.all(10),
  padding: const EdgeInsets.symmetric(horizontal:20,
      vertical: 15),
  elevation: 10,
  duration: const Duration(seconds: 10),
);