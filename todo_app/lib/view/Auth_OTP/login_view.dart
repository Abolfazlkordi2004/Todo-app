import 'package:flutter/material.dart';
import 'package:todo_app/Error/auth_exception.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/class/authentication.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/helper/space.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_bloc.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_event.dart';
import 'package:todo_app/services/bloc/Auth_bloc/auth_state.dart';
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginView();
}

class _LoginView extends State<LoginView> {
  late TextEditingController _userName;
  late TextEditingController _password;
  bool _passwordVisible = false;

  @override
  void initState() {
    _userName = TextEditingController();
    _password = TextEditingController();
    super.initState();
 
  }

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  void _loginUser() {
    try {
      if (_userName.text.isEmpty || _password.text.isEmpty) {
        throw FillAllTextFiledsAuthExceptions();
      }
      if (_password.text.length < 6) {
        throw WrongPasswordAuthExceptions();
      }
      if (Authentication().isRegistered == false) {
        throw UserShouldRegisterException();
      }

   
      context.read<AuthBloc>().add(
            LoginEvent(name: _userName.text, password: _password.text),
          );
     
    } on FillAllTextFiledsAuthExceptions {
      showErrordialog(context, 'لطفا همه فیلدها را پر کنید.');
    } on WrongPasswordAuthExceptions {
      showErrordialog(context, 'رمز عبور اشتباه است یا کمتر از ۶ کاراکتر است.');
    } on UserShouldRegisterException {
      showErrordialog(context, 'لطفا ابتدا ثبت نام کنید');
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
            if (state is LoggedInState) {
              Navigator.of(context).pushNamed(homeRoute);
            } else if (state is HomeState) {
              Navigator.of(context).pushReplacementNamed(homeRoute);
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
                          'ورود',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 2.5 * Responsive().textConfige,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        heightSizedBox(5),
                        _buildTextField(
                            _userName, 'نام کاربری', TextInputType.name),
                        heightSizedBox(3),
                        _buildPasswordField(),
                        heightSizedBox(5),
                        SizedBox(
                          height: 5 * Responsive().heightConfige,
                          width: 90 * Responsive().widthConfige,
                          child: ElevatedButton(
                            onPressed: _loginUser,
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
                            child: const Text('ورود',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        heightSizedBox(5),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (route) => false,
                            );
                          },
                          child: const Text('ایا حساب کاربری ندارید؟ ثبت نام'),
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
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: _password,
        obscureText: !_passwordVisible,
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
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}
