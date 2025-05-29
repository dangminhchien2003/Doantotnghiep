import 'package:booking_petcare/Controller/Login/LoginController.dart';
import 'package:booking_petcare/Services/Auth.dart';
import 'package:booking_petcare/View/Login/Signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Logincontroller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_outlined));
        }),
      ),
      body: Container(
        width: double.infinity, // Chiếm toàn bộ chiều rộng
        height: double.infinity, // Chiếm toàn bộ chiều cao
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Obx(
              () => Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chào Mừng Quay Trở Lại!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              "Bạn chưa có tài khoản?",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const Signup());
                              },
                              child: Text(
                                'Đăng ký ngay',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 39),
                        Text(
                          'account'.tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(228, 230, 236, 1)),
                          ),
                          child: TextField(
                            controller: controller.textEmail,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: 'Tài khoản',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Mật khẩu',
                          style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(228, 230, 236, 1)),
                          ),
                          child: TextField(
                            obscureText: controller.isHidePassword.value,
                            controller: controller.textPass,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHidePassword.value =
                                      !controller.isHidePassword.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePassword.value
                                          ? 'assets/icons/hidden.svg'
                                          : 'assets/icons/eye_login.svg',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(() => const ForgotPassword());
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await Auth.login(
                                email: controller.textEmail.text,
                                matkhau: controller.textPass.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Màu nền nút
                            padding: EdgeInsets.symmetric(
                                horizontal: 146, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Đăng Nhập',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
