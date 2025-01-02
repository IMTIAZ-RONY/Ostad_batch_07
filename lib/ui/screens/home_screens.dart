
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ostad_batch_07/ui/screens/task_details_screen.dart';
// import '../../bussiness_logic/controllers/task_controllers.dart';
// import 'add_task_screen.dart';
//  // Import Task Detail Screen
//
// class HomeScreen extends StatelessWidget {
//   final TaskController controller = Get.put(TaskController());
//
//   HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Task Manager')),
//       body: Obx(() => ListView.builder(
//         itemCount: controller.tasks.length,
//         itemBuilder: (context, index) {
//           final task = controller.tasks[index];
//           return ListTile(
//             title: Text(task.title),
//             subtitle: Text(task.subtitle),
//             trailing: Icon(
//               task.isCompleted ? Icons.check_circle : Icons.circle,
//               color: task.isCompleted ? Colors.green : Colors.grey,
//             ),
//             onTap: () {
//               // Navigate to TaskDetailScreen and pass the task
//               Get.to(() => TaskDetailScreen(task: task));
//             },
//           );
//         },
//       )),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Get.to(() => AddTaskScreen());
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
/// 2nd
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_batch_07/ui/screens/task_details_screen.dart';
import '../../business_logic/controllers/task_controllers.dart';
import 'add_task_screen.dart';  // Import Add Task Screen

class HomeScreen extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Getx')),
      body: Obx(() => ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];

          // 🗂️ ListTile for Each Task
          return Card(
            color:Colors.greenAccent,
            elevation:5 ,
             child: ListTile(
              title: Text(task.title),
              subtitle: Text(task.subtitle),
              trailing: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
              onTap: () {
                // Navigate to Task Detail Screen when tapped
                Get.to(() => TaskDetailScreen(task: task));
              },
            ),
          );
        },
      )),

      // ➕ Floating Action Button to Add New Task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddTaskScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

