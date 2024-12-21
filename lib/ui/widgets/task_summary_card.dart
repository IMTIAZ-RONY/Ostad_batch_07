import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  final String title;
  final int count;
  const TaskSummaryCard({
    super.key,
    required this.title, required this.count,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      color:Colors.cyanAccent ,
      elevation: 0,
      child:SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start ,
            children: [
              Text("$count",style:textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w600 ) ,),
              const SizedBox(height:8 ,),
              FittedBox(child: Text(title,style:textTheme.titleMedium?.copyWith(color:Colors.grey  ) ,)),
            ],
          ),
        ),
      ) ,
    );
  }
}