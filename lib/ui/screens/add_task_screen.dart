
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../bussiness_logic/controllers/task_controllers.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController collaboratorController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedFilePath = '';
  List<String> collaborators = [];

  // 📅 Date Picker
  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ⏰ Time Picker
  Future<void> _selectDueTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // 📄 File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  // 📷 Image Picker (Gallery or Camera)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedFilePath = image.path;
      });
    }
  }

  // ➕ Add Collaborators
  void _addCollaborator() {
    if (collaboratorController.text.isNotEmpty) {
      setState(() {
        collaborators.add(collaboratorController.text);
        collaboratorController.clear();
      });
    }
  }

  // ❌ Remove Collaborator
  void _removeCollaborator(String name) {
    setState(() {
      collaborators.remove(name);
    });
  }

  // ✅ Save Task
  void _saveTask() {
    if (titleController.text.isEmpty ||
        projectController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    controller.addTask(
      title: titleController.text,
      subtitle: subtitleController.text,
      description: descriptionController.text,
      projectName: projectController.text,
      dueDate: selectedDate,
      filePath: selectedFilePath,
      collaborators: collaborators,
    );
    Get.back();
  }

  // 📥 Show Attachment Dialog (for Document, Image, Camera)
  Future<void> _showAttachmentDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Attach Document'),
              onTap: () async {
                await _pickFile();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                await _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title *'),
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(labelText: 'Task Subtitle'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
            ),
            TextField(
              controller: projectController,
              decoration: const InputDecoration(labelText: 'Project Name *'),
            ),
            const SizedBox(height: 16),

            // 📅 Due Date
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDueDate(context),
            ),

            // ⏰ Due Time
            ListTile(
              title: const Text('Due Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectDueTime(context),
            ),

            // 📂 Attachment Section
            const SizedBox(height: 16),
            const Text('Attachment'),
            ListTile(
              title: Text(selectedFilePath.isEmpty ? 'No file selected' : selectedFilePath),
              trailing: const Icon(Icons.attach_file),
              onTap: _showAttachmentDialog,
            ),
            const SizedBox(height: 16),

            // 👥 Collaborators
            TextField(
              controller: collaboratorController,
              decoration: const InputDecoration(labelText: 'Add Collaborator'),
              onSubmitted: (_) => _addCollaborator(),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: collaborators.map((name) {
                return Chip(
                  label: Text(name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeCollaborator(name),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../bussiness_logic/controllers/task_controllers.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController collaboratorController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedFilePath = '';
  List<String> collaborators = [];

  // 📅 Date Picker
  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ⏰ Time Picker
  Future<void> _selectDueTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // 📄 File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    } else {
      Get.snackbar('Error', 'No file selected');
    }
  }

  // 📷 Image Picker (Gallery or Camera)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

    if (image != null && image.path != null) {
      setState(() {
        selectedFilePath = image.path;
      });
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }

  // ➕ Add Collaborators
  void _addCollaborator() {
    if (collaboratorController.text.isNotEmpty) {
      setState(() {
        collaborators.add(collaboratorController.text);
        collaboratorController.clear();
      });
    }
  }

  // ❌ Remove Collaborator
  void _removeCollaborator(String name) {
    setState(() {
      collaborators.remove(name);
    });
  }

  // ✅ Save Task
  void _saveTask() {
    if (titleController.text.isEmpty ||
        projectController.text.isEmpty ||
        descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    controller.addTask(
      title: titleController.text,
      subtitle: subtitleController.text,
      description: descriptionController.text,
      projectName: projectController.text,
      dueDate: selectedDate,
      filePath: selectedFilePath,
      collaborators: collaborators,
    );
    Get.back();
  }

  // 📥 Show Attachment Dialog
  Future<void> _showAttachmentDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Attach Document'),
              onTap: () async {
                await _pickFile();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                await _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title *'),
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(labelText: 'Task Subtitle'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description *'),
              maxLines: 3,
            ),
            TextField(
              controller: projectController,
              decoration: const InputDecoration(labelText: 'Project Name *'),
            ),
            const SizedBox(height: 16),

            // 📅 Due Date
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDueDate(context),
            ),

            // ⏰ Due Time
            ListTile(
              title: const Text('Due Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectDueTime(context),
            ),

            // 📂 Attachment Section
            const SizedBox(height: 16),
            const Text('Attachment'),
            ListTile(
              title: selectedFilePath.isEmpty
                  ? const Text('No file selected')
                  : selectedFilePath.endsWith('.jpg') ||
                  selectedFilePath.endsWith('.png')
                  ? Image.file(
                File(selectedFilePath),
                width: 100,
                height: 100,
              )
                  : Text(selectedFilePath),
              trailing: const Icon(Icons.attach_file),
              onTap: _showAttachmentDialog,
            ),
            const SizedBox(height: 16),

            // 👥 Collaborators
            TextField(
              controller: collaboratorController,
              decoration: const InputDecoration(labelText: 'Add Collaborator'),
              onSubmitted: (_) => _addCollaborator(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: collaborators.map((name) {
                return Chip(
                  label: Text(name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeCollaborator(name),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}

