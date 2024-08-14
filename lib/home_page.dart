import 'package:flutter/material.dart';
import 'const.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Greeting App",
          style: normalFont,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.h,
              ),
              Center(
                child: Text(
                  "Hello,World!",
                  style: largeFont,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Text(
                  "Welcome to Flutter!",
                  style: normalFont,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Image.network(
                  "https://iconape.com/wp-content/png_logo_vector/flutter-logo.png",
                  height: 100.h,
                  width: 100.h,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(customSnackBar(context));
                    },
                    child: Text(
                      "Press me",
                      style: normalFont.copyWith(
                        fontSize: 14.sp,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
