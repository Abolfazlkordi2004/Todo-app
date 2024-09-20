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
    final userEmail = user?.email ?? 'No user';
    final showUserName = userName;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(4 * Responsive().widthConfige),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heightSizedBox(10),
              Center(
                child: Image.asset(
                  'assets/images/profile.png',
                  width: 1.5 * Responsive().widthConfige,
                  height: 15 * Responsive().heightConfige,
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
              // Email Section
              Text(
                'Your Email',
                style: TextStyle(
                  fontSize: 1.6 * Responsive().textConfige,
                  fontWeight: FontWeight.bold,
                ),
              ),
              heightSizedBox(0.5),
              Container(
                height: 5 * Responsive().heightConfige,
                padding: EdgeInsets.all(1.0 * Responsive().widthConfige),
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
              // Password Section (we never show the real password)
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 1.6 * Responsive().textConfige,
                  fontWeight: FontWeight.bold,
                ),
              ),
              heightSizedBox(0.5),
              Container(
                height: 5.0 * Responsive().heightConfige,
                padding: EdgeInsets.all(1.0 * Responsive().widthConfige),
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
                    'Back to home',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
