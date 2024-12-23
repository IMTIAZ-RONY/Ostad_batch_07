import 'package:get/get_state_manager/get_state_manager.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/models/task_status_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

/*class NewTaskListController extends GetxController{
  bool _inProgress=false;
  bool get inProgress=>_inProgress;
  String? _errorMessage;
  String? get errorMessage=>_errorMessage;
  List<TaskModel> _taskList=[];
  List<TaskModel>get taskList=> _taskList;
  List<TaskStatusModel> _taskStatusCountList = [];
  List<TaskStatusModel> get taskStatusCountList =>_taskStatusCountList;


  Future<bool>getNewTaskList() async{
    _taskList.clear();
    bool isSuccess= false;
    _inProgress = false;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getNewTaskList);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      isSuccess=true;
    } else {
      _errorMessage=response.errorMessage;
      //ShowSnackBarMessage(context, response.errorMessage, true);
    }
    _inProgress = false;
    update();
    return isSuccess ;
  }
  Future<bool> getTaskStatusCount() async {
    bool isSuccess=false;
    _taskStatusCountList.clear();
    _inProgress = true;
    update();
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getTaskCountList);

    if (response.isSuccess) {
      _errorMessage = null;
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      isSuccess=true;
    } else {
      _errorMessage=response.errorMessage;
     // ShowSnackBarMessage(context, response.errorMessage, true);
    }
    _inProgress = false;
    update();
    return isSuccess;
  }



}*/
class NewTaskListController extends GetxController {
  bool _newTaskListInProgress = false;
  bool _taskStatusCountInProgress = false;
  String? _errorMessage;
  List<TaskModel> _taskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  bool get newTaskListInProgress => _newTaskListInProgress;
  bool get taskStatusCountInProgress => _taskStatusCountInProgress;
  String? get errorMessage => _errorMessage;
  List<TaskModel> get taskList => _taskList;
  List<TaskStatusModel> get taskStatusCountList => _taskStatusCountList;

  Future<bool> getNewTaskList() async {
    _taskList.clear();
    _newTaskListInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getNewTaskList);
    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      _errorMessage = null;
      _newTaskListInProgress = false;
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      _newTaskListInProgress = false;
      update();
      return false;
    }
  }

  Future<bool> getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _taskStatusCountInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getTaskCountList);
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      _errorMessage = null;
      _taskStatusCountInProgress = false;
      update();
      return true;
    } else {
      _errorMessage = response.errorMessage;
      _taskStatusCountInProgress = false;
      update();
      return false;
    }
  }
}
