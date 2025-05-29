import 'dart:async';
import 'package:booking_petcare/Model/Services/ServicesModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final RxList<ServicesModel> services = <ServicesModel>[].obs; // Dịch vụ gốc
  final RxList<ServicesModel> filteredServices =
      <ServicesModel>[].obs; // Dịch vụ đã lọc
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchServices(); // Lấy dịch vụ khi controller được khởi tạo
  }

  // Hàm lấy danh sách dịch vụ
  Future<void> fetchServices() async {
    try {
      isLoading.value = true;
      print('📡 Gọi API getdichvu.php...');

      var response =
          await APICaller.getInstance().get('User/Dichvu/getdichvu.php');

      if (response == null) {
        throw Exception('API trả về null');
      }

      if (response is List) {
        var parsedServices = response
            .map((e) {
              try {
                return ServicesModel.fromJson(e);
              } catch (error) {
                print('Lỗi parse JSON: $error với dữ liệu: $e');
                return null;
              }
            })
            .whereType<ServicesModel>()
            .toList();

        services.assignAll(parsedServices);
        filteredServices
            .assignAll(parsedServices); // Lưu dịch vụ vào filteredServices
      } else {
        throw Exception('Dữ liệu API không phải danh sách');
      }
    } catch (e) {
      print('Lỗi khi lấy dịch vụ: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể tải danh sách dịch vụ');
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm tìm kiếm dịch vụ
  void filterServices(String query) async {
    if (query.isEmpty) {
      // Nếu ô tìm kiếm rỗng, gán lại toàn bộ dịch vụ cho filteredServices
      filteredServices.assignAll(services);
      return;
    }

    try {
      isLoading.value = true;
      print('Gọi API tìm kiếm với query: $query');
      final response = await APICaller.getInstance()
          .get('User/Dichvu/timkiemdichvu.php?searchTerm=$query');

      if (response == null || response is! List) {
        throw Exception("API tìm kiếm trả về null");
      }

      var parsed = response.map((e) {
        return ServicesModel.fromJson(e);
      }).toList();

      // Cập nhật danh sách dịch vụ đã lọc
      filteredServices.assignAll(parsed);
    } catch (e) {
      print('Lỗi tìm kiếm dịch vụ: $e');
      Utils.showSnackBar(title: 'Lỗi', message: 'Không thể tìm kiếm dịch vụ');
    } finally {
      isLoading.value = false;
    }
  }
}
