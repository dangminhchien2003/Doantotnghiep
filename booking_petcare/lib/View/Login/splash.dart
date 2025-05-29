// booking_petcare/View/Login/Splash.dart
import 'package:booking_petcare/Controller/Login/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final splashController = Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: double.infinity, // Chiếm toàn bộ chiều rộng
        height: double.infinity, // Chiếm toàn bộ chiều cao
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0089FF),
              const Color(0xFF289CDD),
              const Color(0xFF5CCCFF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/logopet1.svg',
                width: 120,
                height: 120,
              ),
              Transform.translate(
                offset: const Offset(2, 0),
                child: Lottie.asset(
                  'assets/json/loading1.json',
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
