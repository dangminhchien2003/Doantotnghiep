import 'dart:async';
import 'package:booking_petcare/Controller/Appointment/UpcomingAppointmentController.dart';
import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:booking_petcare/Model/Prescription/PrescriptionModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Services/PushNotification.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ✅ BƯỚC 1: ĐỊNH NGHĨA CLASS TimeSlotDisplayInfo
class TimeSlotDisplayInfo {
  final TimeOfDay time;
  final bool isBooked;
  final bool isPast;

  TimeSlotDisplayInfo({
    required this.time,
    this.isBooked = false,
    this.isPast = false,
  });

  bool get isSelectable => !isBooked && !isPast;

  @override
  String toString() {
    return 'TimeSlot(time: ${time.hour}:${time.minute}, booked: $isBooked, past: $isPast, selectable: $isSelectable)';
  }
}

class AppointmentController extends GetxController {
  // --- ID Trung tâm mặc định ---
  final String defaultCenterId = "1";

  var appointments = <AppointmentModel>[].obs;
  var isLoadingAppointments = true.obs;
  List<AppointmentModel> allAppointments = [];

  RxBool isExpanded = false.obs;

  //Đặt lịch
  var selectedPet = ''.obs;
  // var selectedCenter = ''.obs;
  var selectedServiceIds = <int>[].obs;
  var selectedDate = DateTime.now().obs;
  // var selectedTime = TimeOfDay.now().obs;
  var selectedTime = Rx<TimeOfDay?>(null);

  // Thông tin người dùng
  var userName = ''.obs;
  var phoneNumber = ''.obs;
  var address = ''.obs;

  var selectedPrescription = Rxn<Prescription>(); // Rxn cho phép giá trị null
  var isLoadingPrescription = false.obs;
  var prescriptionError = Rxn<String>();

  // --- Thêm các biến cho logic chọn giờ ---
  // var availableTimeSlots = <TimeOfDay>[].obs;
  var displayableTimeSlots = <TimeSlotDisplayInfo>[].obs;
  var bookedStartTimesForSelectedDate = <TimeOfDay>[].obs;

  final TimeOfDay openingTime = TimeOfDay(hour: 8, minute: 0); // 8 AM
  final TimeOfDay closingTime = TimeOfDay(hour: 17, minute: 0); // 5 PM
  final int slotIncrementInMinutes = 60; // Mỗi slot cách nhau 60 phút

  @override
  void onInit() {
    super.onInit();
    fetchAllAppointments();
    loadUserInfo();

    // ✅ THÊM: Logic xử lý khi ngày thay đổi và tải slot lần đầu
    ever(selectedDate, (_) {
      selectedTime.value = null; // Reset giờ đã chọn khi đổi ngày
      fetchAndGenerateAvailableSlots();
    });
    fetchAndGenerateAvailableSlots(); // Tải slot lần đầu cho ngày hiện tại
  }

  //lấy thông tin người dùng
  void loadUserInfo() async {
    userName.value =
        await Utils.getStringValueWithKey(Constant.TEN_NGUOIDUNG) ?? '';
    phoneNumber.value = await Utils.getStringValueWithKey(Constant.SDT) ?? '';
    address.value = await Utils.getStringValueWithKey(Constant.DIACHI) ?? '';
  }

  // ✅ THÊM: Hàm tải và tạo các slot giờ trống
  Future<void> fetchAndGenerateAvailableSlots() async {
    displayableTimeSlots.clear(); // Xóa danh sách cũ
    bookedStartTimesForSelectedDate.clear();

    print(
        '📡 Gọi API getlichtrungtamtheongay.php cho ngày: ${DateFormat('yyyy-MM-dd').format(selectedDate.value)}, centerId: $defaultCenterId');
    try {
      var response = await APICaller.getInstance().get(
        "User/Lichhen/getlichtrungtamtheongay.php",
        queryParams: {
          "idtrungtam": defaultCenterId,
          "ngayhen": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        },
      );

      if (response != null && response is List) {
        List<TimeOfDay> fetchedTimes = [];
        for (var item in response) {
          if (item is Map && item.containsKey('thoigianhen')) {
            String timeStr = item['thoigianhen'];
            try {
              TimeOfDay parsedTime;
              if (RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$').hasMatch(timeStr)) {
                final parts = timeStr.split(':');
                parsedTime = TimeOfDay(
                    hour: int.parse(parts[0]), minute: int.parse(parts[1]));
              } else if (timeStr.contains('AM') || timeStr.contains('PM')) {
                DateTime tempDate =
                    DateFormat("h:mm a", "en_US").parse(timeStr);
                parsedTime = TimeOfDay.fromDateTime(tempDate);
              } else {
                final parts = timeStr.split(':');
                parsedTime = TimeOfDay(
                    hour: int.parse(parts[0]), minute: int.parse(parts[1]));
              }
              fetchedTimes.add(parsedTime);
            } catch (e) {
              print('❌ Lỗi parse thời gian từ API: "$timeStr" - $e');
            }
          }
        }
        bookedStartTimesForSelectedDate.assignAll(fetchedTimes);
        print(
            '🗓️ Các giờ đã đặt cho ngày ${selectedDate.value.toIso8601String().substring(0, 10)}: $bookedStartTimesForSelectedDate');
      } else {
        print(
            'ℹ️ Không có giờ nào được đặt hoặc phản hồi API không hợp lệ cho getlichtrungtamtheongay.php. Response: $response');
      }
    } catch (e) {
      print('❌ Lỗi khi tải các giờ đã đặt: $e');
    }

    List<TimeSlotDisplayInfo> newSlots = []; // Danh sách tạm thời
    DateTime now = DateTime.now();
    DateTime date = selectedDate.value;
    TimeOfDay currentTimeSlot = openingTime;

    while ((currentTimeSlot.hour < closingTime.hour) ||
        (currentTimeSlot.hour == closingTime.hour &&
            currentTimeSlot.minute < closingTime.minute)) {
      bool isBooked = bookedStartTimesForSelectedDate.any((bookedTime) =>
          bookedTime.hour == currentTimeSlot.hour &&
          bookedTime.minute == currentTimeSlot.minute);

      bool isPastSlotForToday = false;
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        DateTime currentSlotDateTime = DateTime(date.year, date.month, date.day,
            currentTimeSlot.hour, currentTimeSlot.minute);
        if (currentSlotDateTime
            .isBefore(now.subtract(const Duration(seconds: 1)))) {
          isPastSlotForToday = true;
        }
      }

      newSlots.add(TimeSlotDisplayInfo(
        time: currentTimeSlot,
        isBooked: isBooked,
        isPast: isPastSlotForToday,
      ));

      int currentTotalMinutes =
          currentTimeSlot.hour * 60 + currentTimeSlot.minute;
      int nextTotalMinutes = currentTotalMinutes + slotIncrementInMinutes;

      if (nextTotalMinutes >= (closingTime.hour * 60 + closingTime.minute)) {
        break;
      }
      if (nextTotalMinutes < 24 * 60) {
        currentTimeSlot = TimeOfDay(
            hour: nextTotalMinutes ~/ 60, minute: nextTotalMinutes % 60);
      } else {
        break;
      }
    }
    displayableTimeSlots.assignAll(newSlots); // Cập nhật danh sách chính
    print('🆕 Danh sách slot hiển thị: $displayableTimeSlots');

    // Kiểm tra và reset selectedTime nếu nó không còn hợp lệ
    if (selectedTime.value != null) {
      final currentSelectedSlotInfo = displayableTimeSlots.firstWhereOrNull(
          (info) =>
              info.time.hour == selectedTime.value!.hour &&
              info.time.minute == selectedTime.value!.minute);
      if (currentSelectedSlotInfo == null ||
          !currentSelectedSlotInfo.isSelectable) {
        selectedTime.value = null;
      }
    }

    if (displayableTimeSlots.where((s) => s.isSelectable).isEmpty) {
      print(
          '🚫 Không có giờ trống nào (có thể chọn) cho ngày ${DateFormat('dd/MM/yyyy').format(selectedDate.value)}');
    }
  }

  // lấy tên thú cưng
  String getSelectedPetName() {
    final petController = Get.find<PetsController>();
    final pet = petController.pets
        .firstWhereOrNull((p) => p.idthucung.toString() == selectedPet.value);
    return pet?.tenthucung ?? 'Chưa chọn';
  }

  // lấy danh sách tên dịch vụ
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

  // xác nhận đặt lịch
  Future<bool> submitBooking() async {
    try {
      var idUser = await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);

      if (idUser == null ||
          selectedPet.value.isEmpty ||
          selectedServiceIds.isEmpty) {
        Utils.showSnackBar(
            title: 'Lỗi', message: 'Vui lòng điền đầy đủ thông tin.');
        return false; // <- trả về false khi thiếu thông tin
      }
      // ✅ Parse idUserStr sang int một lần ở đây
      final int idUserInt;
      try {
        idUserInt = int.parse(idUser);
      } catch (e) {
        print('❌ Lỗi parse ID người dùng: $e');
        Utils.showSnackBar(
            title: 'Lỗi', message: 'ID người dùng không hợp lệ.');
        return false;
      }

      // Kiểm tra lại xem giờ đã chọn có thực sự hợp lệ không
      final selectedSlotInfo = displayableTimeSlots.firstWhereOrNull((info) =>
          info.time.hour == selectedTime.value!.hour &&
          info.time.minute == selectedTime.value!.minute);

      if (selectedSlotInfo == null || !selectedSlotInfo.isSelectable) {
        Utils.showSnackBar(
            title: 'Lỗi',
            message:
                'Giờ bạn chọn không còn trống hoặc không hợp lệ. Vui lòng chọn lại.',
            duration: Duration(seconds: 4));
        fetchAndGenerateAvailableSlots(); // Tải lại slot để người dùng thấy sự thay đổi (nếu có)
        return false;
      }

      var bookingData = {
        "idnguoidung": idUserInt,
        "idthucung": int.parse(selectedPet.value),
        "idtrungtam":
            int.parse(defaultCenterId), // ✅ SỬA: Sử dụng defaultCenterId
        "ngayhen": DateFormat('yyyy-MM-dd').format(selectedDate.value),
        "thoigianhen":
            selectedTime.value!.format(Get.context!), // Đã kiểm tra null ở trên
        "dichvu": selectedServiceIds.toList(),
      };
      // var bookingData = {
      //   "idnguoidung": idUserInt,
      //   "idthucung": int.parse(selectedPet.value),
      //   "idtrungtam": selectedCenter.value.isNotEmpty
      //       ? int.parse(selectedCenter.value)
      //       : 1,
      //   "ngayhen": DateFormat('yyyy-MM-dd').format(selectedDate.value),
      //   "thoigianhen": selectedTime.value.format(Get.context!),
      //   "dichvu": selectedServiceIds.toList(),
      // };

      print('📤 Dữ liệu gửi đi: $bookingData');

      var response = await APICaller.getInstance().post(
        "User/Lichhen/themlichhen.php",
        bookingData,
      );

      if (response != null && response["success"] == true) {
        // Utils.showSnackBar(
        //     title: 'Thành công', message: 'Đặt lịch thành công!');
        fetchAllAppointments();
        Get.find<UpcomingAppointmentController>().fetchUpcomingAppointments();

        // GỌI scheduleReminders để thông báo định kỳ
        try {
          final DateTime appointmentDateTime = DateTime(
            selectedDate.value.year,
            selectedDate.value.month,
            selectedDate.value.day,
            selectedTime.value!.hour,
            selectedTime.value!.minute,
          );

          String petName = getSelectedPetName();
          String serviceNames = getSelectedServiceNames();

          String formattedTime =
              DateFormat('HH:mm').format(appointmentDateTime);
          String formattedDate =
              DateFormat('dd/MM/yyyy').format(appointmentDateTime);

          String reminderTitle = 'Lịch hẹn sắp tới cho $petName';
          String reminderBody =
              'Bạn có lịch hẹn vào lúc $formattedTime ngày $formattedDate. Dịch vụ: $serviceNames.';

          if (petName == 'Chưa chọn') {
            reminderTitle = 'Lịch hẹn sắp tới của bạn';
          }

          print(
              'DEBUG (AppointmentController): Chuẩn bị gọi scheduleReminders với:');

          print('idnguoidung: $idUserInt');
          print('appointmentDateTime: $appointmentDateTime');
          print('Tiêu đề: $reminderTitle');
          print('Nội dung: $reminderBody');

          await PushNotifications.scheduleReminders(
            idUserInt,
            appointmentDateTime,
            tieude: reminderTitle,
            noidung: reminderBody,
          );
          print(
              'DEBUG (AppointmentController): Đã gọi xong PushNotifications.scheduleReminders.');
        } catch (e) {
          print('❌ Lỗi khi gọi scheduleReminders: $e');
        }
        return true;
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response != null
              ? (response["message"] ?? "Lỗi không xác định")
              : "Đặt lịch thất bại.",
        );
        return false;
      }
    } catch (e) {
      print('❌ Lỗi khi đặt lịch: $e');
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi khi đặt lịch.');
      return false;
    }
  }

  // reset tùy chọn đặt lịch
  void resetBookingForm() {
    selectedPet.value = '';
    selectedServiceIds.clear();
    selectedDate.value = DateTime.now();
    // selectedTime.value = TimeOfDay.now();
    selectedTime.value = null;
  }

  Future<void> fetchAllAppointments() async {
    try {
      isLoadingAppointments.value = true;
      print('📡 Gọi API getlichhenbynguoidung.php...');

      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);

      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }

      var response = await APICaller.getInstance()
          .get('User/Lichhen/getlichhenbynguoidung.php', queryParams: {
        "idnguoidung": idNguoiDung,
      });

      List<AppointmentModel> parsedAppointments = [];

      if (response is List) {
        parsedAppointments = response
            .map((e) {
              try {
                return AppointmentModel.fromJson(e);
              } catch (error) {
                print('❌ Lỗi khi parse JSON: $error với dữ liệu: $e');
                return null;
              }
            })
            .whereType<AppointmentModel>()
            .toList();
      } else if (response is Map && response.containsKey('data')) {
        parsedAppointments = (response['data'] as List)
            .map((e) {
              try {
                return AppointmentModel.fromJson(e);
              } catch (error) {
                print('❌ Lỗi parse JSON: $error với dữ liệu: $e');
                return null;
              }
            })
            .whereType<AppointmentModel>()
            .toList();
      } else {
        throw Exception('❌ Phản hồi API không hợp lệ');
      }

      allAppointments = parsedAppointments;
      appointments.assignAll(parsedAppointments);
    } catch (e) {
      print('❌ Lỗi khi lấy lịch hẹn: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể tải danh sách lịch hẹn');
    } finally {
      isLoadingAppointments.value = false;
    }
  }

  //hủy lịch hẹn
  Future<void> cancelAppointment(int idlichhen, String reason) async {
    try {
      // Thêm tiền tố "[User]: " vào trước lý do hủy
      String reasonWithSender = "[User]: $reason"; // <--- THAY ĐỔI Ở ĐÂY

      var response = await APICaller.getInstance().post(
        "User/Lichhen/huylichhen.php",
        {
          "idlichhen": idlichhen,
          "reason": reasonWithSender, // Sử dụng lý do đã có tiền tố
        },
      );

      if (response != null && response["success"] == true) {
        await fetchAllAppointments(); // 🛠 Load lại từ API
        // Giả sử bạn có UpcomingAppointmentController và muốn cập nhật nó
        if (Get.isRegistered<UpcomingAppointmentController>()) {
          Get.find<UpcomingAppointmentController>().fetchUpcomingAppointments();
        }
        Get.snackbar('Thành công', 'Hủy lịch hẹn thành công!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response != null
              ? (response["message"] ?? "Hủy lịch thất bại.")
              : "Hủy lịch thất bại.",
        );
      }
    } catch (e) {
      print('❌ Lỗi khi hủy lịch: $e');
      Get.snackbar('Lỗi', 'Không thể hủy lịch hẹn!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchPrescriptionDetails(int idlichhen) async {
    const String userFriendlyNoPrescriptionMessage =
        "Lịch hẹn này không có đơn thuốc.";
    const String apiOriginalNoPrescriptionMessage =
        "Không tìm thấy đơn thuốc cho lịch hẹn này";

    try {
      isLoadingPrescription.value = true;
      prescriptionError.value = null;
      selectedPrescription.value = null;

      debugPrint(
          '📡 Đang gọi API: User/Donthuoc/getdonthuocbylichhen.php cho idlichhen: $idlichhen');

      var responseFromApiCaller = await APICaller.getInstance().get(
        'User/Donthuoc/getdonthuocbylichhen.php',
        queryParams: {"idlichhen": idlichhen.toString()},
      );

      if (responseFromApiCaller == null) {
        // THEO YÊU CẦU: diễn giải null từ APICaller là "Không có đơn thuốc"
        // CẢNH BÁO: Điều này có thể che giấu lỗi mạng/server thực sự.
        prescriptionError.value = userFriendlyNoPrescriptionMessage;
        debugPrint(
            'ℹ️ APICaller trả về null, được diễn giải là "$userFriendlyNoPrescriptionMessage" cho idlichhen: $idlichhen.');
      } else if (responseFromApiCaller is Map &&
          responseFromApiCaller.containsKey('error') &&
          responseFromApiCaller['error'] is Map) {
        final errorData = responseFromApiCaller['error'];
        final int errorCode = errorData['code'] ?? -1;
        final String apiMessage =
            errorData['message'] ?? 'Lỗi không xác định từ API.';

        if (errorCode == 0) {
          if (responseFromApiCaller['data'] != null &&
              responseFromApiCaller['data'] is Map<String, dynamic> &&
              (responseFromApiCaller['data'] as Map).isNotEmpty) {
            try {
              selectedPrescription.value = Prescription.fromJson(
                  responseFromApiCaller['data'] as Map<String, dynamic>);
              debugPrint(
                  '💊 Đơn thuốc tải thành công (response đầy đủ, error.code=0) cho idlichhen: $idlichhen');
            } catch (e, stackTrace) {
              debugPrint(
                  '❌ Lỗi parse Prescription.fromJson (response đầy đủ, error.code=0): $e\n$stackTrace\nData: ${responseFromApiCaller['data']}');
              prescriptionError.value =
                  'Lỗi xử lý dữ liệu đơn thuốc nhận được (mã 0).';
            }
          } else {
            prescriptionError.value =
                'API báo thành công (mã 0) nhưng không có dữ liệu chi tiết.';
            debugPrint(
                'ℹ️ API báo error.code == 0 (response đầy đủ) nhưng data không hợp lệ/trống cho idlichhen: $idlichhen.');
          }
        } else {
          // API báo lỗi (errorCode != 0)
          if (apiMessage == apiOriginalNoPrescriptionMessage) {
            prescriptionError.value = userFriendlyNoPrescriptionMessage;
          } else {
            prescriptionError.value = apiMessage;
          }
          debugPrint(
              '❌ Lỗi từ API (code: $errorCode): "$apiMessage". Full response: $responseFromApiCaller');
        }
      } else if (responseFromApiCaller is Map<String, dynamic>) {
        if (responseFromApiCaller.isNotEmpty) {
          try {
            selectedPrescription.value =
                Prescription.fromJson(responseFromApiCaller);
            debugPrint(
                '💊 Đơn thuốc tải thành công (data trực tiếp) cho idlichhen: $idlichhen');
          } catch (e, stackTrace) {
            debugPrint(
                '❌ Lỗi parse Prescription.fromJson (data trực tiếp): $e\n$stackTrace\nData: $responseFromApiCaller');
            prescriptionError.value = 'Lỗi xử lý dữ liệu đơn thuốc nhận được.';
          }
        } else {
          prescriptionError.value = userFriendlyNoPrescriptionMessage;
          debugPrint(
              'ℹ️ Dữ liệu đơn thuốc trống được trả về (data trực tiếp) cho idlichhen: $idlichhen, diễn giải là "$userFriendlyNoPrescriptionMessage".');
        }
      } else {
        prescriptionError.value =
            'Phản hồi từ máy chủ có định dạng không mong đợi.';
        debugPrint(
            '❌ Phản hồi API ... có kiểu không mong đợi: ${responseFromApiCaller.runtimeType}. Response: $responseFromApiCaller');
      }
    } catch (e, stackTrace) {
      debugPrint(
          '❌ Lỗi nghiêm trọng xảy ra trong fetchPrescriptionDetails: $e\n$stackTrace');
      prescriptionError.value =
          'Đã xảy ra sự cố không mong muốn. Vui lòng thử lại.';
    } finally {
      isLoadingPrescription.value = false;
      if (prescriptionError.value != null && Get.isSnackbarOpen != true) {
        // Biến userFriendlyNoPrescriptionMessage giờ đã có thể truy cập ở đây
        bool isInformationalOnly =
            prescriptionError.value == userFriendlyNoPrescriptionMessage;

        Utils.showSnackBar(
          title: isInformationalOnly ? 'Thông báo' : 'Lỗi',
          message: prescriptionError.value!,
          isError: !isInformationalOnly,
          backgroundColor:
              isInformationalOnly ? Colors.blueGrey.shade700 : null,
          icon: isInformationalOnly
              ? const Icon(Icons.info_outline_rounded, color: Colors.white)
              : null,
        );
      }
    }
  }
}
