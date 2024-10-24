import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/class/user_info.dart' as userinfo;
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_bloc.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_bloc.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_state.dart';
import 'package:todo_app/theme/theme_notifer.dart';
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'package:todo_app/utilities.dart/dialogs/logout_dialog.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/task_list_view.dart';
import '../helper/Function/get_username.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TaskServices _taskServices;
  String? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _taskServices = TaskServices();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _taskServices.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    await loadUserInfo();
    setState(() {
      user = userinfo.UserInfo().userName;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'لطفا صبر نمایید ');
        } else if (state is TaskLoadedState) {
          TaskListView(tasks: state.tasks);
        } else if (state is RegisteringState) {
          Navigator.of(context).pushNamed(registerRoute);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            Responsive().init(constraints: constraints);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'اهداف من',
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
                  ),
                ],
              ),
              drawer: _buildDrawer(context),
              body: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoadedState) {
                    return TaskListView(tasks: state.tasks);
                  } else if (state is TaskErrorState) {
                    showErrordialog(context, state.message);
                    return const SizedBox();
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          Image.asset('assets/icons/iconTask.png'),
                          const Text('هیچ کاری در دسترس نیست')
                        ],
                      ),
                    );
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
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
                  FloatingActionButtonLocation.endFloat,
            );
          },
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(padding: EdgeInsets.all(1 * Responsive().widthConfige)),
          SizedBox(
            child: DrawerHeader(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    height: 80,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, registerRoute);
                      },
                      label: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  heightSizedBox(1),
                  isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          user != null && user!.isNotEmpty
                              ? user!
                              : 'کاربر ناشناس',
                          style: TextStyle(
                            fontSize: 2.0 * Responsive().textConfige,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              'حساب کاربری',
              style: TextStyle(fontSize: 2.0 * Responsive().textConfige),
            ),
            onTap: () {
              Navigator.pushNamed(context, profileRoute);
            },
          ),
          heightSizedBox(1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              'خروج',
              style: TextStyle(fontSize: 2.0 * Responsive().textConfige),
            ),
            onTap: () async {
              final result = await showLogOutDialog(context);
              if (result) {
                if (context.mounted) {
                  context.read<AuthBloc>().add(const LogoutEvent());
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
              } else {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
