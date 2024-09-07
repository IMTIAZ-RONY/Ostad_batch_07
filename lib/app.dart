
import 'package:flutter/material.dart';
import 'package:ostad_batch_07/shopping_cart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder:(BuildContext context,Widget?child)=>
       MaterialApp(
        debugShowCheckedModeBanner: false,
        home:ShoppingCart() ,
        theme:ThemeData(
          brightness:Brightness.light ,
          colorScheme:ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
        ) ,
      ),
    );
  }
}
