import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_bloc.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_bloc.dart';
import 'package:todo_app/services/bloc/Task_bloc.dart/task_event.dart';
import 'package:todo_app/theme/theme_mode.dart';
import 'package:todo_app/theme/theme_notifer.dart';
import 'package:todo_app/view/Auth_OTP/login_view.dart';
import 'package:todo_app/view/Auth_OTP/register_view.dart';
import 'package:todo_app/view/Auth_OTP/verfiy_phone_number.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view/privacy_view.dart';
import 'package:todo_app/view/profile_view.dart';
import 'package:todo_app/view/update_task_view.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
            create: (context) =>
                TaskBloc(TaskServices())..add(const LoadTasksEvent([]))),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(const InitializeAppEvent()))
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.textLoading);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return Consumer<ThemeNotifier>(
          builder: (context, themeNotifier, child) {
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeNotifier.themeMode,
              debugShowCheckedModeBanner: false,
              home: const HomeView(),
              routes: {
                homeRoute: (context) => const HomeView(),
                createTaskRoute: (context) => CreateTaskView(
                      taskServices: TaskServices(),
                    ),
                loginRoute: (context) => const LoginView(),
                profileRoute: (context) => const ProfileView(),
                registerRoute: (context) => const RegisterView(),
                verfiyPhonenumberRoute: (context) => const VerfiyPhonenumber(
                      verificationCode: '',
                      number: '',
                    ),
                updateTaskRoute: (context) =>
                    UpdateTaskView(taskServices: TaskServices()),
                PrivacyRoute: (context) => const PrivacyView()
              },
            );
          },
        );
      },
    );
  }
}

 
// class AuthWidget extends StatelessWidget {
//   const AuthWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailverified) {
//                 return const HomeView();
//               } else {
//                 return const HomeView();
//               }
//             } else {
//               return const LoginView();
//             }
//           default:
//             return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
