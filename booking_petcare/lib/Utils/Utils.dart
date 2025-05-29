import 'dart:convert';
import 'dart:io';
import 'package:booking_petcare/Global/ColorHex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static void showSnackBar(
      {required String title,
      required String message,
      bool isError = false,
      Color? colorText = Colors.white,
      Widget? icon,
      bool isDismissible = true,
      Duration duration = const Duration(seconds: 2),
      Duration animationDuration = const Duration(seconds: 1),
      Color? backgroundColor = Colors.black,
      SnackPosition? direction = SnackPosition.TOP,
      Curve? animation}) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// ✅ Hàm chuyển đổi trạng thái lịch hẹn
  static String getAppointmentStatusText(int status) {
    switch (status) {
      case 0:
        return "Chờ xác nhận";
      case 1:
        return "Đang thực hiện";
      case 2:
        return "Hoàn thành";
      case 3:
        return "Đã thanh toán";
      case 4:
        return "Đã hủy";
      default:
        return "Không xác định";
    }
  }

  // Hàm trả về màu theo trạng thái
  static Color getAppointmentStatusColor(int status) {
    switch (status) {
      case 0:
        return ColorHex.appointment_status_0;
      case 1:
        return ColorHex.appointment_status_1;
      case 2:
        return ColorHex.appointment_status_2;
      case 3:
        return ColorHex.appointment_status_3;
      case 6:
        return Colors.amber;
      case 5:
        return Colors.purple;
      case 4:
        return ColorHex.appointment_status_4;
      default:
        return Colors.grey;
    }
  }

  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  static String formatCurrency(dynamic number) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatCurrency.format(number);
  }

  // static String getScaleType(int value) {
  //   return value == 0 ? 'Cân lẻ' : 'Cân lô'; // 1 cân  lô
  // }

  // static Color gettextColorstate(int value) {
  //   switch (value) {
  //     case 0:
  //       return ColorHex.status_0;
  //     case 1:
  //       return ColorHex.status_1;
  //     case 2:
  //       return ColorHex.status_2;
  //     case 3:
  //       return ColorHex.status_3;
  //     case 4:
  //       return ColorHex.status_4;
  //     case 5:
  //       return ColorHex.status_5;
  //     default:
  //       return Colors.transparent;
  //   }
  // }
}
