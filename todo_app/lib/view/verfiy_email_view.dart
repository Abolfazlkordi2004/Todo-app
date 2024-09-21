import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/auth/auth_service.dart';

class VerfiyEmailView extends StatefulWidget {
  const VerfiyEmailView({super.key});

  @override
  State<VerfiyEmailView> createState() => _VerfiyEmailViewState();
}

class _VerfiyEmailViewState extends State<VerfiyEmailView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Verfiy Email'),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(1.6 * Responsive().widthConfige),
              child: Column(
                children: [
                  Text(
                    "we ve' sent you an email verification.please open it to verify your account",
                    style: TextStyle(
                      fontSize: 1.5 * Responsive().textConfige,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  heightSizedBox(10),
                  Text(
                    "If you haven't received a verification email yet, press the button below",
                    style: TextStyle(
                      fontSize: 1.5 * Responsive().textConfige,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  heightSizedBox(10),
                  SizedBox(
                    width: 25 * Responsive().widthConfige,
                    height: 5.5 * Responsive().heightConfige,
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.firebase().sendEmailVerification();
                      },
                      style: ElevatedButton.styleFrom(),
                      child: const Text('send Email verfication'),
                    ),
                  ),
                  heightSizedBox(20),
                  SizedBox(
                    width: 25 * Responsive().widthConfige,
                    height: 5.5 * Responsive().heightConfige,
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthService.firebase().logOut();
                      },
                      child: const Text('restart'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
