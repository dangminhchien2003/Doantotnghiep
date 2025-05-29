import 'package:booking_petcare/Controller/Dashboard/DashboardController.dart';
import 'package:booking_petcare/Controller/Notification/NotificationController.dart';
import 'package:booking_petcare/View/Appointment/AppoinmentList.dart';
import 'package:booking_petcare/View/Notification/Notification.dart'
    as my_app_notification;
import 'package:booking_petcare/View/Services/Services.dart';
import 'package:booking_petcare/View/Home/Home.dart';
import 'package:booking_petcare/View/Profile/Profile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    // Khởi tạo hoặc tìm NotificationController
    // Nếu NotificationController được put ở nơi khác, hãy dùng Get.find()
    // final notificationController = Get.find<NotificationController>();
    final notificationController =
        Get.put(NotificationController()); // Hoặc Get.find()

    // Danh sách các trang cho BottomNavigationBar
    final List<Widget> screens = [
      const Home(),
      const Services(),
      AppointmentList(), // Lịch hẹn
      const my_app_notification.Notification(),
      const Profile(),
    ];

    return Obx(() => controller.isLoading.value
        ? const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[50],
            body: Obx(() {
              if (controller.currentPageIndex.value >= 0 &&
                  controller.currentPageIndex.value < screens.length) {
                return screens[controller.currentPageIndex.value];
              }
              return screens[0]; // Mặc định về trang chủ
            }),
            bottomNavigationBar: Obx(() {
              final currentIndex = controller.currentPageIndex.value;
              // Lấy số lượng thông báo chưa đọc từ NotificationController
              final unreadCount = notificationController.notificationList
                  .where((noti) => noti.trangthai == 0)
                  .length;

              return BottomNavigationBar(
                backgroundColor: Colors.white,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                        currentIndex == 0 ? Icons.home : Icons.home_outlined),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(currentIndex == 1
                        ? Icons.business_center
                        : Icons.business_center_outlined),
                    label: 'service'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue, // Màu nền nổi bật
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10), // Độ lớn của vòng tròn
                      child: Icon(
                        Icons.event_note,
                        color: Colors.white, // Màu icon
                        size: 28, // Kích thước icon to hơn
                      ),
                    ),
                    label: 'appointment'.tr,
                  ),
                  BottomNavigationBarItem(
                    // THAY ĐỔI TAB THỨ 4 (INDEX 3)
                    icon: Stack(
                      clipBehavior:
                          Clip.none, // Để huy hiệu có thể tràn ra ngoài
                      children: [
                        Icon(currentIndex == 3
                            ? Icons.notifications_rounded // Icon khi được chọn
                            : Icons
                                .notifications_outlined), // Icon khi không được chọn
                        if (unreadCount > 0)
                          Positioned(
                            right: -5, // Điều chỉnh vị trí của huy hiệu
                            top: -5, // Điều chỉnh vị trí của huy hiệu
                            child: Container(
                              padding: EdgeInsets.all(unreadCount > 9
                                  ? 2
                                  : 3), // Điều chỉnh padding cho số có 1 hoặc 2 chữ số
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 1.5) // Thêm viền trắng cho đẹp hơn
                                  ),
                              constraints: BoxConstraints(
                                minWidth: unreadCount > 9
                                    ? 18
                                    : 16, // Kích thước tối thiểu
                                minHeight: unreadCount > 9 ? 18 : 16,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10, // Cỡ chữ của số
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    label: 'notification'
                        .tr, // Key cho localization, ví dụ: 'Thông báo'
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(currentIndex == 4
                        ? Icons.person
                        : Icons.person_outline),
                    label: 'individual'.tr,
                  ),
                ],
                currentIndex: currentIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.grey[500],
                type: BottomNavigationBarType.fixed,
                onTap: (value) {
                  // Khi nhấn vào tab thông báo (index 3), có thể bạn muốn refresh thông báo
                  // if (value == 3) {
                  //   notificationController.refreshData(); // Hoặc fetch nếu cần
                  // }
                  controller.changePage(value);
                },
                elevation: 5.0,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontSize: 12),
              );
            }),
          ));
  }
}
