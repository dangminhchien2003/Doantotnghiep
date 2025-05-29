import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Login.dart';

class Onbroading extends StatelessWidget {
  const Onbroading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Chiếm toàn bộ chiều rộng
        height: double.infinity, // Chiếm toàn bộ chiều cao
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              // Color(0xFFFFCA28),
              // Color(0xFFFFD54F),
              // Color(0xFFFFF9C4),
              const Color(0xFF0089FF),
              const Color(0xFF289CDD),
              const Color(0xFF5CCCFF),
            ],
            stops: [-0.1908, 0.9109, 1.2397],
            transform: const GradientRotation(115 * 3.1415926535897932 / 180),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 150),
                Image.asset('assets/images/Frame.png'),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chào mừng đến với',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Ứng dụng đặt lịch chăm sóc thú cưng',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Get.to(() => const Login());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Màu nền nút
                            padding: EdgeInsets.symmetric(
                                horizontal: 145, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Đăng Nhập',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
