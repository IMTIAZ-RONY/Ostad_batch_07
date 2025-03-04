import 'dart:convert';
import 'dart:io';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ostad_batch_07/ui/const/constants.dart';
import 'package:ostad_batch_07/ui/const/strings.dart';
import 'package:ostad_batch_07/ui/const/text_styles.dart';
import 'package:ostad_batch_07/ui/widgets/assign_to_widgets.dart';
import 'package:ostad_batch_07/ui/widgets/due_date_widget.dart';
import '../function/add_tasks_function.dart';
import '../utils/date_time_utils.dart';
import '../utils/subtask_utils.dart';
import '../widgets/add_task_widgets.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GetStorage _storage = GetStorage();
  final TextEditingController _projectController = TextEditingController();
  final FocusNode _projectFocusNode = FocusNode();
  List<String> savedProjects = [];
  List<String> filteredProjects = [];
  bool showProjectSuggestions = false;
  bool showNoProjectMessage = false;
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  int imageCount = 0;
  int fileCount = 0;
  bool _isLoading = false;
  bool isDescriptionFocused = false;
  TextEditingController taskNameController = TextEditingController();
  List<TextEditingController> controllers = [];
  List<bool> showClearIcon = [];
  final ImagePicker _picker = ImagePicker();
  List<String> attachedFiles = [];
  FleatherController? _controller;
  final GlobalKey<EditorState> _editorKey = GlobalKey();
  final FocusNode _editorFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initController();
    _loadProjects();
    _projectFocusNode.addListener(() {
      if (_projectFocusNode.hasFocus) {
        onProjectChanged(
          _projectController.text,
          savedProjects,
          (List<String> projects) =>
              setState(() => filteredProjects = projects),
          (bool value) => setState(() => showNoProjectMessage = value),
          (bool value) => setState(() => showProjectSuggestions = value),
        );
      } else {
        setState(() {
          showProjectSuggestions = false;
          showNoProjectMessage = false;
        });
      }
    });
  }

  void _loadProjects() {
    List<dynamic>? storedProjects = _storage.read<List>('projects');
    if (storedProjects != null) {
      setState(() {
        savedProjects = List<String>.from(storedProjects);
      });
    }
  }

  Future<void> _initController() async {
    final heuristics = ParchmentHeuristics(
      formatRules: [],
      insertRules: [ForceNewlineForInsertsAroundInlineImageRule()],
      deleteRules: [],
    ).merge(ParchmentHeuristics.fallback);

    try {
      final doc = ParchmentDocument.fromJson(
          jsonDecode('{"ops":[{"insert":"\\n"}]}'),
          heuristics: heuristics);
      _controller = FleatherController(document: doc);
    } catch (err) {
      _controller = FleatherController();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _projectController.dispose();
    _projectFocusNode.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedStartDate = await selectStartDate(context, startDate);
    if (pickedStartDate != null) {
      setState(() => startDate = pickedStartDate);
      TimeOfDay? pickedStartTime = await selectStartTime(context, startTime);
      if (pickedStartTime != null) {
        setState(() => startTime = pickedStartTime);
        DateTime? pickedEndDate = await selectEndDate(context, endDate);
        if (pickedEndDate != null) {
          setState(() => endDate = pickedEndDate);
          TimeOfDay? pickedEndTime = await selectEndTime(context, endTime);
          if (pickedEndTime != null) {
            setState(() => endTime = pickedEndTime);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: const Text("TaskApp..")),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(privateToYou,
                    style: TextStyle(color: greyColor, fontSize: 14)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: taskNameController,
                  decoration: const InputDecoration(
                    hintText: taskNameHint,
                    border: InputBorder.none,
                    hintStyle: taskNameHintStyle,
                  ),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const AssignedToWidget(),
                    const SizedBox(width: 8),
                    const Spacer(),
                    DueDateWidget(
                        startDate: startDate,
                        startTime: startTime,
                        endDate: endDate,
                        endTime: endTime,
                        onTap: _selectDateTime)
                  ],
                ),
                const SizedBox(height: 20),
                buildAddProject(
                  projectController: _projectController,
                  projectFocusNode: _projectFocusNode,
                  filteredProjects: filteredProjects,
                  showProjectSuggestions: showProjectSuggestions,
                  showNoProjectMessage: showNoProjectMessage,
                  onCreateProject: () {
                    final newProject = _projectController.text.trim();
                    if (newProject.isNotEmpty &&
                        !savedProjects.contains(newProject)) {
                      saveProject(newProject, savedProjects, _storage);
                      setState(() => showProjectSuggestions = false);
                    }
                  },
                  onSelectSuggestion: (selection) {
                    _projectController.text = selection;
                    setState(() => showProjectSuggestions = false);
                  },
                  onProjectChanged: (input) {
                    onProjectChanged(
                      input,
                      savedProjects,
                      (List<String> projects) =>
                          setState(() => filteredProjects = projects),
                      (bool value) =>
                          setState(() => showNoProjectMessage = value),
                      (bool value) =>
                          setState(() => showProjectSuggestions = value),
                    );
                  },
                  context: context,
                ),
                const SizedBox(height: 4),
                buildDescriptionField(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      isDescriptionFocused = hasFocus;
                    });
                  },
                  controller: _controller,
                  editorFocusNode: _editorFocusNode,
                  editorKey: _editorKey,
                  isDescriptionFocused: isDescriptionFocused,
                  embedBuilder: _embedBuilder,
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
                              onPressed: () => _removeSubtaskField(index),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                if (shouldShowAddSubtask(controllers) && controllers.isEmpty)
                  TextButton(
                    onPressed: _addSubtaskField,
                    child: const Text(addSubtask,
                        style: TextStyle(color: greyColor)),
                  ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
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
                                    isPdf
                                        ? Row(
                                            children: [
                                              const Icon(Icons.picture_as_pdf,
                                                  size: 50, color: Colors.red),
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
                                onPressed: () => _removeAttachedFile(file),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 160),
                buildBottomRow(
                  imageCount: imageCount,
                  fileCount: fileCount,
                  onPickImageFromCamera: () => pickImageFromCamera(
                    picker: _picker,
                    attachFile: _attachFile,
                    setLoading: (loading) =>
                        setState(() => _isLoading = loading),
                  ),
                  onPickImageFromGallery: () => pickImageFromGallery(
                    picker: _picker,
                    attachFile: _attachFile,
                    setLoading: (loading) =>
                        setState(() => _isLoading = loading),
                  ),
                  onAttachDocument: () =>
                      attachDocument(attachFile: _attachFile),
                  onCreateTask: () => createTask(
                    context: context,
                    taskNameController: taskNameController,
                    projectController: _projectController,
                    fleatherController: _controller,
                    savedProjects: savedProjects,
                    storage: _storage,
                  ),
                ),
              ],
            ),
          ),
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
          child:
              Image(image: image, width: 200, height: 200, fit: BoxFit.cover),
        );
      }
    }
    return defaultFleatherEmbedBuilder(context, node);
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
}

class ForceNewlineForInsertsAroundInlineImageRule extends InsertRule {
  @override
  Delta? apply(Delta document, int index, Object data) {
    if (data is! String) return null;
    final iter = DeltaIterator(document);
    final previous = iter.skip(index);
    final target = iter.next();
    final cursorBeforeInlineEmbed = _isInlineImage(target.data);
    final cursorAfterInlineEmbed =
        previous != null && _isInlineImage(previous.data);

    if (cursorBeforeInlineEmbed || cursorAfterInlineEmbed) {
      final delta = Delta()..retain(index);
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
