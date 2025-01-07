/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../business_logic/controllers/task_controllers.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController collaboratorController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedFilePath = '';
  List<String> collaborators = [];

  // 📅 Date Picker
  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ⏰ Time Picker
  Future<void> _selectDueTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  // 📄 File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    } else {
      Get.snackbar('Error', 'No file selected');
    }
  }

  // 📷 Image Picker (Gallery or Camera)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

    if (image != null && image.path != null) {
      setState(() {
        selectedFilePath = image.path;
      });
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }

  // ➕ Add Collaborators
  void _addCollaborator() {
    if (collaboratorController.text.isNotEmpty) {
      setState(() {
        collaborators.add(collaboratorController.text);
        collaboratorController.clear();
      });
    }
  }

  // ❌ Remove Collaborator
  void _removeCollaborator(String name) {
    setState(() {
      collaborators.remove(name);
    });
  }

  // ✅ Save Task
  void _saveTask() {
    // if (titleController.text.isEmpty ||
    //     projectController.text.isEmpty ||
    //     descriptionController.text.isEmpty) {
    //   Get.snackbar('Error', 'Please fill all required fields');
    //   return;
    // }

    controller.addTask(
      title: titleController.text,
      subtitle: subtitleController.text,
      description: descriptionController.text,
      projectName: projectController.text,
      dueDate: selectedDate,
      filePath: selectedFilePath,
      collaborators: collaborators,
    );
    Get.back();
  }

  // 📥 Show Attachment Dialog
  Future<void> _showAttachmentDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Attach Document'),
              onTap: () async {
                await _pickFile();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                await _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Task name... ',
                border:InputBorder.none,
                hintStyle:TextStyle(fontSize:24 ,fontWeight:FontWeight.w500 ,color:Colors.grey ,) ),
                style: const TextStyle(fontSize:24,fontWeight:FontWeight.w500 ,) ,
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(hintText: 'Task subtitle',
              border:InputBorder.none,
                  hintStyle:TextStyle(fontSize:20 ,fontWeight:FontWeight.w500 ,color:Colors.grey ,) ),
              style: const TextStyle(fontSize:20,fontWeight:FontWeight.w500 , ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description '),
              maxLines: 3,
            ),
            TextField(
              controller: projectController,
              decoration: const InputDecoration(labelText: 'Project Name'),
            ),
            const SizedBox(height: 16),

            // 📅 Due Date
            ListTile(
              title: const Text('Due Date'),
              subtitle: Text(DateFormat.yMMMd().format(selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDueDate(context),
            ),

            // ⏰ Due Time
            ListTile(
              title: const Text('Due Time'),
              subtitle: Text(selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () => _selectDueTime(context),
            ),

            // 📂 Attachment Section
            const SizedBox(height: 16),
            const Text('Attachment'),
            ListTile(
              title: selectedFilePath.isEmpty
                  ? const Text('No file selected')
                  : selectedFilePath.endsWith('.jpg') ||
                  selectedFilePath.endsWith('.png')
                  ? Image.file(
                File(selectedFilePath),
                width: 100,
                height: 100,
              )
                  : Text(selectedFilePath),
              trailing: const Icon(Icons.attach_file),
              onTap: _showAttachmentDialog,
            ),
            const SizedBox(height: 16),

            // 👥 Collaborators
            TextField(
              controller: collaboratorController,
              decoration: const InputDecoration(labelText: 'Add Collaborator'),
              onSubmitted: (_) => _addCollaborator(),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: collaborators.map((name) {
                return Chip(
                  label: Text(name),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () => _removeCollaborator(name),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTask,
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}*/

///Asana
///
/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../business_logic/controllers/task_controllers.dart';
import '../../data/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController projectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedFilePath = '';

  // Date Picker
  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // File Picker
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path!;
      });
    }
  }

  // Image Picker (Gallery or Camera)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedFilePath = image.path;
      });
    }
  }

  // Save Task
  void _saveTask() {
    final newTask = Task.create(
      title: titleController.text.isNotEmpty ? titleController.text : 'Untitled Task',
      subtitle: projectController.text,
      description: descriptionController.text,
      projectName: projectController.text,
      dueDate: selectedDate,
      filePath: selectedFilePath,
      collaborators: [],
    );

    controller.addTask(newTask);
    Get.back();
  }

  // Attachment Dialog
  Future<void> _showAttachmentDialog() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Attach Document'),
              onTap: () async {
                await _pickFile();
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                await _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Private to you',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Task name...',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.pink,
                  child: Text(
                    'IR',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assigned to',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Text(
                      'Imtiaz Rony',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 30.w),
                  child: GestureDetector(
                    onTap: () => _selectDueDate(context),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20.sp),
                        SizedBox(width: 4.w),
                        Text(
                          'Due date',
                          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            TextField(
              controller: projectController,
              decoration: InputDecoration(
                hintText: '+ Add Project',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
            Expanded(
              child: TextField(
                controller: descriptionController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),
            ),
            ListTile(
              title: Text('+ Add Subtask', style: TextStyle(fontSize: 14.sp)),
            ),

            // Bottom Icons and Create Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: Icon(Icons.camera_alt), onPressed: () => _pickImage(ImageSource.camera)),
                IconButton(icon: Icon(Icons.photo_library), onPressed: () => _pickImage(ImageSource.gallery)),
                IconButton(icon: Icon(Icons.attach_file), onPressed: _showAttachmentDialog),
                IconButton(icon: Icon(Icons.group_add), onPressed: () {}),
                TextButton(
                  onPressed: _saveTask,
                  child: const Text('Create'),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
} */

///2nd
///2nd

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  /*DateTime? dueDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<TimeOfDay?> additionalTimes = [];*/

  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? endTime;

  List<TextEditingController> controllers = [];

  List<bool> showClearIcon = [];

  void _addSubtaskField() {
    setState(() {
      controllers.add(TextEditingController());
      showClearIcon.add(
          false); // Always add a false value to keep the lists in sync  // নতুন ফিল্ডের জন্য false
    });
  }

  void _removeSubtaskField(int index) {
    setState(() {
      controllers[index].dispose();
      controllers.removeAt(index);
      showClearIcon.removeAt(index);
    });
  }

  bool _shouldShowAddSubtask() {
    return controllers.isEmpty ||
        controllers.every((controller) => controller.text.isEmpty);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 50);
    DateTime lastDate = DateTime(now.year + 50);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
      _selectEndDate(context);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 50);
    DateTime lastDate = DateTime(now.year + 50);
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        endDate = picked;
      });
      _selectEndTime(context);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  String formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return 'Select Date';
    if (time == null) {
      return DateFormat('EEE, MMM d, y').format(date);
    } else {
      final dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return DateFormat('EEE, MMM d, y - h:mm a').format(dateTime);
    }
  }

  /* Future<void> _selectDueDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
      _showTimePickerModal(context);
    }
  }

  Future<void> _showTimePickerModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Start time'),
                trailing: Text(startTime?.format(context) ?? 'Add start time'),
                onTap: () => _selectStartTime(context),
              ),
              ListTile(
                title: const Text('Due time'),
                trailing: Text(endTime?.format(context) ?? 'Add due time'),
                onTap: () => _selectEndTime(context),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done', style: TextStyle(color: Colors.blue)),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: endTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }

  Future<void> _addMoreTimes(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        additionalTimes.add(picked);
      });
    }
  }

  String formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return 'Select Date & Time';
    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat('EEE, MMM d - h:mm a').format(dateTime);
  }*/

  /* Future<void> _selectDueDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: dueTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          dueDate = picked;
          dueTime = pickedTime;
        });
        _selectStartAndEndDates(context);
      }
    }
  }

  Future<void> _selectStartAndEndDates(BuildContext context) async {
    DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedStart != null) {
      DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: pickedStart,
        firstDate: pickedStart,
        lastDate: DateTime(2100),
      );

      setState(() {
        startDate = pickedStart;
        endDate = pickedEnd;
      });
    }
  }

  String formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return 'Due Date';
    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat('EEE, MMM d, h:mm a').format(dateTime);
  }*/

  @override
  void initState() {
    super.initState();
    // Initialize with one empty field at the start if needed
    _addSubtaskField();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("TaskApp"),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Private to you',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),

                  // Task Name Field
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Task name...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.pink,
                        child:
                            Text('IR', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assigned to',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            'Imtiaz Rony',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          startDate==null?DottedBorder(
                            strokeWidth:1.0,
                              color:Colors.grey ,
                              borderType:BorderType.Circle ,
                              dashPattern: [5,3],
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon( Icons.calendar_today,size: 18,color:Colors.grey ,),
                              )):Container(
                            decoration:BoxDecoration(
                             shape:BoxShape.circle ,
                              border:Border.all(
                                color:Colors.green,
                                width:1.2 ,
                              ) ,
                            ) ,
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due date',
                                  style: TextStyle(
                                    color: startDate == null ? Colors.grey : Colors.black,
                                  ),
                                ),
                                if (startDate != null)
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                       maxWidth: MediaQuery.of(context).size.width * 0.3,
                                    ),
                                    child: Text(
                                      formatDateTime(startDate, endTime),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 20),

                  // Project Name Field
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '+ Add Project',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 4),

                  // Description Field
                  TextFormField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 2),

                  /// Subtask Section
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controllers.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_sharp,
                              size: 25,
                              weight: 100,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  if (index < showClearIcon.length) {
                                    setState(() {
                                      showClearIcon[index] = hasFocus &&
                                          controllers[index].text.isNotEmpty;
                                    });
                                  }
                                },
                                child: TextFormField(
                                  controller: controllers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      showClearIcon[index] = value.isNotEmpty;
                                    });
                                  },
                                  onFieldSubmitted: (value) {
                                    if (value.isNotEmpty &&
                                        index == controllers.length - 1) {
                                      _addSubtaskField();
                                    }
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Type here...',
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                                ),
                              ),
                            ),
                            if (showClearIcon[index])
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                onPressed: () {
                                  _removeSubtaskField(index);
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  /// Condition to show + Add Subtask
                  if (_shouldShowAddSubtask() && controllers.isEmpty)
                    TextButton(
                      onPressed: _addSubtaskField,
                      child: const Text('+ Add Subtask',
                          style: TextStyle(color: Colors.grey)),
                    ),

                  const SizedBox(height: 150),

                  // Bottom Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.camera_alt), onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {}),
                      IconButton(
                          icon: const Icon(Icons.group_add), onPressed: () {}),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///3rd
