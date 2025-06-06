import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Widgets/PetDetailBottomSheet/PetDetailBottomSheetContent.dart';
import 'package:booking_petcare/Widgets/PrescriptionModalContentWidget/PrescriptionModalContentWidget.dart';
import 'package:flutter/material.dart';
import 'package:booking_petcare/Global/ColorHex.dart';
import 'package:booking_petcare/Utils/utils.dart';
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppointmentDetail extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentDetail({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int status = int.tryParse(appointment.trangthai.toString()) ?? -1;
    final String statusText = Utils.getAppointmentStatusText(status);
    final Color statusColor = Utils.getAppointmentStatusColor(status);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết lịch hẹn', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Ảnh minh họa
            ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Image.asset(
                'assets/images/lichhen.jpg',
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    title: 'Ngày hẹn',
                    value: appointment.ngayhen,
                  ),
                  _buildInfoCard(
                    icon: Icons.access_time,
                    title: 'Thời gian hẹn',
                    value: appointment.thoigianhen,
                  ),
                  _buildInfoCard(
                    icon: Icons.info,
                    title: 'Trạng thái',
                    value: statusText,
                    valueColor: statusColor,
                  ),
                  if (appointment.lydohuy != null &&
                      appointment.lydohuy.toString().isNotEmpty &&
                      status == 4)
                    _buildInfoCard(
                      icon: Icons.cancel,
                      title: 'Lý do huỷ',
                      value: appointment.lydohuy ?? '',
                      valueColor: Colors.redAccent,
                    ),
                  _buildInfoCard(
                    icon: Icons.event_note,
                    title: 'Ngày tạo',
                    value: appointment.ngaytao,
                  ),
                  _buildInfoCard(
                    icon: Icons.medical_services,
                    title: 'Dịch vụ',
                    value: appointment.dichvu.isNotEmpty
                        ? appointment.dichvu
                            .map((service) =>
                                service.tendichvu) // Lấy ra tên của mỗi dịch vụ
                            .join(', ') // Nối các tên lại với nhau
                        : 'Không có dịch vụ',
                  ),
                  if (appointment.idtrungtam != null)
                    _buildInfoCard(
                      icon: Icons.store,
                      title: 'Trung tâm',
                      value: '${appointment.tentrungtam}',
                    ),
                  if (appointment.idthucung != null)
                    _buildInfoCard(
                      icon: Icons.pets,
                      title: 'Thú cưng',
                      value: '${appointment.tenthucung}',
                    ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (appointment.idthucung != null &&
                              appointment.idthucung! != 0) {
                            final PetsController petsController =
                                Get.put(PetsController());

                            petsController
                                .fetchPetDetailsById(appointment.idthucung!);

                            // Hiển thị BottomSheet
                            Get.bottomSheet(
                              PetDetailBottomSheetContent(
                                  idthucung: appointment.idthucung!),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 250),
                              exitBottomSheetDuration:
                                  const Duration(milliseconds: 200),
                            );
                          } else {
                            // Thông báo nếu không có ID thú cưng
                            Utils.showSnackBar(
                              title: "Thông báo",
                              message:
                                  "Lịch hẹn này không liên kết với thú cưng nào.",
                              // isError: false // Hoặc true tùy bạn muốn
                            );
                          }
                        },
                        icon: Icon(
                          Icons.pets,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Thú cưng",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      if (status == 0)
                        OutlinedButton.icon(
                          onPressed: () {
                            _showCancelDialog(context);
                          },
                          icon: Icon(Icons.cancel, color: Colors.red),
                          label: Text(
                            "Huỷ lịch",
                            style: TextStyle(color: Colors.red),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      // Điều kiện hiển thị nút "Đơn thuốc"
                      if (status == 3 ||
                          status == 5 ||
                          status ==
                              6) // Hoàn thành, Đã thanh toán, Đang thanh toán
                        OutlinedButton.icon(
                          onPressed: () {
                            final AppointmentController controller =
                                Get.find<AppointmentController>();
                            // Đảm bảo appointment.idlichhen là int
                            controller.fetchPrescriptionDetails(
                                appointment.idlichhen);

                            Get.bottomSheet(
                              PrescriptionModalContentWidget(
                                  appointmentId: appointment.idlichhen),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 250),
                              exitBottomSheetDuration:
                                  const Duration(milliseconds: 200),
                            );
                          },
                          icon: Icon(Icons.receipt_long, color: ColorHex.main),
                          label: Text(
                            "Đơn thuốc",
                            style: TextStyle(color: ColorHex.main),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: ColorHex.main),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Xác nhận huỷ lịch"),
        content: Text("Bạn có chắc chắn muốn huỷ lịch hẹn này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Không"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Gọi API huỷ lịch, sau đó cập nhật lại UI nếu cần
              // controller.cancelAppointment(appointment.idlichhen);
            },
            child: Text("Huỷ lịch"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: ColorHex.main),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}
