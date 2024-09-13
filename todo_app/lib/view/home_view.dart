import 'package:flutter/material.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/dialogs/error_dialog.dart';
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
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
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
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, loginRoute);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<List<String>>>(
        stream: _taskServices.taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          } else if (snapshot.hasError) {
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
                  const Text('No tasks available.')
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
