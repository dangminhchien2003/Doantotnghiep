import 'package:booking_petcare/Controller/Login/LoginController.dart';
import 'package:booking_petcare/Services/Auth.dart';
import 'package:booking_petcare/View/Login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

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
                          'Đăng Ký Tài Khoản!',
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
                              "Bạn đã có tài khoản?",
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
                                Get.to(() => const Login());
                              },
                              child: Text(
                                'Đăng nhập',
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
                          'Họ và tên',
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
                            controller: controller.textUserName,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: 'Họ và tên',
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
                          'Email',
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
                              hintText: 'Email',
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
                          'Số điện thoại',
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
                            controller: controller.textPhone,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: 'Số điện thoại',
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
                          'Địa chỉ',
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
                            controller: controller.textAddress,
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              hintText: 'Địa chỉ',
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
                            obscureText: controller.isHidePasswordSignup.value,
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
                                  controller.isHidePasswordSignup.value =
                                      !controller.isHidePasswordSignup.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordSignup.value
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
                        SizedBox(height: 16),
                        Text(
                          'Xác nhận mật khẩu',
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
                            obscureText: controller.isHideRePassword.value,
                            controller: controller.textRePass,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Xác nhận mật khẩu',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHideRePassword.value =
                                      !controller.isHideRePassword.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHideRePassword.value
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
                        ElevatedButton(
                          onPressed: () async {
                            if (controller.textPass.text !=
                                controller.textRePass.text) {
                              Get.snackbar("Lỗi",
                                  "Mật khẩu và xác nhận mật khẩu không khớp",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                              return;
                            }
                            await Auth.signup(
                              tennguoidung: controller.textUserName.text,
                              email: controller.textEmail.text,
                              matkhau: controller.textPass.text,
                              sodienthoai: controller.textPhone.text,
                              diachi: controller.textAddress.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 156, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Đăng Ký',
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
