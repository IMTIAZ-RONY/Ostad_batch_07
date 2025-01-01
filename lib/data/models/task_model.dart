/*import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String subtitle;
  String description;
  String projectName;
  DateTime dueDate;
  String filePath;
  List<String> collaborators;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.projectName,
    required this.dueDate,
    required this.filePath,
    required this.collaborators,
    this.isCompleted = false,
  });

  // 🔹 Factory method to create a new task with a unique ID
  factory Task.create({
    required String title,
    required String subtitle,
    required String description,
    required String projectName,
    required DateTime dueDate,
    String filePath = '',
    List<String> collaborators = const [],
  }) {
    return Task(
      id: const Uuid().v4(),
      title: title,
      subtitle: subtitle,
      description: description,
      projectName: projectName,
      dueDate: dueDate,
      filePath: filePath,
      collaborators: collaborators,
    );
  }

  // 🔹 Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'projectName': projectName,
      'dueDate': dueDate.toIso8601String(),
      'filePath': filePath,
      'collaborators': collaborators,
      'isCompleted': isCompleted,
    };
  }

  // 🔹 Convert JSON to Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      projectName: json['projectName'],
      dueDate: DateTime.parse(json['dueDate']),
      filePath: json['filePath'] ?? '',
      collaborators: List<String>.from(json['collaborators']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}*/
import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String subtitle;
  String description;
  String projectName;
  DateTime? dueDate;
  String filePath;
  List<String> collaborators;
  bool isCompleted;

  Task({
    required this.id,
    this.title = '',                   // Optional - Default to empty
    this.subtitle = '',
    this.description = '',
    this.projectName = '',
    this.dueDate,                      // Optional - Nullable
    this.filePath = '',
    this.collaborators = const [],
    this.isCompleted = false,
  });

  // 🔹 Factory to Create Task with Default Values
  factory Task.create({
    String title = '',
    String subtitle = '',
    String description = '',
    String projectName = '',
    DateTime? dueDate,
    String filePath = '',
    List<String> collaborators = const [],
  }) {
    return Task(
      id: const Uuid().v4(),
      title: title,
      subtitle: subtitle,
      description: description,
      projectName: projectName,
      dueDate: dueDate,
      filePath: filePath,
      collaborators: collaborators,
    );
  }

  // 🔹 Convert Task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'projectName': projectName,
      'dueDate': dueDate?.toIso8601String(),  // Use nullable conversion
      'filePath': filePath,
      'collaborators': collaborators,
      'isCompleted': isCompleted,
    };
  }

  // 🔹 Convert JSON to Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      projectName: json['projectName'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      filePath: json['filePath'] ?? '',
      collaborators: List<String>.from(json['collaborators'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
