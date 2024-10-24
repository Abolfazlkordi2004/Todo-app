import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todo_app/class/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';

class OtpServices {
  Future<void> sendVerificationSMS(
      BuildContext context, String verificationCode, String number) async {
    var url = Uri.parse(
        'https://console.melipayamak.com/api/send/advanced/a18df6a649884f06a0b676cdb4190e03');

    // داده‌هایی که باید به سرور ارسال شوند
    Map<String, dynamic> data = {
      'from': '9850002710011083',
      'to':'989030494718',
      'text': 'کاربر گرامی کد تایید شما $verificationCode می باشد ',
       
    };

    // ارسال درخواست POST
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // بررسی وضعیت پاسخ
      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text('پیامک با موفقیت ارسال شد'),
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          showErrordialog(context, 'خطا در ارسال پیامک ');
          print(response.statusCode);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showErrordialog(context, 'خطا:$e');
      }
    }
  }

  // Future<void> resendVerificationSMS(
  //     BuildContext context, String verificationCode, String number) async {
  //   var url = Uri.parse(
  //       'https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber');

  //   Map<String, String> data = {
  //     'username': 'your_username',
  //     'password': 'your_password',
  //     'to': number,
  //     'text': 'کد تایید شما: $verificationCode',
  //     'bodyId': '',
  //   };

  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //       body: data,
  //     );

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Directionality(
  //             textDirection: TextDirection.rtl,
  //             child: Text('پیامک با موفقیت ارسال شد'),
  //           ),
  //         ),
  //       );

  //       // ignore: use_build_context_synchronously
  //       Future<void> resendVerificationSMS(
  //           String verificationCode, String number) async {
  //         var url = Uri.parse(
  //             'https://rest.payamak-panel.com/api/SendSMS/BaseServiceNumber');

  //         Map<String, String> data = {
  //           'username': 'your_username',
  //           'password': 'your_password',
  //           'to': number,
  //           'text': 'کد تایید شما: $verificationCode',
  //           'bodyId': '',
  //         };

  //         try {
  //           var response = await http.post(
  //             url,
  //             headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //             body: data,
  //           );

  //           if (response.statusCode == 200) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                 content: Directionality(
  //                   textDirection: TextDirection.rtl,
  //                   child: Text('پیامک با موفقیت ارسال شد'),
  //                 ),
  //               ),
  //             );

  //             // ignore: use_build_context_synchronously
  //             Navigator.of(context).pushNamed(verfiyPhonenumberRoute);
  //           } else {
  //             // ignore: use_build_context_synchronously
  //             showErrordialog(context, 'خطا در ارسال پیامک');
  //           }
  //         } catch (e) {
  //           // ignore: use_build_context_synchronously
  //           showErrordialog(context, 'خطای: $e');
  //         }
  //       }
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       showErrordialog(context, 'خطا در ارسال پیامک');
  //     }
  //   } catch (e) {
  //     // ignore: use_build_context_synchronously
  //     showErrordialog(context, 'خطای: $e');
  //   }
  // }

  static String generateVerificationCode() {
    final random = Random();
    String otp = (random.nextInt(900000) + 100000).toString();
    Authentication().otp = int.parse(otp);
    return (otp);
  }
}
