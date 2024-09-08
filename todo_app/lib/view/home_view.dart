import 'package:flutter/material.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/dialogs/error-dialog.dart';
import 'package:todo_app/dialogs/logout_dialog.dart';
import 'package:todo_app/services/auth/auth_exception.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/view/task_list_view.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  // late TextEditingController _searchBox;
  late TaskServices _taskServices;
  int _selectedIndex = 0;

  @override
  void initState() {
    _taskServices = TaskServices();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _taskServices
            .addTasks(['task 1', 'task 2', 'task 3', 'task 4', 'task 5']);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _taskServices.dispose();
    super.dispose();
  }

  Future<void> _onItemTapped(int index) async {
    if (!mounted) return;

    switch (index) {
      case 0:
        try {
          bool shouldLogout = await showLogOutDialog(context);
          if (shouldLogout) {
            await AuthService.firebase().logOut();
            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              loginRoute,
              (route) => false,
            );
          }
        } on GenericAuthExceptions {
          if (!mounted) return;
          await showErrordialog(context, 'Unknown error');
        }
        break;

      case 1:
        Navigator.of(context).pushNamed(profileRoute);
        break;

      default:
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _taskServices.taskStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const LinearProgressIndicator();
            case ConnectionState.active:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('You do not have any tasks'),
                );
              } else {
                return TaskListView(tasks: snapshot.data!);
              }
            default:
              return const LinearProgressIndicator();
          }
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey.shade600,
        iconSize: 28,
        selectedFontSize: 15,
        unselectedFontSize: 13,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),

      // FloatingActionButton for adding a new task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createTaskRoute);
        },
        backgroundColor: Colors.blue.shade200,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
