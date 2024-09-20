import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/username.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/theme/theme_notifer.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Task',
              style: TextStyle(
                fontSize: 2.5 * Responsive().textConfige,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
            actions: [
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
                icon: const Icon(Icons.sunny),
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                Padding(
                    padding: EdgeInsets.all(1.0 * Responsive().widthConfige)),
                DrawerHeader(
                  child: Column(
                    children: [
                      Image.asset('assets/icons/user2.png'),
                      heightSizedBox(1),
                      Text(
                        userName,
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 2.0 * Responsive().textConfige,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(fontSize: 2.0 * Responsive().textConfige),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, profileRoute);
                  },
                ),
                heightSizedBox(1),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 2.0 * Responsive().textConfige,
                    ),
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
                      heightSizedBox(1),
                      Text(
                        'No tasks available.',
                        style:
                            TextStyle(fontSize: 1.5 * Responsive().textConfige),
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
            // backgroundColor: Colors.blue.shade800,
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
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
