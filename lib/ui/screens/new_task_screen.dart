import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ostad_batch_07/data/models/task_status_model.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';
import '../../bussiness_logic/controllers/new_task_list_controller.dart';
import '../widgets/task_card.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  static const String name='/NewTaskScreen';
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final NewTaskListController _newTaskListController=Get.find<NewTaskListController>();

  @override
  void initState() {
    super.initState();
    _getNewTaskList();
    _getTaskStatusCount();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return RefreshIndicator(
      onRefresh: ()async{
        _getNewTaskList();
        _getTaskStatusCount();
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
              buildSummarySection(),
              Expanded(
                  child: GetBuilder<NewTaskListController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !(controller.newTaskListInProgress || controller.taskStatusCountInProgress),
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ListView.separated(
                          itemCount: controller.taskList.length,
                          itemBuilder: (context, index) {
                            return TaskCard(taskModel: controller.taskList[index], onRefreshList: _getNewTaskList);
                          },
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                        ),
                      );
                    },
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onTapAddFAB() async {
     final bool? shouldRefresh = await Get.to(AddNewTaskScreen.name);
     //Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const AddNewTaskScreen()),
    // );
    if (shouldRefresh == true) {
      _getNewTaskList();
    }
  }

  Future<void> _getNewTaskList() async {

    final bool result= await _newTaskListController.getNewTaskList();
    if (result==false) {
      ShowSnackBarMessage(context, _newTaskListController.errorMessage!, true);
    }

  }
  Future<void> _getTaskStatusCount() async {
    //_taskStatusCountList.clear();
   final bool result= await _newTaskListController.getTaskStatusCount();
    if (result==false) {
      ShowSnackBarMessage(context, _newTaskListController.errorMessage!, true);
    }
  }
  Widget buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<NewTaskListController>(
        builder: (controller) {
          return Visibility(
            visible:!controller.taskStatusCountInProgress  ,
            replacement: const CenteredCircularProgressIndicator(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _getTaskSummaryCardList(),
              ),
            ),
          );
        }
      ),
    );
  }
  List<TaskSummaryCard>_getTaskSummaryCardList(){
    List<TaskSummaryCard>taskSummaryCardList=[];
    for(TaskStatusModel t in _newTaskListController.taskStatusCountList){
      taskSummaryCardList.add(TaskSummaryCard(title: t.sId!, count: t.sum??0));
    }
    return taskSummaryCardList;

  }

}





