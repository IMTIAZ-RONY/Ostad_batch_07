import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/counter_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
RxInt _count=0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Center(
          child: Text ("Advanced Get-X",style:TextStyle(fontSize:26 ) ,)) ,) ,
      body: Center(
        child:Obx((){
          return Text(
            "Taka:$_count" ,
          ) ;
        }),

        ),
      floatingActionButton: FloatingActionButton(

        onPressed:(){
          _count++;
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