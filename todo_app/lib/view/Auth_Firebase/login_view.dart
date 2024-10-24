// import 'package:flutter/material.dart';
// import 'package:todo_app/Responsive/responsive.dart';
// import 'package:todo_app/constant/routes.dart';
// import 'package:todo_app/helper/space.dart';
// import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
// import 'package:todo_app/constant/username.dart';
// import 'package:todo_app/services/auth/auth_exception.dart';
// import 'package:todo_app/services/auth/auth_service.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginView();
// }

// class _LoginView extends State<LoginView> {
//   late TextEditingController _userName;
//   late TextEditingController _email;
//   late TextEditingController _password;

//   bool _passwordVisible = false;

//   @override
//   void initState() {
//     _userName = TextEditingController();
//     _email = TextEditingController();
//     _password = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _userName.dispose();
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         Responsive().init(constraints: constraints);
//         return Scaffold(
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.all(4 * Responsive().widthConfige),
//               child: Center(
//                 child: Column(
//                   children: [
//                     heightSizedBox(10),
//                     Text(
//                       'ورود',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 2.5 * Responsive().textConfige,
//                           color: Colors.blue.shade900),
//                     ),
//                     heightSizedBox(5),
                    // Directionality(
                    //   textDirection: TextDirection.rtl,
                    //   child: TextField(
                    //     controller: _userName, // Added the controller
                    //     decoration: InputDecoration(
                    //       labelText: 'نام کاربری',
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: const BorderSide(width: 1.5),
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //         borderSide: const BorderSide(width: 1.5),
                    //       ),
                    //     ),
                    //     autocorrect: false,
                    //     keyboardType: TextInputType.name,
                    //   ),
                    // ),
//                     heightSizedBox(3),
//                     Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: TextField(
//                         controller: _email, // Added the controller
//                         decoration: InputDecoration(
//                           labelText: 'ایمیل',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(width: 1.5),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(width: 1.5),
//                           ),
//                         ),
//                         autocorrect: false,
//                         keyboardType: TextInputType.number,
//                       ),
//                     ),
//                     heightSizedBox(3),
//                     Directionality(
//                       textDirection: TextDirection.rtl,
//                       child: TextField(
//                         controller: _password, // Added the controller
//                         decoration: InputDecoration(
//                           labelText: 'رمز عبور',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(width: 1.5),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: const BorderSide(width: 1.5),
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 _passwordVisible = !_passwordVisible;
//                               });
//                             },
//                             icon: Icon(
//                               _passwordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                             ),
//                           ),
//                         ),
//                         autocorrect: false,
//                         keyboardType: TextInputType.visiblePassword,
//                         obscureText: !_passwordVisible,
//                       ),
//                     ),
//                     heightSizedBox(5),
//                     SizedBox(
//                       height: 5 * Responsive().heightConfige,
//                       width: 90 * Responsive().widthConfige,
//                       child: ElevatedButton(
//                         onPressed: () async {
//                           try {
//                             var email = _email.text;
//                             var password = _password.text;
//                             userName = _userName.text;

//                             await AuthService.firebase()
//                                 .login(email: email, password: password);

//                             // ignore: use_build_context_synchronously
//                             Navigator.of(context).pushNamedAndRemoveUntil(
//                               homeRoute,
//                               (route) => true,
//                             );
//                           } on WrongPasswordAuthException {
//                             // ignore: use_build_context_synchronously
//                             showErrordialog(
//                                 context, 'رمز عبور وارد شده غلط است ');
//                           } on UserNotFoundAuthException {
//                             // ignore: use_build_context_synchronously
//                             showErrordialog(context, 'کاربر یافت نشد');
//                           } on GenericAuthExceptions {
//                             // ignore: use_build_context_synchronously
//                             showErrordialog(context, 'خطا');
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue.shade800,
//                           textStyle: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 2 * Responsive().textConfige,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: const Text(
//                           'ورود',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                     heightSizedBox(2),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pushNamedAndRemoveUntil(
//                           forgotPasswordRoute,
//                           (route) => true,
//                         );
//                       },
//                       child: const Text(
//                         "فراموشی رمز عبور",
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context).pushNamedAndRemoveUntil(
//                           registerRoute,
//                           (route) => true,
//                         );
//                       },
//                       child: const Text(
//                         "ایا حساب کاربری ندارید؟ ثبت نام ",
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
