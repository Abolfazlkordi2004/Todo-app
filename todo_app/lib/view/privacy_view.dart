import 'package:flutter/material.dart';
import 'package:todo_app/Responsive/responsive.dart';
import 'package:todo_app/helper/space.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0 * Responsive().widthConfige),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                heightSizedBox(20),
                Text(
                  'حریم خصوصی',
                  style: TextStyle(
                      fontSize: 3 * Responsive().textConfige,
                      fontWeight: FontWeight.bold),
                ),
                heightSizedBox(10),
                Text(
                  'بر طبق توافقنامه های موجود در این اپلیکیشن ما متهعد میشویم که به حریم خصوصی کاربران خود احترام بگذاریم و هرگز بدون اجازه کاربر دست به افشای اطلاعات خصوصی و فردی شما نخواهیم زد مگر  , اینکه به موجب قانون توجیهی برای اینکار وجود داشته باشد و همچنین اطلاعات جمع اوری شده درباره کاربران ما از مشخصه های فردی شما فقط به منظور پاشخگویی به خودتان یا در قالب شناسنامه کاربر برای شناخت بهتر کاربرانمان استفاده می نماییم.',
                  style: TextStyle(
                    fontSize: 2 * Responsive().textConfige,
                  ),
                ),
                heightSizedBox(10),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('بازگشت'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
