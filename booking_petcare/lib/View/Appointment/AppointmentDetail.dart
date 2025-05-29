import 'package:flutter/material.dart';
import 'package:booking_petcare/Global/ColorHex.dart';
import 'package:booking_petcare/Utils/utils.dart';
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';

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
                          // xử lý gọi trung tâm
                        },
                        icon: Icon(Icons.call),
                        label: Text("Gọi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 66, 165, 9),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // xử lý xem thú cưng
                        },
                        icon: Icon(Icons.pets),
                        label: Text("Thú cưng"),
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
                      OutlinedButton.icon(
                        onPressed: () {
                          // Get.to(() => ReBookScreen(appointment: appointment));
                        },
                        icon: Icon(Icons.replay, color: ColorHex.main),
                        label: Text(
                          "Đặt lại",
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
