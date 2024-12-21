class Urls{
  static const String _baseUrl = 'http://35.73.30.144:2005/api/v1';
  static const String registration = '$_baseUrl/registration';
  static const String login = '$_baseUrl/login';
  static const String createTask = '$_baseUrl/createTask';
  static const String getNewTaskList = '$_baseUrl/listTaskByStatus/New';
  static const String completedTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static const String cancelledTaskList = '$_baseUrl/listTaskByStatus/Cancel';
  static const String inProgressTaskList = '$_baseUrl/listTaskByStatus/InProgress';
  static  String changeStatus(String taskId,String status) => '$_baseUrl/updateTaskStatus/$taskId/$status';
  static const String getTaskCountList = '$_baseUrl/taskStatusCount';
  static const String userProfileUpdate = '$_baseUrl/ProfileUpdate';
}