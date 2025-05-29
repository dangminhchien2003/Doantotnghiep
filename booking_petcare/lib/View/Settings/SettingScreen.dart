import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/View/Language/Language.dart';
import 'package:booking_petcare/View/Pets/Pets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title:
            Text('general_settings'.tr, style: TextStyle(color: Colors.white)),
        // centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.notifications, color: Colors.blue),
                    title: Text('notification'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.toNamed(Routes.notification);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),

            // Thẻ
            Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.message, color: Colors.blue),
                    title: Text('message'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.to(() => Pets());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),

            // Thẻ ngôn ngữ
            Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: Colors.blue),
                    title: Text('language'.tr),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.to(() => Language());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
