// lib/utils/task_functions.dart
import 'package:file_picker/file_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../screens/home_screens.dart';

void saveProject(String projectName, List<String> savedProjects, GetStorage storage) {
  if (projectName.isEmpty || savedProjects.contains(projectName)) return;
  savedProjects.add(projectName);
  storage.write('projects', savedProjects);
}

void onProjectChanged(
    String input,
    List<String> savedProjects,
    Function(List<String>) setFilteredProjects,
    Function(bool) setShowNoProjectMessage,
    Function(bool) setShowProjectSuggestions,
    ) {
  if (input.isEmpty) {
    if (savedProjects.isEmpty) {
      setShowNoProjectMessage(true);
      setFilteredProjects([]);
    } else {
      setShowNoProjectMessage(false);
      setFilteredProjects(savedProjects);
    }
  } else {
    setShowNoProjectMessage(false);
    setFilteredProjects(
      savedProjects.where((project) => project.toLowerCase().contains(input.toLowerCase())).toList(),
    );
    setShowProjectSuggestions(true);
  }
}

void createTask({
  required BuildContext context,
  required TextEditingController taskNameController,
  required TextEditingController projectController,
  required FleatherController? fleatherController,
  required List<String> savedProjects,
  required GetStorage storage,
}) {
  String taskName = taskNameController.text.trim();
  String projectName = projectController.text.trim();

  if (projectName.isNotEmpty && !savedProjects.contains(projectName)) {
    saveProject(projectName, savedProjects, storage);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: const SnackBar(content: Text("Preoject added successfully!"),
      backgroundColor:Colors.green,
      duration: Duration(seconds: 2),)));
  } else if(projectName.isNotEmpty){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Project already exists"),
        backgroundColor:Colors.orange ,
    duration: Duration(seconds: 2),));
  }

  List<dynamic> tasks = storage.read<List>('tasks') ?? [];
  tasks.add({
    'taskName': taskName.isEmpty ? 'Untitled Task' : taskName,
    'projectName': projectName.isEmpty ? 'No Project' : projectName,
    'description': fleatherController?.document.toPlainText().trim() ?? 'No Description',
    'createdAt': DateTime.now().toString(),
  });
  storage.write('tasks', tasks);

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
  );
}

Future<void> pickImageFromCamera({
  required ImagePicker picker,
  required Function(String) attachFile,
  required Function(bool) setLoading,
}) async {
  setLoading(true);
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    await attachFile(image.path);
  }
  setLoading(false);
}

Future<void> pickImageFromGallery({
  required ImagePicker picker,
  required Function(String) attachFile,
  required Function(bool) setLoading,
}) async {
  setLoading(true);
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    await attachFile(image.path);
  }
  setLoading(false);
}

Future<void> attachDocument({
  required Function(String) attachFile,
}) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      String filePath = result.files.single.path!;
      attachFile(filePath);
    }
  } catch (e) {
    print('Error picking file: $e');
  }
}
