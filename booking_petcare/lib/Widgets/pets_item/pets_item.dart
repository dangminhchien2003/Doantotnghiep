import 'package:flutter/material.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart'; // Đảm bảo đường dẫn này chính xác

class PetsItem extends StatelessWidget {
  final PetModel pet;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PetsItem({
    super.key,
    required this.pet,
    required this.onDelete,
    required this.onEdit,
  });

  Widget _buildPetDetailItem(
      BuildContext context, IconData iconData, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.87),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Đổi màu nền của Card tại đây
      color:
          const Color(0xFFF0F8FF), // Ví dụ: Màu AliceBlue (xanh dương rất nhạt)
      // Bạn cũng có thể thử các màu khác như:
      // color: Colors.grey.shade50, // Xám rất nhạt
      // color: Color(0xFFE3F2FD), // Blue.shade50 (nếu muốn đồng bộ hơn với avatar nhưng có thể cần điều chỉnh độ trong suốt)
      // color: Color(0xFFF5F9FC), // Một màu xanh pastel khác

      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar thú cưng
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  Colors.blue.shade50, // Giữ nguyên hoặc điều chỉnh nhẹ nếu cần
              child: Icon(Icons.pets, color: Colors.blue.shade700, size: 30),
            ),
            const SizedBox(width: 16),

            // Thông tin thú cưng
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.tenthucung ?? 'N/A',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.87),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  _buildPetDetailItem(context, Icons.category_outlined, 'Loài',
                      pet.loaithucung ?? 'N/A'),
                  _buildPetDetailItem(context, Icons.cake_outlined, 'Tuổi',
                      pet.tuoi?.toString() ?? 'N/A'),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Các nút chức năng
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.edit_note_outlined,
                        color: Colors.blue.shade700, size: 24),
                    onPressed: onEdit,
                    tooltip: 'Sửa',
                    splashRadius: 20,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 36,
                  height: 36,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.delete_outline,
                        color: Colors.red.shade600, size: 24),
                    onPressed: onDelete,
                    tooltip: 'Xóa',
                    splashRadius: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
