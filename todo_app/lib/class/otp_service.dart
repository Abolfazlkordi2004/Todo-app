import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todo_app/class/authentication.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utilities.dart/dialogs/error_dialog.dart';
import 'dart:developer' as devlog;

class OtpServices {
  Future<void> sendVerificationSMS(
      BuildContext context, String verificationCode, String number) async {
    var url = Uri.parse(
        'https://console.melipayamak.com/api/send/simple/a18df6a649884f06a0b676cdb4190e03');

    // داده‌هایی که باید به سرور ارسال شوند
    Map<String, dynamic> data = {
      'from': '9850002710011083',
      'to': number,
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
          print(response.statusCode);
          showErrordialog(context, 'خطا در ارسال پیامک ');
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
  //       'https://console.melipayamak.com/api/send/simple/a18df6a649884f06a0b676cdb4190e03');

  //   // داده‌هایی که باید به سرور ارسال شوند
  //   Map<String, dynamic> data = {
  //     'from': '9850002710011083',
  //     'to':number,
  //     'text': 'کاربر گرامی کد تایید شما $verificationCode می باشد ',
  //   };

  //   // ارسال درخواست POST
  //   try {
  //     var response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(data),
  //     );

  //     // بررسی وضعیت پاسخ
  //     if (response.statusCode == 200) {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Directionality(
  //               textDirection: TextDirection.rtl,
  //               child: Text('پیامک با موفقیت ارسال شد'),
  //             ),
  //           ),
  //         );
  //       }
  //     } else {
  //       if (context.mounted) {
  //         showErrordialog(context, 'خطا در ارسال پیامک ');
  //       }
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       showErrordialog(context, 'خطا:$e');
  //     }
  //   }
  // }

  static String generateVerificationCode() {
    final random = Random();
    String otp = (random.nextInt(900000) + 100000).toString();
    Authentication().otp = otp;
    return (otp);
  }
}
