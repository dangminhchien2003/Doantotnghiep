import 'package:booking_petcare/Controller/Account/PersonalInformationController.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalInformation extends StatelessWidget {
  const PersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalInformationController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity, // Full width
        height: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/image.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Xử lý sửa hình ảnh tại đây
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên người dùng',
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 20, 20, 20),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      // Chỉ sử dụng Obx cho phần này để theo dõi sự thay đổi của name
                      Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(228, 230, 236, 1)),
                            ),
                            child: TextField(
                              controller: TextEditingController(
                                  text: controller.name
                                      .value), // Set giá trị ban đầu từ controller
                              onChanged: (value) => controller.name.value =
                                  value, // Cập nhật name.value
                              decoration: InputDecoration(
                                hintText: 'Tên người dùng',
                                prefixIcon: Icon(Icons.person_outline),
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(189, 189, 189, 1)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text(
                        'Email',
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 20, 20, 20),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      // Sử dụng Obx cho email
                      Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(228, 230, 236, 1)),
                            ),
                            child: TextField(
                              controller: TextEditingController(
                                  text: controller.email.value),
                              onChanged: (value) => controller.email.value =
                                  value, // Cập nhật email.value
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(189, 189, 189, 1)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text(
                        'Số điện thoại',
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 20, 20, 20),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      // Sử dụng Obx cho phone
                      Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(228, 230, 236, 1)),
                            ),
                            child: TextField(
                              controller: TextEditingController(
                                  text: controller.phone.value),
                              onChanged: (value) => controller.phone.value =
                                  value, // Cập nhật phone.value
                              decoration: InputDecoration(
                                hintText: 'Số điện thoại',
                                prefixIcon: Icon(Icons.phone_outlined),
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(189, 189, 189, 1)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )),
                      SizedBox(height: 16),
                      Text(
                        'Địa chỉ',
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 20, 20, 20),
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10),
                      // Sử dụng Obx cho address
                      Obx(() => Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromRGBO(228, 230, 236, 1)),
                            ),
                            child: TextField(
                              controller: TextEditingController(
                                  text: controller.address.value),
                              onChanged: (value) => controller.address.value =
                                  value, // Cập nhật address.value
                              decoration: InputDecoration(
                                hintText: 'Địa chỉ',
                                prefixIcon: Icon(Icons.location_on_outlined),
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(189, 189, 189, 1)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          )),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await controller.updateUser();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF0089FF), // Màu nền nút
                          padding: EdgeInsets.symmetric(
                              horizontal: 154, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cập nhật',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
