import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Lấy theme hiện tại để sử dụng màu sắc

    return Container(
      // Sử dụng Container với BoxDecoration để tùy chỉnh viền và bóng đổ
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.0), // Viền nhẹ
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12), // Bóng đổ nhẹ nhàng hơn
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        // Giữ ClipRRect để đảm bảo nội dung bên trong cũng được bo tròn
        borderRadius: BorderRadius.circular(
            11.0), // Bo tròn bên trong nhỏ hơn viền một chút
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height:
                      120, // Giữ nguyên chiều cao ảnh hoặc điều chỉnh nếu cần
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Xử lý khi ảnh lỗi
                    return Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: Icon(Icons.broken_image_outlined,
                          color: Colors.grey.shade400, size: 40),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 120,
                      color: Colors.grey.shade100,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(theme.primaryColor),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),
                // Lớp phủ gradient vẫn giữ để đảm bảo icon yêu thích dễ nhìn hơn
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black
                            .withOpacity(0.0), // Bắt đầu trong suốt hơn ở trên
                        Colors.black.withOpacity(0.0), // Giữ trong suốt ở giữa
                        Colors.black
                            .withOpacity(0.4), // Đậm hơn ở dưới một chút
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [
                        0.0,
                        0.5,
                        1.0
                      ], // Điều chỉnh điểm dừng gradient
                    ),
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Material(
                    // Material để InkWell có hiệu ứng ripple đẹp và shape
                    color: Colors.black
                        .withOpacity(0.35), // Nền bán trong suốt cho icon
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20, // Kích thước icon có thể điều chỉnh
                      ),
                      padding:
                          const EdgeInsets.all(6.0), // Padding cho vùng chạm
                      constraints:
                          const BoxConstraints(), // Loại bỏ constraints mặc định
                      tooltip: 'Yêu thích',
                      onPressed: () {
                        // TODO: Xử lý sự kiện yêu thích
                        print('Favorite clicked for service: $title');
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  12.0, 10.0, 12.0, 8.0), // Điều chỉnh padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16, // Giữ nguyên hoặc 15 nếu muốn nhỏ hơn chút
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Cho phép tiêu đề 2 dòng
                  ),
                  const SizedBox(height: 6.0), // Tăng khoảng cách một chút
                  Text(
                    'Giá: ${Utils.formatCurrency(price)}', // Sử dụng Utils của bạn
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          theme.primaryColorDark, // Sử dụng màu chủ đạo đậm hơn
                      fontWeight: FontWeight.bold, // Làm đậm giá
                    ),
                  ),
                  const SizedBox(
                      height: 8.0), // Khoảng cách trước nút "Xem chi tiết"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onTap,
                      label: Text(
                        // Label giờ là text "Xem chi tiết"
                        'Xem chi tiết',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      icon: Icon(
                        // Icon giờ là mũi tên
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: theme.primaryColor,
                      ),
                      // THÊM DÒNG NÀY ĐỂ CHUYỂN ICON SANG PHẢI
                      iconAlignment: IconAlignment.end,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
