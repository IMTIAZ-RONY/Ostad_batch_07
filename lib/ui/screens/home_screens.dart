import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RxInt _counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx((){
          return   Text(
        "Taka:$_counter",
        style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent,
        ),
        );}

        ),
      ),
      floatingActionButton: FloatingActionButton(
      /*  onPressed: () {
            _counter.value++;
        },*/
        onPressed:uiUpdate ,
        child: const Icon(Icons.add),
      ),
    );

  }
  void uiUpdate(){
    _counter++; ///l
  }
}
