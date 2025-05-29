import 'package:booking_petcare/Component/DialogCustom.dart';
import 'package:booking_petcare/Component/EmptyList.dart';
import 'package:booking_petcare/Controller/Notification/NotificationController.dart';
import 'package:booking_petcare/Widgets/notification_detail_sheet/notification_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Notification extends StatelessWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Thông báo'.tr,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'mark_all_read'.tr,
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => DialogCustom(
                  svg: 'assets/icons/notification1.svg',
                  title: 'Đánh dấu tất cả đã đọc'.tr,
                  description: 'Tất cả các thông báo'.tr,
                  onTap: () async {
                    await controller.readAll();
                    Navigator.pop(context);
                  },
                ),
              );
            },
          )
        ],
      ),
      body: Obx(() => RefreshIndicator(
            onRefresh: () => controller.refreshData(),
            child: controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.notificationList.isEmpty
                    ? ListView(
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height * 0.5,
                            child: EmptyList(
                                title: 'no_announcements'.tr,
                                imgSrc: 'assets/icons/notification1.svg',
                                content: ''.tr),
                          ),
                        ],
                      )
                    : ListView.separated(
                        controller: controller.scrollController,
                        itemCount: controller.notificationList.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(
                            height: 1,
                            thickness: 0,
                            indent: 0,
                            endIndent: 0,
                            color: Color.fromRGBO(244, 247, 250, 1)),
                        itemBuilder: (context, index) {
                          if (index == controller.notificationList.length - 1 &&
                              controller.totalPage != controller.page) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            );
                          }
                          final currentNotification =
                              controller.notificationList[
                                  index]; // Lấy thông báo hiện tại
                          return GestureDetector(
                            onTap: () async {
                              await controller.readOnly(index: index);
                              // Hiển thị BottomSheet
                              Get.bottomSheet(
                                NotificationDetailSheet(
                                    notification: currentNotification),
                                // Tùy chọn cho bottom sheet
                                backgroundColor: Colors
                                    .transparent, // Để widget con tự quản lý màu nền và bo góc
                                isScrollControlled:
                                    true, // Quan trọng: cho phép BottomSheet có chiều cao linh động
                                enterBottomSheetDuration:
                                    const Duration(milliseconds: 250),
                                exitBottomSheetDuration:
                                    const Duration(milliseconds: 200),
                              );
                            },
                            child: Container(
                              color: controller
                                          .notificationList[index].trangthai ==
                                      0
                                  ? Color.fromRGBO(219, 236, 252, 1)
                                  : Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Icon(
                                    Icons.fiber_manual_record_rounded,
                                    color: controller.notificationList[index]
                                                .trangthai ==
                                            0
                                        ? Color.fromRGBO(45, 116, 255, 1)
                                        : Color.fromRGBO(234, 238, 243, 1),
                                    size: 10,
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    children: [
                                      Html(
                                        data:
                                            """${controller.notificationList[index].noidung}""",
                                        style: {
                                          "body": Style(
                                            padding: HtmlPaddings.all(0),
                                            margin: Margins.all(0),
                                          ),
                                        },
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule_rounded,
                                            color: Color.fromRGBO(
                                                153, 162, 179, 1),
                                            size: 12,
                                          ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            controller.timeAgo(controller
                                                .notificationList[index]
                                                .thoigiantao),
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                    153, 162, 179, 1)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          )),
    );
  }
}
