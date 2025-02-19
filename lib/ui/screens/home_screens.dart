
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
/*import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Task Manager')),
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
}*/

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ostad_batch_07/ui/screens/add_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetStorage _storage = GetStorage();
  List<dynamic> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    tasks = _storage.read<List<dynamic>>('tasks') ?? [];
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      _storage.write('tasks', tasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
          _loadTasks(); // Refresh after returning from AddTaskScreen
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadTasks();
          setState(() {});
        },
        child: tasks.isEmpty
            ? const Center(child: Text('No tasks available.'))
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(tasks[index]['taskName']),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) => _deleteTask(index),
              child: ListTile(
                title: Text(tasks[index]['taskName']),
                subtitle: Text('Project: ${tasks[index]['projectName']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TaskDetailsScreen(task: tasks[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
