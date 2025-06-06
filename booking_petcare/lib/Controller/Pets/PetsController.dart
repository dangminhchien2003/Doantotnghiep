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

  //Các biến cho việc hiển thị chi tiết một thú cưng ===
  final Rx<PetModel?> selectedPetDetail = Rx<PetModel?>(null);
  final RxBool isLoadingSelectedPetDetail = false.obs;
  final RxString selectedPetDetailError = ''.obs;

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

  //Hàm tải chi tiết một thú cưng bằng ID
  // Hàm tải chi tiết một thú cưng bằng ID
  Future<void> fetchPetDetailsById(int petId) async {
    // Nhận petId kiểu int
    if (petId == 0) {
      // Giả sử 0 là ID không hợp lệ
      selectedPetDetailError.value = "ID thú cưng không hợp lệ.";
      selectedPetDetail.value = null;
      isLoadingSelectedPetDetail.value = false;
      return;
    }
    try {
      isLoadingSelectedPetDetail.value = true;
      selectedPetDetailError.value = ''; // Xóa lỗi cũ
      selectedPetDetail.value = null; // Xóa dữ liệu cũ

      // QUAN TRỌNG: Đảm bảo tên endpoint này ("User/Thucung/getdetailthucung.php")
      // khớp CHÍNH XÁC với tên file PHP trên server của bạn.
      // Dựa trên log lỗi của bạn, nó đang là "getdetailthucung.php".
      // Nếu file PHP bạn tạo là "getthucungbyid.php", hãy sửa lại đây hoặc tên file trên server.
      final String apiEndpoint =
          "User/Thucung/getdetailthucung.php"; // HOẶC "User/Thucung/getthucungbyid.php"

      debugPrint('📡 Gọi API $apiEndpoint cho ID: $petId');

      // APICaller.get() sẽ trả về phần "data" nếu thành công, hoặc null nếu có lỗi (và đã hiện SnackBar)
      var petDataFromCaller = await APICaller.getInstance().get(
        apiEndpoint,
        queryParams: {
          "idthucung":
              petId.toString() // API thường nhận ID dạng String trong query
        },
      );

      if (petDataFromCaller != null) {
        // Nếu petDataFromCaller không null, nó chính là phần "data" từ JSON response
        if (petDataFromCaller is Map<String, dynamic>) {
          // Kiểm tra xem Map có rỗng không, vì "data": {} cũng là JSON hợp lệ
          if (petDataFromCaller.isNotEmpty) {
            selectedPetDetail.value = PetModel.fromJson(petDataFromCaller);
            debugPrint(
                '🐶 Chi tiết thú cưng tải và parse thành công cho ID: $petId');
          } else {
            // API trả về {"error": {"code": 0, ...}, "data": {}}
            selectedPetDetailError.value =
                "Không tìm thấy thông tin chi tiết cho thú cưng này (dữ liệu trống từ API).";
            debugPrint(
                'ℹ️ API trả về "data" rỗng cho thú cưng ID: $petId. Response từ APICaller: $petDataFromCaller');
          }
        } else {
          // Trường hợp APICaller.get() trả về "data" nhưng không phải là Map<String, dynamic>
          // (ví dụ: trả về một List nếu API get by ID thiết kế sai)
          selectedPetDetailError.value =
              "Dữ liệu chi tiết thú cưng nhận được có định dạng không mong muốn.";
          debugPrint(
              '❌ Dữ liệu API (phần "data") không phải là Map cho ID: $petId. Kiểu dữ liệu thực tế: ${petDataFromCaller.runtimeType}, Dữ liệu: $petDataFromCaller');
        }
      } else {
        // APICaller.get() đã trả về null, nghĩa là có lỗi xảy ra và APICaller đã hiển thị SnackBar.
        // Bạn có thể muốn đặt một thông báo lỗi chung ở đây để UI có thể cập nhật nếu cần,
        // hoặc để selectedPetDetailError trống vì SnackBar đã thông báo rồi.
        // Đặt lỗi ở đây giúp UI (ví dụ BottomSheet) có thể hiển thị thông báo lỗi thay vì kẹt ở trạng thái loading hoặc hiển thị dữ liệu cũ.
        selectedPetDetailError.value =
            "Không thể tải chi tiết thú cưng. Vui lòng kiểm tra thông báo hoặc thử lại.";
        debugPrint(
            '❌ APICaller.get() trả về null cho ID: $petId. Lỗi có thể đã được hiển thị qua SnackBar bởi APICaller.');
      }
    } catch (e, stackTrace) {
      // Bắt các lỗi ngoại lệ khác (ví dụ từ PetModel.fromJson nếu dữ liệu không đúng cấu trúc)
      debugPrint(
          '❌ Lỗi nghiêm trọng trong fetchPetDetailsById: $e\n$stackTrace');
      selectedPetDetailError.value =
          "Đã xảy ra lỗi khi xử lý thông tin thú cưng.";
    } finally {
      isLoadingSelectedPetDetail.value = false;
    }
  }

// Hàm xóa chi tiết thú cưng đã chọn ===
  void clearSelectedPetDetails() {
    selectedPetDetail.value = null;
    isLoadingSelectedPetDetail.value = false;
    selectedPetDetailError.value = '';
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
