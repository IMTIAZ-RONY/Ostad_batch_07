
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ostad_batch_07/screens/product_list_screen.dart';
class CrudApp extends StatelessWidget {
  const CrudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
     designSize: const Size(375, 812),
     minTextAdapt: true,
      builder:(BuildContext context,Widget?child)=>
       MaterialApp(
        debugShowCheckedModeBanner: false,
        home:const ProductListScreen() ,
        theme:ThemeData(
          brightness:Brightness.light ,
          colorScheme:ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
          useMaterial3: true,
        ) ,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import 'package:ostad_batch_07/screens/product_list_screen.dart';
//
// class CRUDApp extends StatelessWidget {
//   const CRUDApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//           appBarTheme: const AppBarTheme(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white
//           ),
//           inputDecorationTheme: const InputDecorationTheme(
//             border: OutlineInputBorder(),
//             enabledBorder: OutlineInputBorder(),
//             focusedBorder: OutlineInputBorder(),
//             errorBorder: OutlineInputBorder(),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.amber,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//                 textStyle: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 )
//             ),
//           )
//       ),
//       home: const ProductListScreen(),
//     );
//   }
// }
