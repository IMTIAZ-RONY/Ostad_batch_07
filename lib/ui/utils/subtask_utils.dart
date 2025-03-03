import 'package:flutter/material.dart';


bool shouldShowAddSubtask(List<TextEditingController> controllers) {
  return controllers.isEmpty || controllers.every((controller) => controller.text.isEmpty);
}