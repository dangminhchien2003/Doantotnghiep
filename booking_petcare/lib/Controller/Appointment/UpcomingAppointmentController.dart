import 'dart:async';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';

class UpcomingAppointmentController extends GetxController {
  final RxList<AppointmentModel> appointments =
      <AppointmentModel>[].obs; // Lịch hẹn gốc
  final RxList<AppointmentModel> filteredAppointments =
      <AppointmentModel>[].obs; // Lịch hẹn đã lọc
  final RxBool isLoadingAppointments = true.obs;

  // Để lưu khoảng ngày lọc
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingAppointments(); // Lấy lịch hẹn khi controller được khởi tạo
  }

  // Hàm lấy danh sách lịch hẹn
  Future<void> fetchUpcomingAppointments() async {
    try {
      isLoadingAppointments.value = true;
      print('📡 Gọi API getlichhensaptoi.php...');

      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);

      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }

      var response = await APICaller.getInstance()
          .get('User/Lichhen/getlichhensaptoi.php', queryParams: {
        "idnguoidung": idNguoiDung,
      });

      if (response == null) {
        throw Exception('API trả về null');
      }

      if (response is List) {
        var parsedAppointments = response
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

        appointments.assignAll(parsedAppointments);
        filteredAppointments.assignAll(
            parsedAppointments); // Lưu lịch hẹn vào filteredAppointments
      } else if (response is Map && response.containsKey('data')) {
        var parsedAppointments = (response['data'] as List)
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

        appointments.assignAll(parsedAppointments);
        filteredAppointments.assignAll(
            parsedAppointments); // Lưu lịch hẹn vào filteredAppointments
      } else {
        throw Exception('Phản hồi API không hợp lệ');
      }
    } catch (e) {
      print('❌ Lỗi khi lấy lịch hẹn sắp tới: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể tải danh sách lịch hẹn sắp tới');
    } finally {
      isLoadingAppointments.value = false;
    }
  }

  // Hàm lọc lịch hẹn theo khoảng ngày
  void filterAppointments() {
    if (fromDate.value == null || toDate.value == null) {
      filteredAppointments.assignAll(appointments);
      return;
    }

    filteredAppointments.assignAll(appointments.where((appt) {
      final apptDate = DateTime.parse(appt.ngayhen); // yyyy-MM-dd
      return apptDate
              .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
          apptDate.isBefore(toDate.value!.add(const Duration(days: 1)));
    }).toList());
  }

  // Cập nhật ngày bắt đầu lọc
  void setFromDate(DateTime date) {
    fromDate.value = date;
    filterAppointments();
  }

  // Cập nhật ngày kết thúc lọc
  void setToDate(DateTime date) {
    toDate.value = date;
    filterAppointments();
  }
}
