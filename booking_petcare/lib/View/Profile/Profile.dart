import 'package:booking_petcare/Controller/Profile/ProfileController.dart';
import 'package:booking_petcare/Services/Auth.dart';
import 'package:booking_petcare/View/Account/Changepassword.dart';
import 'package:booking_petcare/View/Account/PersonalInformation.dart';
import 'package:booking_petcare/View/Pets/Pets.dart';
import 'package:booking_petcare/View/Settings/SettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('individual'.tr, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        // iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thẻ thông tin người dùng
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                color: Colors.blue, // Nền màu xanh
                elevation: 3, // Bóng đổ nhẹ cho thẻ
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/image.png'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName.value,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.email.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Phần tài khoản
              Text(
                "account".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.blue),
                      title: Text('personal_information'.tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.to(() => PersonalInformation());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              // Thẻ đổi mật khẩu
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock, color: Colors.blue),
                      title: Text('change_password'.tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.to(() => Changepassword());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Phần thú cưng
              Text(
                "pet".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              // Thẻ quản lý thú cưng
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.pets, color: Colors.blue),
                      title: Text('pet_management'.tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.to(() => Pets());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Phần hệ thống
              Text(
                "system".tr,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.blue),
                      title: Text('general_settings'.tr),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Get.to(() => SettingScreen());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              // Thẻ đăng xuất
              Card(
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: Text(
                    'log_out'.tr,
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Auth.backLogin(true);
                    // HIỂN THỊ BOTTOM SHEET XÁC NHẬN
                    Get.bottomSheet(
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text(
                                  'confirm_logout_title'.tr,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Center(
                                child: Text('confirm_logout_message'.tr),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                TextButton(
                                  child: Text(
                                    'cancel'.tr,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'log_out'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                    Auth.backLogin(true);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      backgroundColor:
                          Colors.transparent, // Để bo tròn góc có hiệu lực
                      isDismissible: true, // Cho phép đóng khi chạm bên ngoài
                      enableDrag: true, // Cho phép kéo để đóng
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
