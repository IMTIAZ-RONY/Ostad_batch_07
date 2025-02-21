import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'home_screens.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}
class _AddTaskScreenState extends State<AddTaskScreen> {
  // GetStorage for local storage
  final GetStorage _storage = GetStorage();

  // Project-related controllers and variables
  final TextEditingController _projectController = TextEditingController();
  final FocusNode _projectFocusNode = FocusNode();
  List<String> savedProjects = [];
  List<String> filteredProjects = [];
  bool showProjectSuggestions = false;
  //others
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  int imageCount = 0; // Counter for images
  int fileCount = 0; // Counter for files
  bool _isLoading = false; // Loading state
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  TextAlign textAlign = TextAlign.left;
  double fontSize = 16.0;
  Color fontColor = Colors.black;
  bool isBulletList = false;
  bool isNumberList = false;
  List<String> listItems = [];
  bool isDescriptionFocused = false;
  TextEditingController taskNameController = TextEditingController();
  List<TextEditingController> controllers = [];
  List<bool> showClearIcon = [];
  final ImagePicker _picker = ImagePicker();
  List<String> attachedFiles = [];
  bool _shouldShowAddSubtask() {
    return controllers.isEmpty ||
        controllers.every((controller) => controller.text.isEmpty);
  }
  FleatherController? _controller;
  final GlobalKey<EditorState> _editorKey = GlobalKey();
  final FocusNode _editorFocusNode = FocusNode();
  // Load projects from storage
  void _loadProjects() {
    List<dynamic>? storedProjects = _storage.read<List>('projects');
    if (storedProjects != null) {
      setState(() {
        savedProjects = List<String>.from(storedProjects);
      });
    }
  }
  // Save new project avoiding duplicates
  void _saveProject(String projectName) {
    if (projectName.isEmpty || savedProjects.contains(projectName)) return;
    setState(() {
      savedProjects.add(projectName);
      _storage.write('projects', savedProjects);
    });
  }
  // Update this method to properly filter projects and display suggestions
  void _onProjectChanged(String input) {
    setState(() {
      if (savedProjects.isEmpty) {
        filteredProjects = ["No project name available here"];
        showProjectSuggestions = true;
        return;
      }

      filteredProjects = savedProjects
          .where((project) => project.toLowerCase().contains(input.toLowerCase()))
          .toList();

      // if (filteredProjects.isEmpty && input.isNotEmpty) {
      //   filteredProjects = [ input];
      // }
      showProjectSuggestions = input.isNotEmpty && filteredProjects.isEmpty ? false : true;
      //showProjectSuggestions = true;
    });
  }

  // Update _selectSuggestion method

  void _selectSuggestion(String selection) {
    if (selection.startsWith("Add new project: ")) {
      final newProject = selection.replaceFirst("Add new project: ", "").replaceAll("'", "");
    //  _saveProject(newProject);
      _projectController.text = newProject;
    } else if (selection != "No project name available here") {
      _projectController.text = selection;
    }
    setState(() => showProjectSuggestions = false);
  }

  Future<void> _initController() async {
    final heuristics = ParchmentHeuristics(
      formatRules: [],
      insertRules: [ForceNewlineForInsertsAroundInlineImageRule()],
      deleteRules: [],
    ).merge(ParchmentHeuristics.fallback);

    try {
      final doc = ParchmentDocument.fromJson(jsonDecode('{"ops":[{"insert":"\\n"}]}'), heuristics: heuristics);
      _controller = FleatherController(document: doc);
    } catch (err) {
      _controller = FleatherController();
    }
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _initController();
    _loadProjects();
    // Focus listener for project field
    _projectFocusNode.addListener(() {
      if (_projectFocusNode.hasFocus) {
        setState(() {
          filteredProjects = savedProjects;
          showProjectSuggestions = true;
        });
      } else {
        setState(() {
          showProjectSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _projectController.dispose();
    _projectFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("TaskApp.."),
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
                                dashPattern: const [5, 3],
                                child: const Padding(
                                padding: EdgeInsets.all(5.0),
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
                                    child: SingleChildScrollView(
                                      scrollDirection:Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Text(
                                            _formatDateTime(startDate, startTime),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width:8 ,),
                                          Text(
                                            _formatDateTime(endDate, endTime),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
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
                  _buildAddProject(),
                  const SizedBox(height: 4),
                  _buildDescriptionField(),
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
                                  decoration:  const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:'Type here...',
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
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
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
                                          const Icon(Icons.picture_as_pdf,
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
                                      color: Colors.red),
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
                  _buildBottomRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Update _buildAddProject method
 /* Widget _buildAddProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _projectController,
          focusNode: _projectFocusNode,
          onChanged: _onProjectChanged,
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          decoration: const InputDecoration(
            hintText: '+ Add Project',
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey
            ),
          ),
        ),
        if (showProjectSuggestions)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(
                    filteredProjects[index],
                    style: TextStyle(
                      color: filteredProjects[index] == "No project name available here"
                          ? Colors.grey
                          : Colors.black,
                      fontStyle: filteredProjects[index] == "No project name available here"
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                  onTap: () => _selectSuggestion(filteredProjects[index]),
                );
              },
            ),
          ),
      ],
    );
  }*/
  // 2. _buildAddProject উইজেটে Create বাটন যোগ করুন
  Widget _buildAddProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _projectController,
          focusNode: _projectFocusNode,
          onChanged: _onProjectChanged,
          decoration: const InputDecoration(
            hintText: '+ Add Project',
            border: InputBorder.none,
            hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey
            ),
          ),
        ),
        if (showProjectSuggestions && filteredProjects.isNotEmpty)
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(filteredProjects[index]),
                  onTap: () => _selectSuggestion(filteredProjects[index]),
                );
              },
            ),
          ),
        if (_projectController.text.isNotEmpty && filteredProjects.isEmpty)
         /* TextButton(
            onPressed: () {
              final newProject = _projectController.text.trim();
              if (newProject.isNotEmpty) {
                _saveProject(newProject);
                _loadProjects();
                setState(() {
                  showProjectSuggestions = false;
                });
              }
            },
            child: const Text('Create project name'),
          ),*/
    TextButton(
    onPressed: () {
    final newProject = _projectController.text.trim();
    if (newProject.isNotEmpty) {
    _saveProject(newProject); // Save the project
    _loadProjects(); // Reload the list

    // Check if the project was actually added
    final isAdded = filteredProjects.contains(newProject);

    setState(() {
    showProjectSuggestions = false;
    });

    // Show success or failure message
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text(isAdded ? 'Failed to add project' :'Project added successfully!' ),
    backgroundColor: isAdded ? Colors.red : Colors.green,
    duration: const Duration(seconds: 2),
    ),
    );
    }
    },
    child: const Text('Create project name'),
    ),


      ],
    );
  }
  // Modify _buildDescriptionField
  Widget _buildDescriptionField() {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          isDescriptionFocused = hasFocus;
        });
      },
      child: GestureDetector(
        onTap: (){
          _editorFocusNode.requestFocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!_editorFocusNode.hasFocus)
              const Text('Description', style: TextStyle(fontSize: 16,color:Colors.grey ,fontWeight:FontWeight.w500 ,)),
            if(!_editorFocusNode.hasFocus)
              const SizedBox(height: 2),
            Container(
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Column(
                children: [
                  if(_editorFocusNode.hasFocus)
                    if (isDescriptionFocused)
                      FleatherToolbar.basic(controller: _controller!, editorKey: _editorKey),
                  FleatherEditor(
                    controller: _controller!,
                    focusNode: _editorFocusNode,
                    editorKey: _editorKey,
                    padding: const EdgeInsets.all(2),
                    embedBuilder: _embedBuilder,
                    minHeight: 50,
                    maxHeight:100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _embedBuilder(BuildContext context, EmbedNode node) {
    if (node.value.type == 'image') {
      final sourceType = node.value.data['source_type'];
      ImageProvider? image;
      if (sourceType == 'file') {
        image = FileImage(File(node.value.data['source']));
      } else if (sourceType == 'url') {
        image = NetworkImage(node.value.data['source']);
      }
      if (image != null) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Image(image: image, width: 200, height: 200, fit: BoxFit.cover),
        );
      }
    }
    return defaultFleatherEmbedBuilder(context, node);
  }
  Widget _buildBottomRow() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
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
                          backgroundColor: Colors.red,
                          child: Text(
                            '$imageCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
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
                          backgroundColor: Colors.red,
                          child: Text(
                            '$fileCount',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.group_add),
                  onPressed: () {
                    // Collaborator action
                  },
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: _createTask,
          child: const Text('Create'),
        ),
      ],
    );
  }
  /*void _createTask() {
    String taskName = taskNameController.text.trim();
    String projectName = _projectController.text.trim();
    String description = _controller?.document.toPlainText().trim() ?? '';
    if (projectName.isNotEmpty &&
        projectName != "No Project" &&
        !savedProjects.contains(projectName)) {
      _saveProject(projectName);
    }
    // Check if at least one field is filled
    if (taskName.isEmpty && projectName.isEmpty && description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill at least one field')),
      );
      return;
    }
    // Save task to GetStorage
    List<dynamic> tasks = _storage.read<List>('tasks') ?? [];
    tasks.add({
      'taskName': taskName.isEmpty ? 'Untitled Task' : taskName,
      'projectName': projectName.isEmpty ? 'No Project' : projectName,
      'description': description.isEmpty ? 'No Description' : description,
      'createdAt': DateTime.now().toString(),
    });
    _storage.write('tasks', tasks);
    // প্রজেক্ট লিস্ট রিফ্রেশ করুন
    _loadProjects();
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task Created Successfully!')),
    );
    // Clear fields
    taskNameController.clear();
    _projectController.clear();
    _controller?.replaceText(0, _controller!.document.length - 1, '');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
    );
  }*/
  // 3. _createTask মেথডে প্রজেক্ট সেভ লজিক আপডেট করুন
  void _createTask() {
    String taskName = taskNameController.text.trim();
    String projectName = _projectController.text.trim();

    // শুধুমাত্র নতুন প্রজেক্ট সেভ করুন
    if (projectName.isNotEmpty && !savedProjects.contains(projectName)) {
      _saveProject(projectName);
    }

    // টাস্ক সেভ লজিক
    List<dynamic> tasks = _storage.read<List>('tasks') ?? [];
    tasks.add({
      'taskName': taskName.isEmpty ? 'Untitled Task' : taskName,
      'projectName': projectName.isEmpty ? 'No Project' : projectName,
      'description': _controller?.document.toPlainText().trim() ?? 'No Description',
      'createdAt': DateTime.now().toString(),
    });
    _storage.write('tasks', tasks);

    // হোম স্ক্রিনে রিডাইরেক্ট
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
    );
  }
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
  String _formatDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return 'Select Date';
    if (time == null) {
      return DateFormat('EEE, MMM d, y').format(date);
    } else {
      final dateTime =
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
      return DateFormat('EEE, MMM d, y - h:mm a').format(dateTime);
    }
  }
  Future<void> _selectStartDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? now,
      firstDate: DateTime(now.year - 50),
      lastDate: DateTime(now.year + 50),
      helpText: 'Select start date.',
      initialDatePickerMode: DatePickerMode.day,
      // Start with day picker
      fieldHintText: 'MM/DD/YYYY',
      // Hint for manual input
      fieldLabelText: 'Enter your 1st date.', // Label for manual input
    );

    if (picked != null) {
      setState(() {
        startDate = picked;
      });
      _selectStartTime(context);
    }
  }
  Future<void> _selectStartTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
      helpText:"Select start time.",
    );
    if (picked != null) {
      setState(() {
        startTime = picked;
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
      helpText: 'Select end date.',
      initialDatePickerMode: DatePickerMode.day,
      fieldHintText: "MM/DD/YYYY",
      fieldLabelText: "Enter your 2nd date.",
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
      helpText:"Select end time.",
    );
    if (picked != null) {
      setState(() {
        endTime = picked;
      });
    }
  }
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
}
class ForceNewlineForInsertsAroundInlineImageRule extends InsertRule {
  @override
  Delta? apply(Delta document, int index, Object data) {
    if (data is! String) return null;
    final iter = DeltaIterator(document);
    final previous = iter.skip(index);
    final target = iter.next();
    final cursorBeforeInlineEmbed = _isInlineImage(target.data);
    final cursorAfterInlineEmbed = previous != null &&
        _isInlineImage(previous.data);

    if (cursorBeforeInlineEmbed || cursorAfterInlineEmbed) {
      final delta = Delta()
        ..retain(index);
      if (cursorAfterInlineEmbed && !data.startsWith('\n')) delta.insert('\n');
      delta.insert(data);
      if (cursorBeforeInlineEmbed && !data.endsWith('\n')) delta.insert('\n');
      return delta;
    }
    return null;
  }
  bool _isInlineImage(Object data) {
    if (data is EmbeddableObject) return data.type == 'image' && data.inline;
    if (data is Map) {
      return data[EmbeddableObject.kTypeKey] == 'image' &&
          data[EmbeddableObject.kInlineKey];
    }
    return false;
  }
}