import 'package:get/get.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Utils/Utils.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    userName.value =
        await Utils.getStringValueWithKey(Constant.TEN_NGUOIDUNG) ?? '';
    email.value = await Utils.getStringValueWithKey(Constant.EMAIL) ?? '';
  }
}
