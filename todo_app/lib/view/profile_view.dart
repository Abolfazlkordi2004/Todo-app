import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/username.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/auth/auth_service.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser;
    final userEmail = user?.email ?? 'کاربری یافت نشد ';
    final showUserName = userName;

    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.all(4 * Responsive().widthConfige),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  heightSizedBox(10),
                  Center(
                    child: Image.asset(
                      'assets/images/profile.png',
                      width: 20 * Responsive().widthConfige,
                      height: 20 * Responsive().heightConfige,
                    ),
                  ),
                  heightSizedBox(2),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  heightSizedBox(2),
                  Center(
                    child: Text(
                      showUserName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 2.0 * Responsive().textConfige,
                      ),
                    ),
                  ),
                  heightSizedBox(5),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'ایمیل',
                      style: TextStyle(
                        fontSize: 1.6 * Responsive().textConfige,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  heightSizedBox(1),
                  Container(
                    height: 6 * Responsive().heightConfige,
                    padding: EdgeInsets.fromLTRB(
                        1 * Responsive().widthConfige, 0, 0, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.email),
                        widthSizedBox(1),
                        Text(userEmail),
                      ],
                    ),
                  ),
                  heightSizedBox(3),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'رمز عبور',
                      style: TextStyle(
                        fontSize: 1.6 * Responsive().textConfige,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  heightSizedBox(1),
                  Container(
                    height: 6.0 * Responsive().heightConfige,
                    padding: EdgeInsets.fromLTRB(
                        1 * Responsive().widthConfige, 0, 0, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock),
                        widthSizedBox(1),
                        const Text('************'),
                      ],
                    ),
                  ),
                  heightSizedBox(2),

                  // Back to Home Button
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(homeRoute);
                      },
                      child: const Text(
                        'برگشت',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
