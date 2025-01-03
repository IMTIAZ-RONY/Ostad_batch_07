import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/counter_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//CounterController counterController=CounterController() ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Center(
          child: Text ("Advanced Get-X",style:TextStyle(fontSize:26 ) ,)) ,) ,
      body: Center(
        child: GetBuilder<CounterController>(
          //init:counterController ,
            builder:(counterController){
              return   Text(
                "Taka:${counterController.counter}",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              );
            } )
        ),
      floatingActionButton: FloatingActionButton(

        onPressed:(){
          Get.find<CounterController>().increment();
          },
        child: const Icon(Icons.add),
      ),
      );



  }

}
/*class CounterController extends GetxController{
  int _counter = 0;
  get counter=>_counter;
  void increment(){
    _counter++;
    update();
  }

}*/