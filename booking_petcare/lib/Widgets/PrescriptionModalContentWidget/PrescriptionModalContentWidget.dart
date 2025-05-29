import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Model/Prescription/PrescriptionModel.dart'; // Model Prescription của bạn
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionModalContentWidget extends StatelessWidget {
  // Lấy instance của AppointmentController đã được Get.put() ở AppointmentList
  final AppointmentController controller = Get.find<AppointmentController>();
  final int appointmentId; // Để hiển thị ID lịch hẹn trong modal

  PrescriptionModalContentWidget({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    // Sử dụng màu sắc từ Theme cho nhất quán
    final ThemeData theme = Theme.of(context);
    final Color primaryColor =
        theme.primaryColor; // Ví dụ: Colors.blue từ theme của bạn
    final Color accentColor = theme.colorScheme.secondary; // Ví dụ: Colors.teal
    final Color errorColor = theme.colorScheme.error; // Ví dụ: Colors.red

    return Container(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // Giới hạn chiều cao tối đa của modal
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Quan trọng để BottomSheet có chiều cao vừa đủ nội dung
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Thanh kéo và nút đóng (cho BottomSheet) ---
            Center(
              child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn thuốc LH #${appointmentId}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade700),
                  onPressed: () => Get.back(), // Đóng modal
                  tooltip: 'Đóng',
                )
              ],
            ),
            const Divider(thickness: 1, height: 16),

            // --- Nội dung đơn thuốc (phần phản ứng với thay đổi) ---
            Expanded(
              child: Obx(() {
                // Sử dụng Obx để lắng nghe thay đổi từ controller
                if (controller.isLoadingPrescription.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Xử lý lỗi từ API hoặc không có đơn thuốc
                // Kiểm tra cả `prescriptionError.value` và `selectedPrescription.value`
                final prescription = controller.selectedPrescription.value;
                if (prescription == null ||
                    controller.prescriptionError.value != null) {
                  // Cải thiện thông báo lỗi nếu có lỗi cụ thể từ backend
                  final String displayMessage =
                      controller.prescriptionError.value ??
                          'Không có đơn thuốc cho lịch hẹn này.';
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Colors.blueGrey.shade400,
                              size: 48), // Icon thông báo
                          const SizedBox(height: 12),
                          Text(
                            displayMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 18),
                          // Nút thử lại nếu đây là lỗi server hoặc lỗi mạng
                          if (controller.prescriptionError.value != null &&
                              controller.prescriptionError.value !=
                                  'Không tìm thấy đơn thuốc cho lịch hẹn này')
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh, size: 20),
                              label: const Text('Thử lại'),
                              onPressed: () => controller
                                  .fetchPrescriptionDetails(appointmentId),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                // Tính tổng tiền
                double totalPrice = 0;
                for (var detail in prescription.chitiet) {
                  // Sử dụng trực tiếp detail.giaban và detail.soluong vì chúng đã là kiểu số
                  totalPrice += (detail.giaban * detail.soluong);
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 5.0), // Cho phép cuộn nếu nội dung dài
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                          context,
                          Icons.calendar_month_outlined,
                          'Ngày lập:',
                          // Xử lý trường hợp ngaylap có thể null trước khi parse
                          prescription.ngaylap != null
                              ? Utils.formatDate(
                                  DateTime.parse(prescription.ngaylap!))
                              : 'Không xác định'),
                      if (prescription.ghichu != null &&
                          prescription.ghichu!.isNotEmpty)
                        _buildInfoRow(context, Icons.sticky_note_2_outlined,
                            'Ghi chú:', prescription.ghichu!),
                      const SizedBox(height: 16),
                      Text(
                        'Chi tiết thuốc:',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600, color: primaryColor),
                      ),
                      const SizedBox(height: 8),
                      if (prescription.chitiet.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Text('Đơn này không có thuốc nào.',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        )
                      else
                        ListView.separated(
                          shrinkWrap:
                              true, // Quan trọng khi ListView trong SingleChildScrollView/Column
                          physics:
                              const NeverScrollableScrollPhysics(), // Tắt scroll của ListView nội
                          itemCount: prescription.chitiet.length,
                          itemBuilder: (ctx, index) {
                            final detail = prescription.chitiet[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${detail.tenthuoc}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.5,
                                          color: Colors.black87),
                                    ),
                                    const SizedBox(height: 6),
                                    _buildDetailText(
                                        'Liều dùng: ${detail.lieudung}'),
                                    // Sử dụng trực tiếp detail.soluong
                                    _buildDetailText(
                                        'Số lượng: ${detail.soluong} ${detail.donvitinh}'),
                                    // Sử dụng trực tiếp detail.giaban
                                    _buildDetailText(
                                        'Đơn giá: ${Utils.formatCurrency(detail.giaban)} / ${detail.donvitinh}'),
                                    _buildDetailText(
                                        'Thành tiền: ${Utils.formatCurrency(detail.giaban * detail.soluong)}',
                                        isAmount: true),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (ctx, index) =>
                              const SizedBox(height: 4),
                        ),
                      if (prescription.chitiet.isNotEmpty) ...[
                        const Divider(height: 24, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('TỔNG CỘNG:',
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: accentColor)),
                            Text(
                              Utils.formatCurrency(totalPrice),
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height: 10), // Thêm khoảng trống ở cuối nếu cần
                      ]
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Widget con để hiển thị thông tin chung của đơn thuốc (có icon)
  Widget _buildInfoRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 20,
              color: Theme.of(context).primaryColorDark.withOpacity(0.8)),
          const SizedBox(width: 10),
          Text('$label ',
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14.5, color: Colors.black87),
              softWrap: true, // Cho phép xuống dòng nếu dài
            ),
          ),
        ],
      ),
    );
  }

  // Widget con để hiển thị chi tiết từng loại thuốc
  Widget _buildDetailText(String text, {bool isAmount = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 2.5, bottom: 2.5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isAmount
              ? Colors.deepOrange.shade700
              : Colors.black.withOpacity(0.75),
          fontWeight: isAmount ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}
