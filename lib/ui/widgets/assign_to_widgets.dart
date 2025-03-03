import 'package:flutter/material.dart';
import '../const/constants.dart';
import '../const/strings.dart';
import '../const/text_styles.dart';

class AssignedToWidget extends StatelessWidget {
  const AssignedToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: primaryColor,
          child: Text('IR', style: TextStyle(color: whiteColor)),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(assignedTo, style: assignedToStyle),
            Text('Imtiaz Rony', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}