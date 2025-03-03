// lib/widgets/task_widgets.dart
//import 'package:dotted_border/dotted_border.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

Widget buildAddProject({
  required TextEditingController projectController,
  required FocusNode projectFocusNode,
  required List<String> filteredProjects,
  required bool showProjectSuggestions,
  required bool showNoProjectMessage,
  required VoidCallback onCreateProject,
  required Function(String) onSelectSuggestion,
  required Function(String) onProjectChanged,
  required BuildContext context,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: projectController,
        focusNode: projectFocusNode,
        onChanged:onProjectChanged ,
        decoration: const InputDecoration(
          hintText: '+ Add Project',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
      if (showProjectSuggestions)
        Column(
          children: [
            if (showNoProjectMessage)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No project name here, please add.",
                  style: TextStyle(backgroundColor: Colors.white54),
                ),
              ),
            if (!showNoProjectMessage && filteredProjects.isNotEmpty)
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
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
                      onTap: () => onSelectSuggestion(filteredProjects[index]),
                    );
                  },
                ),
              ),
            if (filteredProjects.isEmpty && projectController.text.isNotEmpty)
              TextButton(
                onPressed: onCreateProject,
                child: const Text('Create project name'),
              ),
          ],
        ),
    ],
  );
}

Widget buildDescriptionField({
  required FleatherController? controller,
  required FocusNode editorFocusNode,
  required GlobalKey<EditorState> editorKey,
  required bool isDescriptionFocused,
  required Widget Function(BuildContext, EmbedNode) embedBuilder,
  required Function(bool) onFocusChange,
}) {
  return Focus(
    onFocusChange: onFocusChange,
    child: GestureDetector(
      onTap: () {
        editorFocusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!editorFocusNode.hasFocus)
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          if (!editorFocusNode.hasFocus) const SizedBox(height: 2),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (editorFocusNode.hasFocus && isDescriptionFocused)
                  FleatherToolbar.basic(controller: controller!, editorKey: editorKey),
                FleatherEditor(
                  controller: controller!,
                  focusNode: editorFocusNode,
                  editorKey: editorKey,
                  padding: const EdgeInsets.all(2),
                  embedBuilder: embedBuilder,
                  minHeight: 50,
                  maxHeight: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildBottomRow({
  required int imageCount,
  required int fileCount,
  required VoidCallback onPickImageFromCamera,
  required VoidCallback onPickImageFromGallery,
  required VoidCallback onAttachDocument,
  required VoidCallback onCreateTask,
}) {
  return Row(
    children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: onPickImageFromCamera,
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: onPickImageFromGallery,
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
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: onAttachDocument,
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
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.group_add),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      TextButton(
        onPressed: onCreateTask,
        child: const Text('Create'),
      ),
    ],
  );
}