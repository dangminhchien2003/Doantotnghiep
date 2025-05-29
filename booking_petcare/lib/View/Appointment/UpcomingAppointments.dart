import 'dart:developer';
import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Appointment/UpcomingAppointmentController.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/View/Appointment/AppointmentDetail.dart';
import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpcomingAppointments extends StatelessWidget {
  final UpcomingAppointmentController controller =
      Get.put(UpcomingAppointmentController());
  // final AppointmentController controller = Get.find<AppointmentController>();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    // Cập nhật giá trị text ban đầu (nếu có)
    fromDateController.text = controller.fromDate.value != null
        ? Utils.formatDate(controller.fromDate.value!)
        : 'Chọn ngày bắt đầu';
    toDateController.text = controller.toDate.value != null
        ? Utils.formatDate(controller.toDate.value!)
        : 'Chọn ngày kết thúc';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch hẹn sắp tới'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Thanh chọn ngày
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fromDateController,
                    readOnly: true,
                    onTap: () => _pickDate(context, true),
                    decoration: InputDecoration(
                      labelText: "Từ ngày",
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: toDateController,
                    readOnly: true,
                    onTap: () => _pickDate(context, false),
                    decoration: InputDecoration(
                      labelText: "Đến ngày",
                      prefixIcon: const Icon(Icons.date_range),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // Danh sách lịch hẹn
          Expanded(
            child: Obx(() {
              if (controller.isLoadingAppointments.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredAppointments.isEmpty) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFFFC107), width: 1.2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_busy,
                            size: 40, color: Colors.orange),
                        const SizedBox(height: 10),
                        const Text(
                          "Bạn chưa có lịch hẹn nào.",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () => Get.to(() => Booking()),
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text("Đặt lịch ngay"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC107),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredAppointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final appt = controller.filteredAppointments[index];
                  final statusText =
                      Utils.getAppointmentStatusText(appt.trangthai);
                  final statusColor =
                      Utils.getAppointmentStatusColor(appt.trangthai);

                  return GestureDetector(
                    onTap: () =>
                        Get.to(() => AppointmentDetail(appointment: appt)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.asset(
                              'assets/images/lichhen.jpg',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Ngày & giờ
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 6),
                                        Text(appt.ngayhen),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            size: 16, color: Colors.blueGrey),
                                        const SizedBox(width: 4),
                                        Text(appt.thoigianhen),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Trạng thái
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 16, color: statusColor),
                                    const SizedBox(width: 6),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Get.to(() =>
                                          AppointmentDetail(appointment: appt));
                                    },
                                    icon: const Icon(Icons.visibility_outlined,
                                        size: 18),
                                    label: const Text("Chi tiết"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blueAccent,
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: isFromDate ? 'Chọn ngày bắt đầu' : 'Chọn ngày kết thúc',
    );

    if (picked != null) {
      String formatted = Utils.formatDate(picked);
      if (isFromDate) {
        fromDateController.text = formatted;
        controller.setFromDate(picked);
      } else {
        toDateController.text = formatted;
        controller.setToDate(picked);
      }
    }
  }
}
