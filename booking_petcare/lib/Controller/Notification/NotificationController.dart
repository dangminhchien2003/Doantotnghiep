import 'package:booking_petcare/Controller/Home/HomeController.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Model/Notification/NotificationModel.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  RxBool isLoading = false.obs;
  int totalCount = 0;
  int page = 1;
  int pageSize = 20;
  int totalPage = 0;
  RxList<NotificationModel> notificationList = RxList<NotificationModel>();
  ScrollController scrollController = ScrollController();
  DateTime timeNow = DateTime.now();
  String idnguoidung = '';

  @override
  void onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          getNotification();
        }
      }
    });
    idnguoidung = await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
    await getNotification();
    ;
    super.onInit();
  }

  refreshData() async {
    page = 1;
    notificationList.clear();
    await getNotification();
  }

  //lấy danh sách thông báo
  getNotification() async {
    try {
      String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
      if (page == 1) {
        isLoading.value = true;
      }
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "pageSize": pageSize,
        "page": page,
        "idnguoidung": idnguoidung
      };
      var data = await APICaller.getInstance()
          .post('User/Thongbao/page_list_notify.php', param);
      if (data != null) {
        totalCount = data['data']['pagination']['totalCount'];
        totalPage = data['data']['pagination']['totalPage'];
        List<dynamic> list = data['data']['items'];
        var listItem = list
            .map((dynamic json) => NotificationModel.fromJson(json))
            .toList();
        notificationList.addAll(listItem);
        if (page == 1) {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
      isLoading.value = false;
    }
  }

  //đánh dấu tất cả đã đọc
  readAll() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "idnguoidung": idnguoidung
    };
    try {
      var response = await APICaller.getInstance()
          .post('User/Thongbao/Update_notify_status_all.php', param);
      if (response != null) {
        for (var notification in notificationList) {
          notification.trangthai = 1;
        }
        notificationList.refresh();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  //đánh dấu 1 itime đã đọc
  readOnly({required int index}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert":
          Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "idnguoidung": notificationList[index].idthongbao
    };
    try {
      var response = await APICaller.getInstance()
          .post('User/Thongbao/update_notify_status.php', param);
      if (response != null) {
        notificationList[index].trangthai = 1;
        notificationList.refresh();
        // if (Get.isRegistered<HomeController>()) {
        //   Get.offAllNamed(Routes.dashboard);
        //   // final controller = Get.put(HomeController());
        //   // controller.textSearch.text = notificationList[index].macNumber!;
        //   // controller.teamSelectList.add(notificationList[index].teamidnguoidung!);
        // }
      }
    } catch (e) {
      Utils.showSnackBar(title: 'notification'.tr, message: '$e');
    }
  }

  String timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 8) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
