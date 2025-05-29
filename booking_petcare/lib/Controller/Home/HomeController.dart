import 'dart:async';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Global/GlobalValue.dart';
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:booking_petcare/Model/Blog/BlogModel.dart';
import 'package:booking_petcare/Model/Services/ServicesModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxBool isLoading = true.obs;
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? timer;
  var userName = ''.obs;

  var isLoadingBlogs = true.obs;
  @override
  void onInit() {
    super.onInit();
    startAutoSlide();
    loadUserName();
  }

  void loadUserName() async {
    userName.value =
        await Utils.getStringValueWithKey(Constant.TEN_NGUOIDUNG) ?? '';
  }

  void startAutoSlide() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        int nextPage = (currentPage.value + 1) % 3;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        currentPage.value = nextPage;
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
