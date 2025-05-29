import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Global/GlobalValue.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Auth {
  static backLogin(bool isRun) async {
    if (!isRun) {
      return null;
    }

    await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, '');
    await Utils.saveStringWithKey(Constant.TEN_NGUOIDUNG, '');
    await Utils.saveStringWithKey(Constant.MATKHAU, '');
    if (Get.currentRoute != Routes.login) {
      Get.offAllNamed(Routes.login);
    }
  }

  static Future<void> login({String? email, String? matkhau}) async {
    // Lấy email & password đã lưu (nếu có)
    String emailPreferences = await Utils.getStringValueWithKey(Constant.EMAIL);
    String passwordPreferences =
        await Utils.getStringValueWithKey(Constant.MATKHAU);

    var param = {
      "email": email ?? emailPreferences,
      "matkhau": matkhau ?? passwordPreferences
    };

    try {
      // Gọi API đăng nhập
      var data =
          await APICaller.getInstance().post('User/Login/dangnhap.php', param);
      print('API response: $data');
      print('Param gửi lên: $param');

      if (data != null && data['success'] == true && data.containsKey('user')) {
        Map<String, dynamic> user = data['user'];

        // Lưu token
        String token = user['token'];
        GlobalValue.getInstance().setToken('Bearer $token');
        await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, token);

        // Đặt thời gian hết hạn là 1 ngày kể từ bây giờ
        // DateTime expiryTime = DateTime.now().add(Duration(minutes: 1));
        // String formattedExpiryTime =
        //     DateFormat('MM/dd/yyyy HH:mm:ss').format(expiryTime);
        // await Utils.saveStringWithKey(
        //     Constant.TOKEN_EXPIRY, formattedExpiryTime);

        // Lưu thông tin người dùng
        await Utils.saveStringWithKey(
            Constant.ID_NGUOIDUNG, user['idnguoidung'].toString());
        await Utils.saveStringWithKey(
            Constant.TEN_NGUOIDUNG, user['tennguoidung']);
        await Utils.saveStringWithKey(Constant.EMAIL, user['email']);
        await Utils.saveStringWithKey(Constant.SDT, user['sodienthoai']);
        await Utils.saveStringWithKey(Constant.DIACHI, user['diachi']);
        await Utils.saveStringWithKey(
            Constant.VAITRO, user['vaitro'].toString());
        await Utils.saveStringWithKey(
            Constant.MATKHAU, matkhau ?? passwordPreferences);

        // Chuyển hướng về trang chủ sau khi đăng nhập thành công
        Get.offAllNamed(Routes.dashboard);
      } else {
        print('Dữ liệu trả về từ API không hợp lệ hoặc đăng nhập thất bại.');
        Utils.showSnackBar(
            title: 'Thông báo',
            message: data?['message'] ?? 'Email hoặc mật khẩu không đúng.');
        backLogin(true);
      }
    } catch (e) {
      print('Lỗi khi gọi API đăng nhập: $e');
      Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Đã xảy ra lỗi khi đăng nhập. Vui lòng thử lại.');
      backLogin(true);
    }
  }

  static Future<void> signup({
    required String tennguoidung,
    required String email,
    required String matkhau,
    required String sodienthoai,
    required String diachi,
  }) async {
    var param = {
      "tennguoidung": tennguoidung,
      "email": email,
      "matkhau": matkhau,
      "sodienthoai": sodienthoai,
      "diachi": diachi
    };

    try {
      var data =
          await APICaller.getInstance().post('User/Login/dangky.php', param);
      print('API response: $data');
      print('Param gửi lên: $param');

      if (data != null && data['success'] == true) {
        Utils.showSnackBar(
            title: 'Thông báo',
            message: 'Đăng ký thành công. Vui lòng đăng nhập.');
        Get.offAllNamed(Routes.login);
      } else {
        print('Đăng ký thất bại: ${data?['message']}');
        Utils.showSnackBar(
            title: 'Thông báo',
            message: data?['message'] ?? 'Đăng ký thất bại.');
      }
    } catch (e) {
      print('Lỗi khi gọi API đăng ký: $e');
      Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Đã xảy ra lỗi khi đăng ký. Vui lòng thử lại.');
    }
  }
}
