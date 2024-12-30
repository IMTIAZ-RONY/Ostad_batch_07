// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../data/models/task_model.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final Task task;
//
//   const TaskDetailScreen({Key? key, required this.task}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(task.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ListTile(
//               title: const Text('Title'),
//               subtitle: Text(task.title),
//             ),
//             ListTile(
//               title: const Text('Subtitle'),
//               subtitle: Text(task.subtitle),
//             ),
//             ListTile(
//               title: const Text('Description'),
//               subtitle: Text(task.description),
//             ),
//             ListTile(
//               title: const Text('Project'),
//               subtitle: Text(task.projectName),
//             ),
//             ListTile(
//               title: const Text('Due Date'),
//               subtitle: Text(task.dueDate.toString()),
//             ),
//             if (task.filePath.isNotEmpty)
//               ListTile(
//                 title: const Text('Attached File'),
//                 subtitle: Text(task.filePath),
//                 leading: const Icon(Icons.file_present),
//               ),
//             if (task.collaborators.isNotEmpty)
//               ListTile(
//                 title: const Text('Collaborators'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: task.collaborators
//                       .map((collaborator) => Text(collaborator))
//                       .toList(),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             CheckboxListTile(
//               value: task.isCompleted,
//               onChanged: (value) {
//                 // Mark as completed and return to home screen
//                 task.isCompleted = value ?? false;
//                 Get.back();
//                 Get.snackbar('Task Updated', 'Task marked as completed!');
//               },
//               title: const Text('Mark as Completed'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
///2nd
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Title'),
              subtitle: Text(task.title),
            ),
            ListTile(
              title: const Text('Subtitle'),
              subtitle: Text(task.subtitle),
            ),
            ListTile(
              title: const Text('Description'),
              subtitle: Text(task.description),
            ),
            ListTile(
              title: const Text('Project'),
              subtitle: Text(task.projectName),
            ),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(task.dueDate.toString()),
            ),

            // 🗂️ Attachment Section
            ListTile(
              title: const Text('Attachment'),
              subtitle: task.filePath.isNotEmpty
                  ? Text(task.filePath)
                  : const Text('No attachment'),
              leading: const Icon(Icons.attach_file),
              onTap: () {
                if (task.filePath.isNotEmpty) {
                  Get.snackbar('Attachment', 'Opening file...');
                  // Handle file opening logic here (optional)
                }
              },
            ),

            // 📁 File Section (Optional Detailed Display)
            if (task.filePath.isNotEmpty)
              ListTile(
                title: const Text('Attached File'),
                subtitle: Text(task.filePath),
                leading: const Icon(Icons.file_present),
              ),

            // 👥 Collaborators Section
            if (task.collaborators.isNotEmpty)
              ListTile(
                title: const Text('Collaborators'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: task.collaborators
                      .map((collaborator) => Text(collaborator))
                      .toList(),
                ),
              ),

            const SizedBox(height: 20),

            // ✅ Mark as Completed Checkbox
            CheckboxListTile(
              value: task.isCompleted,
              onChanged: (value) {
                task.isCompleted = value ?? false;
                Get.back();  // Return to previous screen
                Get.snackbar('Task Updated', 'Task marked as completed!');
              },
              title: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isImage = task.filePath.endsWith('.jpg') || task.filePath.endsWith('.png') || task.filePath.endsWith('.jpeg');

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Title'),
              subtitle: Text(task.title),
            ),
            ListTile(
              title: const Text('Subtitle'),
              subtitle: Text(task.subtitle),
            ),
            ListTile(
              title: const Text('Description'),
              subtitle: Text(task.description),
            ),
            ListTile(
              title: const Text('Project'),
              subtitle: Text(task.projectName),
            ),
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(
                "${DateFormat.yMMMd().format(task.dueDate)} at ${task.dueDate.hour}:${task.dueDate.minute}",
              ),
            ),

            const SizedBox(height: 20),

            // 🗂️ Attachment Section (Dynamic Image or File Preview)
            ListTile(
              title: const Text('Attachment'),
              subtitle: task.filePath.isNotEmpty
                  ? isImage
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.file(
                  File(task.filePath),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
                  : Text(task.filePath)
                  : const Text('No attachment'),
              leading: const Icon(Icons.attach_file),
              onTap: () {
                if (task.filePath.isNotEmpty) {
                  Get.snackbar('Attachment', 'Opening file...');
                  // Implement logic to open the file here
                }
              },
            ),

            // 👥 Collaborators Section
            if (task.collaborators.isNotEmpty)
              ListTile(
                title: const Text('Collaborators'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: task.collaborators
                      .map((collaborator) => Text('- $collaborator'))
                      .toList(),
                ),
              ),

            const SizedBox(height: 20),

            // ✅ Mark as Completed Checkbox
            CheckboxListTile(
              value: task.isCompleted,
              onChanged: (value) {
                task.isCompleted = value ?? false;
                Get.back();  // Return to previous screen
                Get.snackbar('Task Updated', 'Task marked as completed!');
              },
              title: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }
}


