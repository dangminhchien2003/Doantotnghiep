import 'package:booking_petcare/Controller/Login/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Changepassword extends StatelessWidget {
  const Changepassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Logincontroller());
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Đổi mật khẩu', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity, // Full width
        height: double.infinity, // Full height
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
                          'Tạo mật khẩu mới',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0089FF),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Mật khẩu của bạn phải dài ít nhất 6 ký tự, chứa ít nhất một chữ cái và 1 số.',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 39),
                        Text(
                          'Mật khẩu cũ',
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
                            obscureText: controller.isHidePasswordOld.value,
                            controller: controller.textPasswordOld,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu cũ',
                              prefixIcon: Icon(Icons.shield_outlined),
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHidePasswordOld.value =
                                      !controller.isHidePasswordOld.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordOld.value
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
                          'Mật khẩu mới',
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
                            obscureText: controller.isHidePasswordNew.value,
                            controller: controller.textPasswordNew,
                            onChanged: (value) {
                              controller.validatePassword(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu mới',
                              prefixIcon: Icon(Icons.shield_outlined),
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHidePasswordNew.value =
                                      !controller.isHidePasswordNew.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordNew.value
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
                        Obx(() => controller.passwordError.value.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 4, left: 4),
                                child: Text(
                                  controller.passwordError.value,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                              )
                            : SizedBox.shrink()),
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
                            obscureText: controller.isHidePasswordConfirm.value,
                            controller: controller.textPasswordConfirm,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Xác nhận mật khẩu',
                              prefixIcon: Icon(Icons.shield_outlined),
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(189, 189, 189, 1)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: () {
                                  controller.isHidePasswordConfirm.value =
                                      !controller.isHidePasswordConfirm.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                      controller.isHidePasswordConfirm.value
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
                          onPressed: controller.isForgotPasswordLoading.value
                              ? null
                              : () => controller.changePassword(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF0089FF), // Màu nền nút
                            padding: EdgeInsets.symmetric(
                                horizontal: 139, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Đổi mật khẩu',
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
