import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxInt _counter=0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:const Text("Counter App ") ,) ,
      body:Center(
        child:Obx((){
          return
          Text(
            "Sum: $_counter",style:const TextStyle(color:Colors.pink,fontSize:30 ,fontWeight:FontWeight.bold ,) ,
          );}

        ) ,
      ) ,
      floatingActionButton:FloatingActionButton(
          onPressed: (){
        setState(() {
          _counter++;
        });
      },
      child:const Icon(Icons.add) ,) ,
    );
  }
}
