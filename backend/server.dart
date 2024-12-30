// import 'package:socket_io/socket_io.dart';
//
// void main() {
//   // Initialize the Socket.IO server
//   var io = Server();
//   var tasks = <Map<String, dynamic>>[];  // In-memory task storage
//
//   io.on('connection', (client) {
//     print('User connected: ${client.id}');
//
//     // Send existing tasks to the connected client
//     client.emit('load_tasks', tasks);
//
//     // Listen for 'add_task' and broadcast to all clients
//     client.on('add_task', (data) {
//       tasks.add(data);
//       io.emit('new_task', data);  // Broadcast the new task to all clients
//       print('New Task Added: $data');
//     });
//
//     // Listen for task updates
//     client.on('update_task', (updatedTask) {
//       int index = tasks.indexWhere((t) => t['id'] == updatedTask['id']);
//       if (index != -1) {
//         tasks[index] = updatedTask;
//         io.emit('update_task', updatedTask);  // Broadcast updated task
//         print('Task Updated: $updatedTask');
//       }
//     });
//
//     // Listen for task deletion
//     client.on('delete_task', (taskToDelete) {
//       tasks.removeWhere((task) => task['id'] == taskToDelete['id']);
//       io.emit('delete_task', taskToDelete);  // Broadcast deleted task
//       print('Task Deleted: $taskToDelete');
//     });
//
//     // Handle disconnection
//     client.on('disconnect', (_) {
//       print('User disconnected: ${client.id}');
//     });
//   });
//
//   // Start listening on port 3000
//   io.listen(3000);
//   print('Socket.IO server running on port 3000...');
// }
import 'package:socket_io/socket_io.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  var io = Server();
  var tasks = <Map<String, dynamic>>[];

  // Load tasks from file if exists
  void _loadTasksFromFile() {
    final file = File('tasks.json');
    if (file.existsSync()) {
      tasks = List<Map<String, dynamic>>.from(jsonDecode(file.readAsStringSync()));
    }
  }

  // Save tasks to file
  void _saveTasksToFile() {
    final file = File('tasks.json');
    file.writeAsStringSync(jsonEncode(tasks));
  }

  // Broadcast task count to all clients
  void _broadcastTaskCount() {
    io.emit('task_count', {'count': tasks.length});
  }

  io.on('connection', (client) {
    print('User connected: ${client.id}');

    // Send existing tasks to the new client
    client.emit('load_tasks', tasks);

    // Add Task
    client.on('add_task', (data) {
      try {
        tasks.add(data);
        io.emit('new_task', data);
        _saveTasksToFile();
        _broadcastTaskCount();
        print('New Task Added: $data');
      } catch (e) {
        print('Error adding task: $e');
        client.emit('error', 'Failed to add task');
      }
    });

    // Update Task
    client.on('update_task', (updatedTask) {
      try {
        int index = tasks.indexWhere((t) => t['id'] == updatedTask['id']);
        if (index != -1) {
          tasks[index] = updatedTask;
          io.emit('update_task', updatedTask);
          _saveTasksToFile();
          print('Task Updated: $updatedTask');
        } else {
          client.emit('error', 'Task not found');
        }
      } catch (e) {
        print('Error updating task: $e');
        client.emit('error', 'Failed to update task');
      }
    });

    // Delete Task
    client.on('delete_task', (taskToDelete) {
      try {
        int initialLength = tasks.length;
        tasks.removeWhere((task) => task['id'] == taskToDelete['id']);
        bool removed = tasks.length < initialLength;

        if (removed) {
          io.emit('delete_task', taskToDelete);
          _saveTasksToFile();
          _broadcastTaskCount();
          print('Task Deleted: $taskToDelete');
        } else {
          client.emit('error', 'Task not found');
        }
      } catch (e) {
        print('Error deleting task: $e');
        client.emit('error', 'Failed to delete task');
      }
    });


    // Broadcast user connection/disconnection
    io.emit('user_connected', {'id': client.id, 'message': 'User connected'});
    client.on('disconnect', (_) {
      io.emit('user_disconnected', {'id': client.id, 'message': 'User disconnected'});
      print('User disconnected: ${client.id}');
    });
  });

  _loadTasksFromFile();
  io.listen(3000);
  print('Socket.IO server running on port 3000...');
}

