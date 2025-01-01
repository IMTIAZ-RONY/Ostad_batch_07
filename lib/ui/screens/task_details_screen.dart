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

/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

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
}*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/models/task_model.dart';
import '../../business_logic/controllers/task_controllers.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskController controller = Get.find();

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController descriptionController;
  late TextEditingController projectController;

  bool isEditing = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    subtitleController = TextEditingController(text: widget.task.subtitle);
    descriptionController = TextEditingController(text: widget.task.description);
    projectController = TextEditingController(text: widget.task.projectName);
    selectedDate = widget.task.dueDate;
  }

  // 📅 Date Picker
  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ✅ Save Task Changes
  void _saveTaskChanges() {
    if (titleController.text.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty');
      return;
    }

    setState(() {
      widget.task.title = titleController.text;
      widget.task.subtitle = subtitleController.text;
      widget.task.description = descriptionController.text;
      widget.task.projectName = projectController.text;
      widget.task.dueDate = selectedDate ?? widget.task.dueDate;
      isEditing = false;
    });

    // Update task in controller
    controller.updateTask(widget.task);
    Get.snackbar('Task Updated', 'Your task has been updated successfully.');
  }

  @override
  Widget build(BuildContext context) {
    bool isImage = widget.task.filePath.endsWith('.jpg') ||
        widget.task.filePath.endsWith('.png') ||
        widget.task.filePath.endsWith('.jpeg');

    return Scaffold(
      appBar: AppBar(
        title: isEditing ? const Text('Edit Task') : const Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                _saveTaskChanges();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEditableTile('Title', titleController),
            _buildEditableTile('Subtitle', subtitleController),
            _buildEditableTile('Description', descriptionController, maxLines: 3),
            _buildEditableTile('Project', projectController),

            const SizedBox(height: 20),

            // 📅 Due Date Section
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(
                selectedDate != null
                    ? "${DateFormat.yMMMd().format(selectedDate!)}"
                    : 'No date selected',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: isEditing ? () => _selectDueDate(context) : null,
            ),

            const SizedBox(height: 20),

            // 🗂️ Attachment Section (Dynamic Image or File Preview)
            ListTile(
              title: const Text('Attachment'),
              subtitle: widget.task.filePath.isNotEmpty
                  ? isImage
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Image.file(
                  File(widget.task.filePath),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
                  : Text(widget.task.filePath)
                  : const Text('No attachment'),
              leading: const Icon(Icons.attach_file),
              onTap: () {
                if (widget.task.filePath.isNotEmpty) {
                  Get.snackbar('Attachment', 'Opening file...');
                  // Implement logic to open the file here
                }
              },
            ),

            const SizedBox(height: 20),

            // 👥 Collaborators Section
            if (widget.task.collaborators.isNotEmpty)
              ListTile(
                title: const Text('Collaborators'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.task.collaborators
                      .map((collaborator) => Text('- $collaborator'))
                      .toList(),
                ),
              ),

            const SizedBox(height: 20),

            // ✅ Mark as Completed Checkbox
            CheckboxListTile(
              value: widget.task.isCompleted,
              onChanged: (value) {
                setState(() {
                  widget.task.isCompleted = value ?? false;
                });
                controller.updateTask(widget.task);
                Get.back();
                Get.snackbar('Task Updated', 'Task marked as completed!');
              },
              title: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper for Editable List Tiles
  Widget _buildEditableTile(String title, TextEditingController controller,
      {int maxLines = 1}) {
    return ListTile(
      title: Text(title),
      subtitle: isEditing
          ? TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Edit $title',
        ),
      )
          : Text(controller.text),
    );
  }
}



