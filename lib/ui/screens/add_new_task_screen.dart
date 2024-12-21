import 'package:flutter/material.dart';
import 'package:ostad_batch_07/data/models/network_response.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';
import 'package:ostad_batch_07/ui/widgets/tm_app_bar.dart';
import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  bool inProgress = false;
  bool _shouldRefreshPreviousPage=false;

  @override
  void dispose() {
    _titleTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop:true ,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, _shouldRefreshPreviousPage);
      },
      // onPopInvoked: (bool didPop) {
      //   // If the pop action wasn't handled by the scope itself, pass the result
      //   if (!didPop) {
      //     Navigator.pop(context, _shouldRefreshPreviousPage);
      //   }
      // },


      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const TMAppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 42,
                ),
                Center(
                    child: Text(
                  "Add New Task",
                  style:
                      textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                )),
                const SizedBox(
                  height: 26,
                ),
                _buildAddTaskForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              hintText: "Write your title",
              labelText: "Title",
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return "Enter the title";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: _descriptionTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textAlign: TextAlign.start,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: "Write your description",
              labelText: "Description",
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return "Write your description.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !inProgress,
            replacement: const CenteredCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: _onTapSubmitButton,
              child: const Icon(
                Icons.arrow_circle_right_outlined,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }

  }

  Future<void> _addNewTask() async {
    if (!mounted) return;
    inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };
    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.createTask,
        body: requestBody,
      );
      if (!mounted) return;
      inProgress = false;
      setState(() {});
      if (response.isSuccess) {
        _shouldRefreshPreviousPage=true; ///Mark refresh as needed
        _clearTextFields();
        ShowSnackBarMessage(context, "Successfully Add Task");
      } else {
        ShowSnackBarMessage(context, response.errorMessage, true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          inProgress = false;
        });
      }
      ShowSnackBarMessage(context, 'Show error message:$e', true);
    }
  }

  void _clearTextFields() {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }
}
