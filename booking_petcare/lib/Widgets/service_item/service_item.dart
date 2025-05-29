import 'package:booking_petcare/Model/Services/ServicesModel.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final ServicesModel service;

  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFCA28),
                width: 2, // Độ dày của viền
              ),
            ),
            child: ClipOval(
              child: Image.network(
                service.imageUrl, // Đúng tên biến từ ServicesModel
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          // Thông tin dịch vụ
          Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 80, // Đặt chiều rộng cố định cho tên dịch vụ
              child: Text(
                service.name,
                textAlign: TextAlign.center,
                overflow:
                    TextOverflow.ellipsis, // Dấu ba chấm nếu văn bản dài quá
                maxLines: 1, // Giới hạn tối đa số dòng hiển thị
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
