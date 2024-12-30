import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/task_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class TaskController extends GetxController {
  final tasks = <Task>[].obs;
  final box = GetStorage();
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://localhost:3000', IO.OptionBuilder()
        .setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('Connected to server');
    });

    socket.on('new_task', (data) {
      Task newTask = Task.fromJson(data);
      tasks.add(newTask);
      saveTasks();
    });
  }

  void addTask({
    required String title,
    required String subtitle,
    required String description,
    required String projectName,
    required DateTime dueDate,
    String filePath = '',
    List<String> collaborators = const [],
  }) {
    final newTask = Task.create(
      title: title,
      subtitle: subtitle,
      description: description,
      projectName: projectName,
      dueDate: dueDate,
      filePath: filePath,
      collaborators: collaborators,
    );
    tasks.add(newTask);
    saveTasks();
    socket.emit('add_task', newTask.toJson());
  }

  void saveTasks() {
    final taskList = tasks.map((task) => task.toJson()).toList();
    box.write('tasks', taskList);
  }

  void loadTasks() {
    final storedTasks = box.read<List>('tasks') ?? [];
    tasks.assignAll(storedTasks.map((e) => Task.fromJson(e)).toList());
  }
}
