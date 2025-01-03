
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CounterController extends GetxController{
int _count=0;
get count=>_count;
void increment(){
  _count++;
  update();
}
void decrement(){
  _count--;
  update();
}
///do not go under 0
void decre(){
  if(_count>0){
    _count--;
    update();
  }
}


}