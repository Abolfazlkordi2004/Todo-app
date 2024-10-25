import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Error/auth_exception.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/loading/loading_screen.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/class/otp_service.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_bloc.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'dart:developer' as devlog;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late TextEditingController _userName;
  late TextEditingController _phoneNumber;
  late TextEditingController _password;
  bool _passwordVisible = false;

  @override
  void initState() {
    _userName = TextEditingController();
    _phoneNumber = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
    _phoneNumber.dispose();
    _password.dispose();
    super.dispose();
  }

  void _registerUser() async {
    try {
      if (_userName.text.isEmpty ||
          _phoneNumber.text.isEmpty ||
          _password.text.isEmpty) {
        throw FillAllTextFiledsAuthExceptions();
      }
      if (_password.text.length < 6) {
        throw WrongPasswordAuthExceptions();
      }
      if (!_phoneNumber.text.startsWith('09') ||
          _phoneNumber.text.length != 11) {
        throw WrongNumberAuthExceptions();
      }

      context.read<AuthBloc>().add(
            RegisterEvent(
              name: _userName.text,
              number: _phoneNumber.text,
              password: _password.text,
            ),
          );

      String code = OtpServices.generateVerificationCode();
      OtpServices().sendVerificationSMS(context, code, _phoneNumber.text);
      devlog.log(code);
    } on FillAllTextFiledsAuthExceptions {
      showErrordialog(context, 'لطفا همه فیلدها را پر کنید.');
    } on WrongPasswordAuthExceptions {
      showErrordialog(context, 'رمز عبور باید حداقل ۶ کاراکتر باشد.');
    } on WrongNumberAuthExceptions {
      showErrordialog(context, 'شماره موبایل وارد شده معتبر نیست.');
    } catch (e) {
      showErrordialog(context, 'خطای نامشخص: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Responsive().init(constraints: constraints);
        return BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isLoading) {
              LoadingScreen().show(context: context, text: 'لطفا صبر کنید');
            } else if (state is ConfirmNumberState) {
              Navigator.of(context).pushNamed(verfiyPhonenumberRoute);
            } else if (state is HomeState) {
              Navigator.of(context).pushNamed(homeRoute);
            } else {
              LoadingScreen().hide();
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(4 * Responsive().widthConfige),
                  child: Center(
                    child: Column(
                      children: [
                        heightSizedBox(10),
                        Text(
                          'ثبت نام',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 2.5 * Responsive().textConfige,
                              color: Colors.blue.shade900),
                        ),
                        heightSizedBox(5),
                        _buildTextField(
                            _userName, 'نام کاربری', TextInputType.name),
                        heightSizedBox(3),
                        _buildTextField(
                            _phoneNumber, 'شماره همراه', TextInputType.number),
                        heightSizedBox(3),
                        _buildPasswordField(),
                        heightSizedBox(5),
                        SizedBox(
                          height: 5.5 * Responsive().heightConfige,
                          width: 90 * Responsive().widthConfige,
                          child: ElevatedButton(
                            onPressed: () async {
                              _registerUser();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 2 * Responsive().textConfige,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'ثبت نام',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        heightSizedBox(2),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginRoute,
                              (route) => false,
                            );
                          },
                          child: const Text("ایا حساب کاربری دارید؟ ورود"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      TextInputType keyboardType) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1.5),
          ),
        ),
        autocorrect: false,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: _password,
        decoration: InputDecoration(
          labelText: 'رمز عبور',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1.5),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        autocorrect: false,
        keyboardType: TextInputType.visiblePassword,
        obscureText: !_passwordVisible,
      ),
    );
  }
}
