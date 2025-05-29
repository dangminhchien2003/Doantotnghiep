import 'dart:async';
import 'dart:convert';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Global/GlobalValue.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart' as http;

class PetsController extends GetxController {
  final RxList<PetModel> pets = <PetModel>[].obs; // Danh sách thú cưng gốc
  final RxList<PetModel> filteredPets =
      <PetModel>[].obs; // Danh sách sau khi lọc/tìm kiếm
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPets(); // Khi controller khởi tạo sẽ load luôn danh sách thú cưng
  }

  // Hàm lấy toàn bộ danh sách thú cưng
  Future<void> fetchPets() async {
    try {
      isLoading.value = true;
      print('📡 Gọi API User/Thucung/getthucung.php...');

      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }
      var response = await APICaller.getInstance()
          .get('User/Thucung/getthucungbynguoidung.php', queryParams: {
        "idnguoidung": idNguoiDung,
      });

      if (response == null || response is! List) {
        throw Exception('API trả về null hoặc dữ liệu không hợp lệ');
      }

      var parsedPets = response
          .map((e) {
            try {
              return PetModel.fromJson(e);
            } catch (error) {
              print('🐞 Lỗi parse PetModel: $error với dữ liệu: $e');
              return null;
            }
          })
          .whereType<PetModel>()
          .toList();

      pets.assignAll(parsedPets);
      filteredPets.assignAll(parsedPets);
    } catch (e) {
      print('🐞 Lỗi khi lấy thú cưng: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể tải danh sách thú cưng');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm tìm kiếm thú cưng từ server
  Future<void> searchPets(String query) async {
    if (query.isEmpty) {
      // Nếu ô tìm kiếm rỗng, reload lại toàn bộ
      fetchPets();
      return;
    }

    try {
      isLoading.value = true;
      print(
          '📡 Gọi API User/Thucung/timkiemthucung.php với searchTerm: $query');
      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }

      final response = await APICaller.getInstance()
          .get('User/Thucung/timkiemthucung.php', queryParams: {
        "searchTerm": query,
        "idnguoidung": idNguoiDung,
      });

      if (response == null || response is! List) {
        throw Exception('API tìm kiếm trả về null hoặc dữ liệu không hợp lệ');
      }

      var parsedPets = response
          .map((e) {
            try {
              return PetModel.fromJson(e);
            } catch (error) {
              print(
                  '🐞 Lỗi parse PetModel khi tìm kiếm: $error với dữ liệu: $e');
              return null;
            }
          })
          .whereType<PetModel>()
          .toList();

      filteredPets.assignAll(parsedPets);
    } catch (e) {
      print('🐞 Lỗi tìm kiếm thú cưng: $e');
      Utils.showSnackBar(title: 'Lỗi', message: 'Không thể tìm kiếm thú cưng');
    } finally {
      isLoading.value = false;
    }
  }

  //thêm thú cưng
  Future<void> addPet({
    required String tenthucung,
    required String loaithucung,
    required String giongloai,
    required int tuoi,
    required int cannang,
    required String suckhoe,
  }) async {
    try {
      isLoading.value = true;
      print('📡 Gọi API User/Thucung/addthucung.php...');

      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }

      final Map<String, dynamic> body = {
        "tenthucung": tenthucung,
        "idnguoidung": idNguoiDung,
        "loaithucung": loaithucung,
        "giongloai": giongloai,
        "tuoi": tuoi,
        "cannang": cannang,
        "suckhoe": suckhoe,
      };

      final response = await APICaller.getInstance()
          .post('User/Thucung/themthucung.php', body);

      if (response != null && response['success'] == true) {
        Utils.showSnackBar(title: 'Thành công', message: response['message']);
        await fetchPets(); // Hoặc tự thêm vào danh sách pets luôn nếu bạn muốn nhanh hơn
      } else {
        throw Exception(response?['message'] ?? 'Thêm thú cưng thất bại');
      }
    } catch (e) {
      print('🐞 Lỗi khi thêm thú cưng: $e');
      Utils.showSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm sửa thú cưng
  Future<void> editPet({
    required String idthucung, // Không sửa idthucung
    required String tenthucung,
    required String loaithucung,
    required String giongloai,
    required int tuoi,
    required int cannang,
    required String suckhoe,
  }) async {
    try {
      isLoading.value = true;
      print('📡 Gọi API User/Thucung/suathucung.php...');

      String? idNguoiDung =
          await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
      if (idNguoiDung == null) {
        throw Exception('❗ Không tìm thấy ID người dùng trong bộ nhớ');
      }

      // Tạo body với tất cả thông tin cần thiết, bao gồm idthucung
      final Map<String, dynamic> body = {
        "idthucung": idthucung, // Cần truyền idthucung vào body
        "tenthucung": tenthucung,
        "loaithucung": loaithucung,
        "giongloai": giongloai,
        "tuoi": tuoi,
        "cannang": cannang,
        "suckhoe": suckhoe,
      };

      final response = await APICaller.getInstance()
          .post('User/Thucung/suathucung.php', body);

      if (response != null && response['success'] == true) {
        Utils.showSnackBar(title: 'Thành công', message: response['message']);

        // Sau khi sửa, tải lại danh sách thú cưng để đảm bảo thông tin mới nhất
        await fetchPets();

        // Cập nhật thú cưng trong bộ nhớ nếu cần
        int index = pets.indexWhere((pet) => pet.idthucung == idthucung);
        if (index != -1) {
          pets[index] = PetModel.fromJson(response['data']);
          filteredPets.assignAll(pets); // Cập nhật danh sách lọc nếu cần
        }
      } else {
        throw Exception(response?['message'] ?? 'Sửa thú cưng thất bại');
      }
    } catch (e) {
      print('🐞 Lỗi khi sửa thú cưng: $e');
      Utils.showSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> deletePet(String idthucung) async {
    try {
      isLoading.value = true;

      // Tạo dữ liệu body để gửi đi dưới dạng JSON
      Map<String, dynamic> body = {'idthucung': idthucung};

      // Gọi phương thức API POST với dữ liệu body
      final response = await APICaller.getInstance().post(
          'User/Thucung/xoathucung.php',
          body); // Dùng phương thức post thay vì delete

      if (response != null && response['success'] == true) {
        // Xóa thú cưng thành công, loại bỏ nó khỏi danh sách
        pets.removeWhere((pet) => pet.idthucung.toString() == idthucung);
        filteredPets.assignAll(pets); // Cập nhật lại danh sách filteredPets
        Get.snackbar('Thành công', 'Đã xóa thú cưng thành công!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Nếu có lỗi từ API, throw lỗi
        throw Exception(response['message'] ?? 'Xóa thú cưng thất bại');
      }
    } catch (e) {
      print('🐞 Lỗi khi xóa thú cưng: $e');
      Utils.showSnackBar(title: 'Lỗi', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
