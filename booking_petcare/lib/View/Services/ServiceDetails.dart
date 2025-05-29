import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:flutter/material.dart';
import 'package:booking_petcare/Model/Services/ServicesModel.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';

class ServiceDetails extends StatelessWidget {
  final ServicesModel service;

  // Constructor nhận vào đối tượng dịch vụ để hiển thị
  const ServiceDetails({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // Sử dụng NumberFormat để định dạng giá tiền
    final NumberFormat currencyFormat = NumberFormat('#,##0', 'vi_VN');
    String formattedPrice = currencyFormat.format(service.price);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          'Dịch vụ: ${service.name}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh dịch vụ
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  service.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16.0),
              // Tên dịch vụ và giá
              Text(
                service.name,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Giá: ${formattedPrice} VND',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8.0),
              // Thời gian thực hiện dịch vụ
              Text(
                'Thời gian: ${service.duration}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              // Mô tả chi tiết dịch vụ
              Text(
                service.description.isNotEmpty
                    ? service.description
                    : 'Mô tả dịch vụ chưa có.',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Đặt hành động đặt dịch vụ ở đây, ví dụ như chuyển sang trang đặt lịch
            Get.to(() => Booking());
          },
          child: const Text('Đặt dịch vụ'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.blue,
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
