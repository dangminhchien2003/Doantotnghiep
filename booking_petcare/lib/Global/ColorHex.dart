import 'package:flutter/material.dart';

class ColorHex {
  static const main = Color.fromRGBO(56, 94, 186, 1);
  static const background = Color(0xffeceff3);
  static const textContent = Color(0xFF777E90);

  // ✅ Màu cho trạng thái lịch hẹn
  static const appointment_status_0 =
      Color.fromRGBO(251, 146, 60, 1); // Chờ xác nhận - cam
  static const appointment_status_1 = Color.fromRGBO(56, 94, 186, 1);
  static const appointment_status_2 =
      Color.fromRGBO(65, 205, 79, 1); // Đang thực hiện -
  static const appointment_status_3 =
      Color.fromRGBO(14, 165, 233, 1); // Hoàn thành
  static const appointment_status_5 = Colors.purple; // Đã thanh toán
  static const appointment_status_4 =
      Color.fromRGBO(238, 0, 51, 1); // Đã hủy - đỏ đậm

  // (Tuỳ chọn) nền nhẹ
  static const appointment_bg_status_0 = Color.fromRGBO(251, 146, 60, 0.15);
  static const appointment_bg_status_1 = Color.fromRGBO(56, 94, 186, 0.15);
  static const appointment_bg_status_2 = Color.fromRGBO(65, 205, 79, 0.15);
  static const appointment_bg_status_3 = Color.fromRGBO(14, 165, 233, 0.15);
  static const appointment_bg_status_4 = Color.fromRGBO(238, 0, 51, 0.15);

  static const textGrey800 = Color.fromRGBO(32, 41, 57, 1);
}
