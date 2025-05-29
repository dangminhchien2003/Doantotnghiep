// notification_detail_sheet.dart
import 'package:booking_petcare/Model/Notification/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart'; // Nếu bạn cần Get trong sheet

class NotificationDetailSheet extends StatelessWidget {
  final NotificationModel
      notification; // Thay NotificationModel bằng model thực tế của bạn

  const NotificationDetailSheet({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Trang trí cho bottom sheet
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.7, // Giới hạn chiều cao tối đa của sheet
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh kéo (handle)
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Tiêu đề (nếu thông báo của bạn có tiêu đề riêng)
              // Text(
              //   notification.title ?? 'Chi tiết thông báo', // Giả sử có trường title
              //   style: const TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.blueAccent,
              //   ),
              // ),
              // const SizedBox(height: 10),

              // Nội dung HTML
              Html(
                data:
                    notification.noidung, // Giả sử trường nội dung là 'noidung'
                style: {
                  "body": Style(
                    fontSize: FontSize(15.0),
                    color: Colors.black87,
                    padding: HtmlPaddings.zero,
                    margin: Margins.zero,
                  ),
                  // Bạn có thể thêm các style khác cho các thẻ HTML cụ thể
                  "p": Style(lineHeight: LineHeight.em(1.5)),
                },
              ),
              const SizedBox(height: 15),

              // Thời gian tạo
              Row(
                children: [
                  Icon(Icons.access_time_rounded,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    // Bạn có thể cần hàm định dạng thời gian ở đây
                    // ví dụ: DateFormat('dd/MM/yyyy HH:mm').format(notification.thoigiantao),
                    'Thời gian: ${notification.thoigiantao}', // Giả sử có trường thoigiantao
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Đóng'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
