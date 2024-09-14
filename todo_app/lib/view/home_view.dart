import 'package:flutter/material.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/username.dart';
import 'package:todo_app/dialogs/error_dialog.dart';
import 'package:todo_app/dialogs/logout_dialog.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/task_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TaskServices _taskServices;

  @override
  void initState() {
    super.initState();
    _taskServices = TaskServices();
  }

  @override
  void dispose() {
    _taskServices.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Task',
          style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.black12,
        child: ListView(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            DrawerHeader(
              child: Column(
                children: [
                  Image.asset('assets/icons/user2.png'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, profileRoute);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () async {
                final result = await showLogOutDialog(context);
                if (result) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamed(loginRoute);
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<List<String>>>(
        stream: _taskServices.taskStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrordialog(context, 'ERROR');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/iconTask.png',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'No tasks available.',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            );
          }
          final tasks = snapshot.data!;
          return TaskListView(tasks: tasks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTaskView(
                taskServices: _taskServices,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
