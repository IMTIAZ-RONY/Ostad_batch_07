import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

import '../const/constants.dart';
import '../const/strings.dart';
import '../utils/date_time_utils.dart';

class DueDateWidget extends StatelessWidget {
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final DateTime? endDate;
  final TimeOfDay? endTime;
  final VoidCallback onTap;

  DueDateWidget({
    super.key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          startDate == null
              ? DottedBorder(
                  strokeWidth: 1.0,
                  color: greyColor,
                  borderType: BorderType.Circle,
                  dashPattern: const [5, 3],
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child:
                        Icon(Icons.calendar_today, size: 18, color: greyColor),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: greenColor, width: 1.2),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child:
                        Icon(Icons.calendar_today, size: 18, color: greyColor),
                  ),
                ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dueDate,
                  style: TextStyle(
                      color: startDate == null ? greyColor : Colors.black)),
              if (startDate != null)
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.3),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          formatDateTime(startDate, startTime),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatDateTime(endDate, endTime),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
