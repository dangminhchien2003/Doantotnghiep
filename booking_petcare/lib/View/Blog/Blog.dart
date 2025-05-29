import 'package:booking_petcare/Controller/Blog/BlogController.dart';
import 'package:booking_petcare/View/Blog/BlogDetail.dart';
import 'package:booking_petcare/Widgets/blog_item/blog_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_petcare/Model/Blog/BlogModel.dart';

class Blog extends StatelessWidget {
  const Blog({super.key});

  @override
  Widget build(BuildContext context) {
    final BlogController controller = Get.put(BlogController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tin tức & Blog',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm bài viết...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        controller.filterBlogs(query);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.blue),
                    onPressed: () {
                      print("Nút lọc được nhấn");
                    },
                  ),
                ],
              ),
            ),
          ),

          // Danh sách Blog
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Obx(() {
                if (controller.isLoadingBlogs.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredBlogs.isEmpty) {
                  return const Center(child: Text("Không có bài viết nào."));
                }

                return GridView.builder(
                  shrinkWrap:
                      true, // Thêm shrinkWrap để GridView không chiếm quá nhiều không gian
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Hiển thị 2 ô trong 1 dòng
                    crossAxisSpacing: 10, // Khoảng cách giữa các ô ngang
                    mainAxisSpacing: 10, // Khoảng cách giữa các ô dọc
                    childAspectRatio:
                        0.85, // Tỉ lệ chiều rộng/chiều cao của từng ô
                  ),
                  itemCount: controller.filteredBlogs.length,
                  itemBuilder: (context, index) {
                    final blog = controller.filteredBlogs[index];
                    print("🎯 Hiển thị blog: ${blog.tieuDe}"); // debug

                    return GestureDetector(
                      onTap: () {
                        // Điều hướng đến trang chi tiết blog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogDetail(blog: blog),
                          ),
                        );
                      },
                      child: BlogItem(
                        id: int.parse(blog.id),
                        tieu_de: blog.tieuDe,
                        noi_dung: blog.noiDung,
                        hinhanh: blog.hinhAnh,
                        createdAt: blog.createdAt,
                        updatedAt: blog.updatedAt,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
