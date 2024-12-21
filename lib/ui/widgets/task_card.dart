import 'package:flutter/material.dart';
import 'package:ostad_batch_07/data/services/network_caller.dart';
import 'package:ostad_batch_07/ui/widgets/show_snack_bar_message.dart';
import '../../data/models/network_response.dart';
import '../../data/models/task_model.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskModel, required this.onRefreshList,
  });
  final VoidCallback onRefreshList;
  final TaskModel taskModel;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  String _selectedStatus = "";
  bool _changeStatusInProgress = false;


  @override
  void initState() {
    super.initState();
    _selectedStatus =
        widget.taskModel.status ?? "New"; // Default to "New" if null
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title ?? '',
              style:
                  textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              ' ${widget.taskModel.description ?? ''}',
              style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400, color: Colors.black87),
            ),
            Text(
              "Dated: ${widget.taskModel.createdDate ?? ''}",
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChipStatus(status: _selectedStatus),
                // Pass current status
                _buildEditDeletePortion(
                  selectedStatus: _selectedStatus,
                  onUpdateStatus: (newStatus) {
                    setState(() {
                      _selectedStatus = newStatus; // Update state dynamically
                    });
                  }, onChangeStatus: _changeStatus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeStatus(String newStatus) async {
    _changeStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.changeStatus(widget.taskModel.sId!, newStatus));
    if(
    response.isSuccess
    ){
      widget.onRefreshList();
    }else{
      _changeStatusInProgress=false;
      setState(() {

      });
      ShowSnackBarMessage(context,response.errorMessage);
    }
  }
}

class _buildEditDeletePortion extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onUpdateStatus;
  final Function(String) onChangeStatus;

  const _buildEditDeletePortion({
    super.key,
    required this.selectedStatus,
    required this.onUpdateStatus,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          onPressed: () {
            _onTapEditButton(context);
          },
          icon: const Icon(
            Icons.edit_location_alt_outlined,
            size: 20,
          ),
        ),
        IconButton(
          onPressed: _onTapDeleteButton,
          icon: const Icon(
            Icons.delete_sweep_sharp,
            size: 20,
          ),
        ),
      ],
    );
  }

  void _onTapDeleteButton() {
    // TODO: Implement delete functionality
  }

  void _onTapEditButton(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String tempSelectedStatus =
            selectedStatus; // Local state within the dialog
        // Using StatefulBuilder for dynamic updates within the dialog
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Edit Status"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    onUpdateStatus(tempSelectedStatus); // Update parent state
                    onChangeStatus(tempSelectedStatus); // Perform the network request
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    ["New", "Completed", "Cancelled", "InProgress"].map((e) {
                  return ListTile(
                    title: Text(e),
                    selected: tempSelectedStatus == e,
                    // Highlight the current selection
                    trailing: tempSelectedStatus == e
                        ? const Icon(Icons.check, color: AppColors.themeColor)
                        : null,
                    onTap: () {
                      // Update the selected status inside the dialog
                      setState(() {
                        tempSelectedStatus = e;// Update the local state
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}

class _buildChipStatus extends StatelessWidget {
  final String status;

  const _buildChipStatus({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Chip(
      label: Text(
        status, // Display the dynamic status
        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(
        color: AppColors.themeColor,
      ),
    );
  }
}

///Note for use widget
/*widget is specific to StatefulWidget and is used to access the StatefulWidget class's properties inside its associated State class.
 For a StatelessWidget, you directly use the class properties or variables passed to its constructor. */
