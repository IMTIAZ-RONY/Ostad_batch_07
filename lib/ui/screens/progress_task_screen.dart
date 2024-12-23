import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ostad_batch_07/data/models/network_response.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/data/utils/urls.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_status_count_model.dart';
import '../../data/models/task_status_model.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class ProgressTaskScreen extends StatefulWidget {
  static const String name="/ProgressTaskScreen";
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskListInProgress = false;
  bool _getTaskStatusCountListInProgress = false;
  List<TaskModel> _progressTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getInProgressTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh:()async{
        _getInProgressTaskList();
        _getTaskStatusCount();
      } ,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _onTapAddFAB,
          child: const Icon(
            Icons.add,
            size: 20,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            buildSummarySection(),
              Expanded(
                child: Visibility(
                  visible: !_getProgressTaskListInProgress,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ListView.separated(
                    itemCount: _progressTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(taskModel: _progressTaskList[index], onRefreshList: _getInProgressTaskList,);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 8,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapAddFAB() async {
    final bool? shouldRefresh = await /* Navigator.push(context, MaterialPageRoute(builder: (_) => const AddNewTaskScreen()),);*/
    Get.to(AddNewTaskScreen.name);
    if (shouldRefresh == true) {
      _getInProgressTaskList();
    }
  }

  Future<void> _getInProgressTaskList() async {
    _progressTaskList.clear();
    _getProgressTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.inProgressTaskList);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _progressTaskList = taskListModel.taskList ?? [];
    } else {
      if (!mounted) return;
      ShowSnackBarMessage(context, response.errorMessage, true);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }
  Future<void> _getTaskStatusCount() async {
    _taskStatusCountList.clear();
    _getTaskStatusCountListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.getTaskCountList);

    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel =
      TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
    } else {
      if (!mounted) return;
      ShowSnackBarMessage(context, response.errorMessage, true);
    }
    _getTaskStatusCountListInProgress = false;

  }
  Widget buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible:!_getTaskStatusCountListInProgress   ,
        replacement: const CenteredCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _getTaskSummaryCardList(),
          ),
        ),
      ),
    );
  }
  List<TaskSummaryCard>_getTaskSummaryCardList(){
    List<TaskSummaryCard>taskSummaryCardList=[];
    for(TaskStatusModel t in _taskStatusCountList){
      taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum??0));
    }
    return taskSummaryCardList;

  }
}


