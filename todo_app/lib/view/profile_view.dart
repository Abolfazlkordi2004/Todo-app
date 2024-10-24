import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/user_info.dart' as userinfo;
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/Function/get_username.dart';
import 'package:todo_app/helper/space.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? user;
  String? phoneNumber;
  String? password;
  bool isLoading = true;
  bool passwordVisible = false;

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Future<void> _loadUserInfo() async {
    await loadUserInfo();
    setState(() {
      user = userinfo.UserInfo().userName;
      password = userinfo.UserInfo().password;
      phoneNumber = userinfo.UserInfo().phoneNumber;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = AuthService.firebase().currentUser;
    // final userEmail = user?.email ?? 'کاربری یافت نشد ';
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
                      user != null && user!.isNotEmpty ? user! : ' ',
                      style: TextStyle(
                        fontSize: 2.0 * Responsive().textConfige,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  heightSizedBox(5),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'شماره همراه',
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
                        const Icon(Icons.phone),
                        widthSizedBox(1),
                        Text(
                          phoneNumber != null && phoneNumber!.isNotEmpty
                              ? phoneNumber!
                              : '',
                        ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.lock),
                        widthSizedBox(1),
                        Text(
                          password != null && password!.isNotEmpty
                              ? password!
                              : '',
                        ),
                        widthSizedBox(57),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          icon: passwordVisible
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        )
                      ],
                    ),
                  ),
                  heightSizedBox(2),
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
