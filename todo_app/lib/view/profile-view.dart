import 'package:flutter/material.dart';

class Profileview extends StatefulWidget {
  const Profileview({super.key});

  @override
  State<Profileview> createState() => _Profileview();
}

class _Profileview extends State<Profileview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Column(

          children: [
            SizedBox(height: 150,),
            Icon(Icons.person,),
            SizedBox(height: 20,),
            Text('UserName'),
            SizedBox(height: 20,),
            Text('Email'),
            SizedBox(height: 20,),
            Text('Password'),
          ],
        ),
      ),
    );
  }
}
