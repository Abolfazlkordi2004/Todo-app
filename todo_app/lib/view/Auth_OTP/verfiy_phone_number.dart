import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_bloc.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:todo_app/utilities.dart/dialogs/empty_create_view_dialog.dart';

class VerfiyPhonenumber extends StatefulWidget {
  final String verificationCode;
  final String number;

  const VerfiyPhonenumber(
      {super.key, required this.verificationCode, required this.number});

  @override
  State<VerfiyPhonenumber> createState() => _VerfiyPhonenumberState();
}

class _VerfiyPhonenumberState extends State<VerfiyPhonenumber> {
  final TextEditingController _verificationCodeController =
      TextEditingController();

  void _verifyCode() {
    if (_verificationCodeController.text.isEmpty) {
      showEmptyTextDialog(context, 'لطفا کد تایید را وارد کنید');
      return;
    }

    if (_verificationCodeController.text == widget.verificationCode) {
      context.read<AuthBloc>().add(const HomeEvent());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('کد نادرست است'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: 'لطفا صبر کنید');
        } else if (state is LoggedInState) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        } else if (state is RegisteringState) {
          Navigator.of(context).pushReplacementNamed(registerRoute);
        } else if (state is HomeState) {
          Navigator.of(context).pushReplacementNamed(homeRoute);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  heightSizedBox(30),
                  const Text(
                    'کد ارسال شده به شماره همراه خود را وارد کنید ',
                    style: TextStyle(fontSize: 18),
                  ),
                  heightSizedBox(10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'کد تایید را وارد کنید '),
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  heightSizedBox(5),
                  SizedBox(
                    width: 35 * Responsive().widthConfige,
                    height: 5 * Responsive().heightConfige,
                    child: ElevatedButton(
                      onPressed: _verifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تایید',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  heightSizedBox(5),
                  TextButton(
                    onPressed: () async {
                      context.read<AuthBloc>().add(
                            ResendOTPEvent(
                              context: context,
                              oTP: widget.verificationCode,
                              phoneNumber: widget.number,
                            ),
                          );
                      print(widget.verificationCode);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text('کد تأیید مجدداً ارسال شد'),
                          ),
                        ),
                      );
                    },
                    child: const Text('هنوز کد تایید را دریافت نکرده اید؟'),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const ChangePhoneNumberEvent());
                    },
                    child: const Text('تغییر شماره موبایل'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(registerRoute);
                    },
                    child: const Text('برگشت'),
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
