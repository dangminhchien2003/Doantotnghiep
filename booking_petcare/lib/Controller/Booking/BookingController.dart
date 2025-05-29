import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Services/PushNotification.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  var selectedPet = ''.obs;
  var selectedCenter = ''.obs;
  var selectedServiceIds = <int>[].obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  // Thông tin người dùng
  var userName = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  void loadUserInfo() async {
    userName.value =
        await Utils.getStringValueWithKey(Constant.TEN_NGUOIDUNG) ?? '';
    phoneNumber.value = await Utils.getStringValueWithKey(Constant.SDT) ?? '';
    address.value = await Utils.getStringValueWithKey(Constant.DIACHI) ?? '';
  }

  String getSelectedPetName() {
    final petController = Get.find<PetsController>();
    final pet = petController.pets
        .firstWhereOrNull((p) => p.idthucung.toString() == selectedPet.value);
    return pet?.tenthucung ?? 'Chưa chọn';
  }

  String getSelectedServiceNames() {
    final serviceController = Get.find<ServiceController>();

    if (selectedServiceIds.isEmpty) return 'Chưa chọn';

    List<String> names = selectedServiceIds
        .map((id) {
          final service = serviceController.filteredServices
              .firstWhereOrNull((s) => s.id == id);
          return service?.name ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();

    return names.isEmpty ? 'Chưa chọn' : names.join(', ');
  }

  Future<void> submitBooking() async {
    try {
      var idUser = await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);

      if (idUser == null ||
          selectedPet.value.isEmpty ||
          selectedServiceIds.isEmpty) {
        Utils.showSnackBar(
            title: 'Lỗi', message: 'Vui lòng điền đầy đủ thông tin.');
        return;
      }

      var bookingData = {
        "idnguoidung": int.parse(idUser),
        "idthucung": int.parse(selectedPet.value),
        "idtrungtam": selectedCenter.value.isNotEmpty
            ? int.parse(selectedCenter.value)
            : 1,
        "ngayhen": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        "thoigianhen": selectedTime.value.format(Get.context!),
        "dichvu": selectedServiceIds.toList(),
      };

      print('📤 Dữ liệu gửi đi: $bookingData');

      var response = await APICaller.getInstance().post(
        "User/Lichhen/themlichhen.php",
        bookingData,
      );

      if (response != null && response["success"] == true) {
        // Utils.showSnackBar(
        //     title: 'Thành công', message: 'Đặt lịch thành công!');
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response != null
              ? (response["message"] ?? "Lỗi không xác định")
              : "Đặt lịch thất bại.",
        );
      }
    } catch (e) {
      print('❌ Lỗi khi đặt lịch: $e');
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi khi đặt lịch.');
    }
  }
}
