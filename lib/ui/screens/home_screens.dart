import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../business_logic/controllers/counter_controller.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
CounterController counterController=CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: const Center(
          child: Text ("Advanced Get-X",style:TextStyle(fontSize:26 ) ,)) ,) ,
      body: Center(
        child:GetBuilder<CounterController>(
          init:counterController ,
            builder:(plus){
              return Text(
                "Taka:${plus.count}",style:const TextStyle(fontSize:30 ,color:Colors.greenAccent ,) ,
              ) ;
            } ),

        ),

      floatingActionButton: Stack(
           children: [
             Positioned(
               bottom:80 ,
                 right:16 ,
                 child:FloatingActionButton(
               heroTag:'Increment ',
                 onPressed: counterController.increment,
               child:const Icon(Icons.add) ,
             )),
             Positioned(
               bottom: 16,
               right: 16,
                 child: FloatingActionButton(
                  heroTag:"Decrement" ,
                  onPressed:counterController.decre,
                   child:const Icon(Icons.remove) ,)),

               ],

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