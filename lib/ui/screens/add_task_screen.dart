import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? endTime;
  int imageCount = 0; // Counter for images
  int fileCount = 0; // Counter for files
  bool _isLoading = false; // Loading state
  List<TextEditingController> controllers = [];
  List<bool> showClearIcon = [];
  final ImagePicker _picker = ImagePicker();
  List<String> attachedFiles = [];

  void _addSubtaskField() {
    setState(() {
      controllers.add(TextEditingController());
      showClearIcon.add(false);
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
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
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? now,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
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

  // void _attachFile(String filePath) {
  //   setState(() {
  //     attachedFiles.add(filePath);
  //   });
  // }
  Future<void> _attachFile(String filePath) async {
    setState(() {
      attachedFiles.add(filePath);

      if (filePath.endsWith('.pdf') ||
          filePath.endsWith('.doc') ||
          filePath.endsWith('.docx')) {
        fileCount++;
      } else {
        imageCount++;
      }
    });
  }

  void _removeAttachedFile(String filePath) {
    setState(() {
      attachedFiles.remove(filePath);
      if (filePath.endsWith('.pdf') ||
          filePath.endsWith('.doc') ||
          filePath.endsWith('.docx')) {
        fileCount--;
      } else {
        imageCount--;
      }
    });
  }

  // Future<void> _pickImageFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //   if (image != null) {
  //     _attachFile(image.path);
  //   }
  // }
  Future<void> _pickImageFromCamera() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _attachFile(image.path);
    }
    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  /* Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _attachFile(image.path);
    }
  }*/
  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true; // Start loading
    });
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _attachFile(image.path);
    }
    setState(() {
      _isLoading = false; // Stop loading
    });
  }

  Future<void> _attachDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.isNotEmpty) {
        String filePath = result.files.single.path!;
        _attachFile(filePath);
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking file: $e');
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
                          Text('Assigned to',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('Imtiaz Rony',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            startDate == null
                                ? DottedBorder(
                                    strokeWidth: 1.0,
                                    color: Colors.grey,
                                    borderType: BorderType.Circle,
                                    dashPattern: [5, 3],
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.green, width: 1.2),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(Icons.calendar_today,
                                          size: 18, color: Colors.grey),
                                    ),
                                  ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Due date',
                                  style: TextStyle(
                                      color: startDate == null
                                          ? Colors.grey
                                          : Colors.black),
                                ),
                                if (startDate != null)
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                    child: Text(
                                      formatDateTime(startDate, endTime),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
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
                            const Icon(Icons.check_circle_outline_sharp,
                                size: 25, color: Colors.grey),
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
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            if (showClearIcon[index])
                              IconButton(
                                icon: const Icon(Icons.cancel, size: 20),
                                onPressed: () {
                                  _removeSubtaskField(index);
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (_shouldShowAddSubtask() && controllers.isEmpty)
                    TextButton(
                      onPressed: _addSubtaskField,
                      child: const Text('+ Add Subtask',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  const SizedBox(height: 20),
// Loader for image and file picking
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                  // Display attached files as cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: attachedFiles.map((file) {
                        final isPdf = file.endsWith('.pdf') ||
                            file.endsWith('.doc') ||
                            file.endsWith('.docx');
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Stack(
                            children: [
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      // Use a placeholder image for demonstration
                                      isPdf
                                          ? Row(
                                              children: [
                                                Icon(Icons.picture_as_pdf,
                                                    size: 50,
                                                    color: Colors.red),
                                                const SizedBox(width: 8),
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    file.split('/').last,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Image.file(File(file),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 1,
                                top: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel_rounded,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      // attachedFiles.remove(file);
                                      _removeAttachedFile(file);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 160),

                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImageFromCamera,
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: _pickImageFromGallery,
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: _attachDocument,
                      ),
                      IconButton(
                        icon: const Icon(Icons.group_add),
                        onPressed: () {},
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle create action
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImageFromCamera,
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.photo_library),
                            onPressed: _pickImageFromGallery,
                          ),
                          if (imageCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  '$imageCount',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: _attachDocument,
                          ),
                          if (fileCount > 0)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  '$fileCount',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.group_add),
                        onPressed: () {},
                      ),
                      TextButton(
                        onPressed: () {
                          // Handle create action
                        },
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
