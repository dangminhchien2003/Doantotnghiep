import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInformationController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;

  // Không cần TextEditingController nữa vì chúng ta sử dụng Obs
  // final TextEditingController nameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController phoneController = TextEditingController();
  // final TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  void initData() async {
    // Lấy thông tin người dùng từ local storage và gán vào biến observable
    name.value =
        await Utils.getStringValueWithKey(Constant.TEN_NGUOIDUNG) ?? '';
    email.value = await Utils.getStringValueWithKey(Constant.EMAIL) ?? '';
    phone.value = await Utils.getStringValueWithKey(Constant.SDT) ?? '';
    address.value = await Utils.getStringValueWithKey(Constant.DIACHI) ?? '';
  }

  Future<void> updateUser() async {
    String? idnguoidung =
        await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
    if (idnguoidung == null) {
      throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
    }

    final body = {
      "idnguoidung": idnguoidung,
      "tennguoidung":
          name.value.trim(), // Sử dụng name.value thay vì controller.text
      "email": email.value.trim(),
      "sodienthoai": phone.value.trim(),
      "diachi": address.value.trim(),
    };

    var response = await APICaller.getInstance()
        .post('User/Account/suanguoidungbyid.php', body);

    if (response != null && response['success'] == true) {
      Utils.showSnackBar(
          title: 'Thành công', message: response['message'] ?? '');

      // Lưu thông tin mới vào local
      await Utils.saveStringWithKey(Constant.TEN_NGUOIDUNG, name.value);
      await Utils.saveStringWithKey(Constant.EMAIL, email.value);
      await Utils.saveStringWithKey(Constant.SDT, phone.value);
      await Utils.saveStringWithKey(Constant.DIACHI, address.value);

      // Cập nhật lại observable với dữ liệu mới (trong trường hợp có sự thay đổi)
      initData();
    } else {
      Utils.showSnackBar(
          title: 'Lỗi', message: response?['message'] ?? 'Không thể cập nhật.');
    }
  }

  @override
  void onClose() {
    // Không cần dispose vì không còn sử dụng TextEditingController
    super.onClose();
  }
}
