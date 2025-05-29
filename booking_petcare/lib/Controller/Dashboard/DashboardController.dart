import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var currentPageIndex = 0.obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var avatar = ''.obs;
  var fullName = ''.obs;
  var email = '';

  void changePage(int index) {
    currentPageIndex.value = index;
  }
}
