import 'package:flutter/material.dart';
// Bạn không cần import 'package:timeago/timeago.dart' nữa nếu dùng hàm tự viết này

class BlogItem extends StatelessWidget {
  final int id;
  final String tieu_de;
  final String noi_dung;
  final String hinhanh;
  final String createdAt;
  final String updatedAt;

  const BlogItem({
    super.key,
    required this.id,
    required this.tieu_de,
    required this.noi_dung,
    required this.hinhanh,
    required this.createdAt,
    required this.updatedAt,
  });

  // Hàm _formatTimeAgo đã được sửa đổi để nhận cả createdAt và updatedAt
  String _formatTimeAgo(String createdAtString, String updatedAtString) {
    DateTime? createdAtDT;
    DateTime? updatedAtDT;

    // Parse createdAtString
    if (createdAtString.isNotEmpty) {
      try {
        createdAtDT = DateTime.parse(createdAtString);
      } catch (e) {
        print('Error parsing createdAtString for _formatTimeAgo: $e');
      }
    }

    // Parse updatedAtString
    if (updatedAtString.isNotEmpty) {
      try {
        updatedAtDT = DateTime.parse(updatedAtString);
      } catch (e) {
        print('Error parsing updatedAtString for _formatTimeAgo: $e');
      }
    }

    DateTime? effectiveDate;

    // Quyết định ngày nào sẽ được sử dụng để hiển thị
    if (updatedAtDT != null && createdAtDT != null) {
      // Ưu tiên updatedAt nếu nó mới hơn createdAt (ví dụ, sau hơn 1 phút)
      if (updatedAtDT.isAfter(createdAtDT.add(const Duration(minutes: 1)))) {
        effectiveDate = updatedAtDT;
      } else {
        effectiveDate = createdAtDT;
      }
    } else {
      // Nếu chỉ có một trong hai ngày hợp lệ, sử dụng ngày đó
      effectiveDate = updatedAtDT ?? createdAtDT;
    }

    if (effectiveDate == null) {
      return 'Ngày không xác định';
    }

    // QUAN TRỌNG: Xử lý múi giờ trước khi tính difference
    // Giả sử effectiveDate từ API là UTC (ví dụ: "2023-10-27T10:00:00Z")
    // và DateTime.now() là giờ địa phương.
    DateTime comparableEffectiveDate;
    if (effectiveDate.isUtc) {
      comparableEffectiveDate =
          effectiveDate.toLocal(); // Chuyển UTC sang Local
    } else {
      // Nếu không phải UTC, giả sử nó đã là local hoặc có định dạng mà DateTime.parse xử lý đúng theo local
      comparableEffectiveDate = effectiveDate;
    }
    final now = DateTime.now(); // Giờ local hiện tại
    final difference = now.difference(comparableEffectiveDate);

    if (difference.isNegative) {
      if (difference.abs().inSeconds < 60) return 'Vừa xong';
      return '${comparableEffectiveDate.day.toString().padLeft(2, '0')}/${comparableEffectiveDate.month.toString().padLeft(2, '0')}/${comparableEffectiveDate.year}';
    }

    if (difference.inDays > 8) {
      return '${comparableEffectiveDate.day.toString().padLeft(2, '0')}/${comparableEffectiveDate.month.toString().padLeft(2, '0')}/${comparableEffectiveDate.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inSeconds >= 10) {
      return '${difference.inSeconds} giây trước';
    } else {
      return 'Vừa xong';
    }
  }

  Widget _buildTimeAgoWidget(BuildContext context) {
    // Bỏ tham số không cần thiết
    // Gọi hàm _formatTimeAgo với cả createdAt và updatedAt
    final String timeAgoDisplayString = _formatTimeAgo(createdAt, updatedAt);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 13,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            timeAgoDisplayString,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... (phần decoration giữ nguyên)
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh
          ClipRRect(
            // ... (phần hình ảnh giữ nguyên)
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(9.0)),
            child: Image.network(
              hinhanh,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 110,
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey.shade300,
                    size: 40,
                  ),
                );
              },
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height:
                      110, // << Bạn có thể đã sửa chiều cao này ở code của bạn
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor.withOpacity(0.7)),
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),

          // Phần nội dung text và tương tác
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.start, // Giữ các phần tử ở trên
                children: [
                  // Cụm Tiêu đề và Nội dung tóm tắt
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tieu_de,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        noi_dung,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const Spacer(), // Đẩy phần thời gian xuống dưới cùng
                  // SizedBox(
                  //   height: 10, // Bỏ SizedBox này nếu dùng Spacer
                  // ),

                  // Hàng chứa thời gian đăng
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0), // Hoặc bỏ padding này nếu Spacer là đủ
                    child: _buildTimeAgoWidget(context), // Gọi hàm helper ở đây
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
