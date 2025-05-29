import 'dart:async';
import 'package:booking_petcare/Model/Blog/BlogModel.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';

class BlogController extends GetxController {
  final RxList<BlogModel> blogs = <BlogModel>[].obs; // Danh sách blog gốc
  final RxList<BlogModel> filteredBlogs = <BlogModel>[].obs; // Blog đã lọc
  final RxBool isLoadingBlogs = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs(); // Gọi API khi controller được khởi tạo
  }

  // Hàm lấy danh sách blog từ API
  Future<void> fetchBlogs() async {
    try {
      isLoadingBlogs.value = true;
      print('📡 Gọi API getblogs.php...');

      var response =
          await APICaller.getInstance().get('User/Blogs/getblogs.php');

      if (response == null) {
        throw Exception('API trả về null');
      }

      if (response is List) {
        var parsedBlogs = response
            .map((e) {
              try {
                return BlogModel.fromJson(e);
              } catch (error) {
                print('❌ Lỗi parse JSON: $error với dữ liệu: $e');
                return null;
              }
            })
            .whereType<BlogModel>()
            .toList();

        blogs.assignAll(parsedBlogs);
        filteredBlogs.assignAll(parsedBlogs);
        print('✅ Đã load ${parsedBlogs.length} blogs');
      } else {
        throw Exception('Dữ liệu API không phải là danh sách');
      }
    } catch (e) {
      print('❌ Lỗi khi lấy blogs: $e');
      Utils.showSnackBar(
          title: 'Lỗi', message: 'Không thể tải danh sách blogs');
    } finally {
      isLoadingBlogs.value = false;
    }
  }

  // Hàm tìm kiếm blog theo từ khóa
  Future<void> filterBlogs(String query) async {
    if (query.isEmpty) {
      filteredBlogs.assignAll(blogs);
      return;
    }

    try {
      isLoadingBlogs.value = true;
      print('🔎 Gọi API tìm kiếm với query: $query');

      final response = await APICaller.getInstance().get(
          'User/Blogs/timkiemblog.php',
          queryParams: {"searchTerm": query});

      if (response == null || response is! List) {
        throw Exception('API tìm kiếm trả về null hoặc không đúng định dạng');
      }

      var parsedBlogs = response
          .map((e) {
            try {
              return BlogModel.fromJson(e);
            } catch (error) {
              print('❌ Lỗi parse JSON khi tìm kiếm: $error với dữ liệu: $e');
              return null;
            }
          })
          .whereType<BlogModel>()
          .toList();

      if (parsedBlogs.isEmpty) {
        Utils.showSnackBar(
            title: 'Không có kết quả',
            message: 'Không tìm thấy bài viết nào phù hợp');
      }

      filteredBlogs.assignAll(parsedBlogs);
    } catch (e) {
      print('❌ Lỗi khi tìm kiếm blogs: $e');
      Utils.showSnackBar(title: 'Lỗi', message: 'Không thể tìm kiếm blog');
    } finally {
      isLoadingBlogs.value = false;
    }
  }
}
