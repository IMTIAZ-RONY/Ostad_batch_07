import 'package:get/get.dart';
import 'package:ostad_batch_07/bussiness_logic/controllers/sign_in_controller.dart';

import '../controllers/new_task_list_controller.dart';

class ControllerBinder with Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(NewTaskListController());
  }
}