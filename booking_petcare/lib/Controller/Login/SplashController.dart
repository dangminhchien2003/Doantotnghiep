// booking_petcare/Controller/Login/SplashController.dart
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Services/Auth.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    String accessToken =
        await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);

    await Future.delayed(const Duration(seconds: 3));

    if (accessToken.isEmpty) {
      // Nếu không có token, chuyển đến màn hình đăng nhập
      Get.offAllNamed(Routes.onbroading);
      ;
    } else {
      await Auth.login();
    }
  }
}
