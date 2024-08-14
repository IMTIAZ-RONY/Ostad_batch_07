import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final TextStyle largeFont =
TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold, color: Colors.red);
final TextStyle normalFont =
TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600, color: Colors.black);

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
