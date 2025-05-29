import 'dart:async';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Logincontroller extends GetxController {
  TextEditingController textUserName = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPhone = TextEditingController();
  TextEditingController textPass = TextEditingController();
  TextEditingController textRePass = TextEditingController();
  TextEditingController textAddress = TextEditingController();

  TextEditingController textEmailSignup = TextEditingController();
  TextEditingController textPassSignup = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxBool isHideRePassword = true.obs;
  RxBool isHidePasswordSignup = true.obs;
  RxBool isLoading = false.obs;
  DateTime timeNow = DateTime.now();

  // Forgot password
  RxBool isOTP = false.obs;
  RxBool isButtonDisabled = true.obs;
  RxInt timerValue = 60.obs;
  Timer? timer;
  RxBool isHidePasswordOld = true.obs;
  RxBool isHidePasswordNew = true.obs;
  RxBool isHidePasswordConfirm = true.obs;
  RxBool isForgotPasswordLoading = false.obs;

  TextEditingController textOTP = TextEditingController();
  TextEditingController textPasswordOld = TextEditingController();
  TextEditingController textPasswordNew = TextEditingController();
  TextEditingController textPasswordConfirm = TextEditingController();

  RxString passwordError = ''.obs;

  bool isValidPassword(String password) {
    final hasMinLength = password.length >= 6;
    final hasLetter = password.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    return hasMinLength && hasLetter && hasNumber;
  }

  void validatePassword(String value) {
    if (!isValidPassword(value)) {
      passwordError.value = 'Mật khẩu phải ≥6 ký tự, gồm chữ và số';
    } else {
      passwordError.value = '';
    }
  }

  startTimer() {
    isButtonDisabled.value = true;
    timerValue.value = 60;

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        timer.cancel();
        isButtonDisabled.value = false;
      }
    });
  }

  Future<void> changePassword() async {
    isForgotPasswordLoading.value = true;

    final idnguoidung =
        await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
    final oldPassword = textPasswordOld.text.trim();
    final newPassword = textPasswordNew.text.trim();
    final confirmPassword = textPasswordConfirm.text.trim();

    if (idnguoidung == null) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không tìm thấy ID người dùng.');
      isForgotPasswordLoading.value = false;
      return;
    }

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Vui lòng nhập đầy đủ thông tin.');
      isForgotPasswordLoading.value = false;
      return;
    }

    if (newPassword != confirmPassword) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Mật khẩu xác nhận không khớp.');
      isForgotPasswordLoading.value = false;
      return;
    }

    if (!isValidPassword(newPassword)) {
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Mật khẩu phải ≥6 ký tự, gồm chữ và số.');
      isForgotPasswordLoading.value = false;
      return;
    }

    final body = {
      'idnguoidung': idnguoidung,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    final response =
        await APICaller.getInstance().post('User/Account/Doimatkhau.php', body);

    if (response != null && response['success'] == true) {
      Utils.showSnackBar(
          title: 'Thành công',
          message: response['message'] ?? 'Đổi mật khẩu thành công');
      textPasswordOld.clear();
      textPasswordNew.clear();
      textPasswordConfirm.clear();
    } else {
      Utils.showSnackBar(
          title: 'Lỗi',
          message: response?['message'] ?? 'Đổi mật khẩu thất bại');
    }

    isForgotPasswordLoading.value = false;
  }
}
