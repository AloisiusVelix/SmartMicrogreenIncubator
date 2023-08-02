import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF208D20),
        body: Stack(
          children: <Widget> [
            Center(
              child: Container(
                width: Get.width * 0.5,
                height: Get.height * 0.5,
                child: Image.asset('assets/images/logo_splash.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset('assets/images/developed_by.png')
            )
          ]
        ),
      ),
    );
  }
}