import 'package:flutter/material.dart';
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

class CancelledTaskScreen extends StatefulWidget {
  static const String name="/CancelledTaskScreen";
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress = false;
  bool _getTaskStatusCountListInProgress = false;
  List<TaskModel> _cancelledTaskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: ()async{
        _getCancelledTaskList();
        _getCancelledTaskList();
      },
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
           BuildSummarySection(),
              Expanded(
                child: Visibility(
                  visible: !_getCancelledTaskListInProgress,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ListView.separated(
                    itemCount: _cancelledTaskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(taskModel: _cancelledTaskList[index], onRefreshList: _getCancelledTaskList,);
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
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddNewTaskScreen()),
    );
    if (shouldRefresh == true) {
      _getCancelledTaskList();
    }
  }

  Future<void> _getCancelledTaskList() async {
    _cancelledTaskList.clear();
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.cancelledTaskList);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
      TaskListModel.fromJson(response.responseData);
      _cancelledTaskList = taskListModel.taskList ?? [];
    } else {
      if (!mounted) return;
      ShowSnackBarMessage(context, response.errorMessage, true);
    }
    _getCancelledTaskListInProgress = false;
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
    setState(() {});
  }
  Widget BuildSummarySection() {
    return Padding(
      padding: EdgeInsets.all(8.0),
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


