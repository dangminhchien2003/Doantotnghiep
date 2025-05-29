import 'package:booking_petcare/Controller/Home/HomeController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/View/Services/ServiceDetails.dart';
import 'package:booking_petcare/Widgets/ServiceCard/ServiceCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:booking_petcare/Model/Services/ServicesModel.dart';

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo HomeController
    final ServiceController controller = Get.put(ServiceController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Dịch vụ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm cố định ở phía trên
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
                  // TextField cho việc tìm kiếm
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm dịch vụ...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        controller.filterServices(
                            query); // Gọi hàm lọc dịch vụ khi người dùng nhập
                      },
                    ),
                  ),
                  // Nút lọc bên phải
                  IconButton(
                    icon: const Icon(
                      Icons.filter_list,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      print("Nút lọc được nhấn");
                    },
                  ),
                ],
              ),
            ),
          ),
          // Hiển thị danh sách dịch vụ
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredServices.isEmpty) {
                return const Center(child: Text("Không có dịch vụ"));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  crossAxisSpacing: 16.0, // khoảng cách giữa các cột
                  mainAxisSpacing: 16.0, // khoảng các giữa các hàng
                  childAspectRatio: 0.75,
                ),
                itemCount: controller.filteredServices.length,
                itemBuilder: (context, index) {
                  final service = controller.filteredServices[index];
                  return ServiceCard(
                    title: service.name,
                    price: service.price,
                    imageUrl: service.imageUrl,
                    onTap: () {
                      Get.to(() => ServiceDetails(
                          service: service)); // Điều hướng tới chi tiết
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
