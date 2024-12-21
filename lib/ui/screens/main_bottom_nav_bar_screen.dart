import 'package:flutter/material.dart';
import 'package:ostad_batch_07/ui/screens/add_new_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/cancelled_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/completed_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/new_task_screen.dart';
import 'package:ostad_batch_07/ui/screens/progress_task_screen.dart';
import '../widgets/tm_app_bar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({super.key});

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _selectedScreen = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar:TMAppBar(),

      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(
                  Icons.new_label,
                  size: 20,
                ),
                label: "New"),
            NavigationDestination(
                icon: Icon(
                  Icons.check_box,
                  size: 20,
                ),
                label: "Completed"),
            NavigationDestination(
                icon: Icon(
                  Icons.close,
                  size: 20,
                ),
                label: "Cancelled"),
            NavigationDestination(
                icon: Icon(
                  Icons.access_time_outlined,
                  size: 20,
                ),
                label: "InProgress"),
          ]),
      body: _selectedScreen[_selectedIndex],
    );
  }


}


