import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<DateTime?> selectStartDate(BuildContext context, DateTime? initialDate) async {
  DateTime now = DateTime.now();
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: DateTime(now.year - 50),
    lastDate: DateTime(now.year + 50),
    helpText: 'Select start date.',
    initialDatePickerMode: DatePickerMode.day,
    fieldHintText: 'MM/DD/YYYY',
    fieldLabelText: 'Enter your 1st date.',
  );
}

Future<TimeOfDay?> selectStartTime(BuildContext context, TimeOfDay? initialTime) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    helpText: "Select start time.",
  );
}

Future<DateTime?> selectEndDate(BuildContext context, DateTime? initialDate) async {
  DateTime now = DateTime.now();
  return await showDatePicker(
    context: context,
    initialDate: initialDate ?? now,
    firstDate: DateTime(now.year - 50),
    lastDate: DateTime(now.year + 50),
    helpText: 'Select end date.',
    initialDatePickerMode: DatePickerMode.day,
    fieldHintText: 'MM/DD/YYYY',
    fieldLabelText: 'Enter your 2nd date.',
  );
}

Future<TimeOfDay?> selectEndTime(BuildContext context, TimeOfDay? initialTime) async {
  return await showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
    helpText: "Select end time.",
  );
}

String formatDateTime(DateTime? date, TimeOfDay? time) {
  if (date == null) return 'Select Date';
  if (time == null) {
    return DateFormat('EEE, MMM d, y').format(date);
  } else {
    final dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return DateFormat('EEE, MMM d, y - h:mm a').format(dateTime);
  }
}