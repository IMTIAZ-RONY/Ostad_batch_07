import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
CounterController counterController= CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder(
          init:counterController ,
            builder:(_){
              return   Text(
                "Taka:$counterController.counter",
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              );
            } )
        ),
      floatingActionButton: FloatingActionButton(

        onPressed:counterController.increment ,
        child: const Icon(Icons.add),
      ),
      );



  }

}
class CounterController extends GetxController{
  int _counter = 0;
  get counter=>_counter;
  void increment(){
    _counter++;
    update();
  }

}