import 'package:booking_petcare/Model/Center/CenterModel.dart';
import 'package:get/get.dart';
import 'package:booking_petcare/Services/APICaller.dart'; // Giả sử APICaller của bạn được cấu hình đúng
import 'package:url_launcher/url_launcher.dart';

class CenterController extends GetxController {
  var center = Rxn<CenterModel>();
  var isLoading = true.obs;

  // Biến trạng thái để hiển thị/ẩn khối "Giới thiệu" và "Bản đồ" chung
  var hienThiThongTinMoRong = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCenterInfo();
  }

  // Hàm để bật/tắt hiển thị khối thông tin mở rộng
  void toggleHienThiThongTinMoRong() {
    hienThiThongTinMoRong.toggle();
  }

  // Gọi điện thoại
  Future<void> makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar("Lỗi", "Không có số điện thoại.");
      return;
    }
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar("Lỗi", "Không thể thực hiện cuộc gọi đến $phoneNumber");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể thực hiện cuộc gọi: $e");
    }
  }

  // Gửi email
  Future<void> launchEmail(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Lỗi", "Không có địa chỉ email.");
      return;
    }
    final Uri url = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar("Lỗi", "Không thể gửi email đến $email");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể gửi email: $e");
    }
  }

  // Mở Google Maps
  Future<void> openGoogleMaps(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      Get.snackbar("Lỗi", "Không có thông tin tọa độ.");
      return;
    }
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    final Uri url = Uri.parse(googleMapsUrl);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar("Lỗi", "Không mở được Google Maps.");
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không mở được Google Maps: $e");
    }
  }

  Future<void> fetchCenterInfo() async {
    try {
      isLoading.value = true;
      hienThiThongTinMoRong.value = false;

      var response =
          await APICaller.getInstance().get("User/Center/gettrungtam.php");

      if (response != null && response is Map<String, dynamic>) {
        if (response.containsKey('error')) {
          Get.snackbar(
              "Lỗi API", response['error'] ?? "Lỗi không xác định từ server.");
          center.value = null;
        } else {
          center.value = CenterModel.fromJson(response);
        }
      } else {
        Get.snackbar(
            "Lỗi", "Dữ liệu trung tâm không đúng định dạng hoặc không có.");
        center.value = null;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Lỗi khi tải thông tin trung tâm: ${e.toString()}");
      print("Lỗi khi load trung tâm: $e");
      center.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
