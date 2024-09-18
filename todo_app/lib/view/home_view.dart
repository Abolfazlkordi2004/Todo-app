import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/class/theme_notifire.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/username.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/services/cloud/firebase_cloud_storage.dart';
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'package:todo_app/utilities.dart/dialogs/logout_dialog.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/task_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late FirebaseCloudStorage _taskServices;

  String? get userId => AuthService.firebase().currentUser?.id;

  @override
  void initState() {
    super.initState();
    _taskServices = FirebaseCloudStorage();
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: Text('User is not logged in.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Task',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
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
                  const SizedBox(height: 10),
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
              leading: const Icon(Icons.person, color: Colors.white),
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, profileRoute);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onTap: () async {
                final result = await showLogOutDialog(context);
                if (result) {
                  // Safely handle navigation
                  if (mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                }
              },
            ),
            IconButton(
              onPressed: () {
                ThemeNotifier themeNotifier =
                    Provider.of<ThemeNotifier>(context, listen: false);
                if (themeNotifier.themeMode == ThemeMode.light) {
                  themeNotifier.setTheme(ThemeMode.dark);
                } else {
                  themeNotifier.setTheme(ThemeMode.light);
                }
              },
              icon: const Icon(Icons.brightness_6),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _taskServices.allTasks(ownerUserId: userId!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            showErrordialog(context, 'ERROR: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/iconTask.png'),
                  const SizedBox(height: 10),
                  const Text(
                    'No tasks available.',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            );
          }

          final tasks = snapshot.data!.toList();
          return TaskListView(tasks: tasks);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateTaskView(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
