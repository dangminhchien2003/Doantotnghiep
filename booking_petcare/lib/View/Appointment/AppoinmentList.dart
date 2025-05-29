import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:booking_petcare/View/Payment/Payment.dart';
import 'package:booking_petcare/Widgets/PrescriptionModalContentWidget/PrescriptionModalContentWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppointmentList extends StatelessWidget {
  final AppointmentController controller = Get.put(AppointmentController());
  final RxInt selectedTabIndex = 0.obs;

  AppointmentList({super.key});

  final List<Map<String, dynamic>> tabs = [
    {'status': 0, 'label': 'Đang chờ'},
    {'status': 1, 'label': 'Đã xác nhận'},
    {'status': 2, 'label': 'Đang thực hiện'},
    {'status': 3, 'label': 'Hoàn thành'},
    {'status': 6, 'label': 'Đang thanh toán'},
    {'status': 5, 'label': 'Đã thanh toán'},
    {'status': 4, 'label': 'Đã hủy'},
  ];

  IconData getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.hourglass_empty;
      case 1:
        return Icons.event_available;
      case 2:
        return Icons.work_history;
      case 3:
        return Icons.check_circle;
      case 6:
        return Icons.pending_actions;
      case 5:
        return Icons.attach_money;
      case 4:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lịch hẹn', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Custom TabBar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(tabs.length, (index) {
                        final isSelected = selectedTabIndex.value == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              selectedTabIndex.value = index;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                tabs[index]['label'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )),
          ),

          // Nội dung theo tab
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Gọi hàm tải lại dữ liệu từ Controller
                await controller.fetchAllAppointments();
              },
              child: Obx(() {
                if (controller.isLoadingAppointments.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final selectedStatus = tabs[selectedTabIndex.value]['status'];
                final selectedLabel = tabs[selectedTabIndex.value]['label'];

                final filtered = controller.appointments
                    .where((appt) => appt.trangthai == selectedStatus)
                    .toList();

                // if (filtered.isEmpty) {
                //   return const Center(child: Text('Không có lịch hẹn nào.'));
                // }
                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Không có lịch hẹn nào.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54, // Màu chữ tùy chỉnh
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add_circle_outline,
                                color: Colors.white),
                            label: const Text('ĐẶT LỊCH NGAY',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Màu nút của bạn
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // Bo góc cho nút
                              ),
                            ),
                            onPressed: () {
                              Get.to(() => Booking());
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final appointment = filtered[index];
                    final statusColor =
                        Utils.getAppointmentStatusColor(appointment.trangthai);
                    final statusIcon = getStatusIcon(appointment.trangthai);

                    return Card(
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.3),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER
                            Container(
                              padding: const EdgeInsets.only(bottom: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#${appointment.idlichhen}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: statusColor, width: 0.6),
                                    ),
                                    child: Row(children: [
                                      Icon(
                                        statusIcon,
                                        color: statusColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        selectedLabel,
                                        style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // BODY
                            Column(
                              children: [
                                _buildIconDetailRow(
                                    Icons.pets,
                                    'Tên thú cưng:',
                                    appointment.tenthucung.isNotEmpty
                                        ? appointment.tenthucung
                                        : 'Chưa có tên'),
                                _buildIconDetailRow(
                                    Icons.storefront,
                                    'Trung tâm:',
                                    appointment.tentrungtam.isNotEmpty
                                        ? appointment.tentrungtam
                                        : '---'),
                                Obx(() => appointment.isExpanded.value
                                    ? Column(
                                        children: [
                                          _buildIconDetailRow(
                                              Icons.calendar_today,
                                              'Ngày hẹn:',
                                              appointment.ngayhen),
                                          _buildIconDetailRow(
                                              Icons.access_time,
                                              'Giờ hẹn:',
                                              appointment.thoigianhen),
                                          _buildIconDetailRow(
                                            Icons.design_services,
                                            'Dịch vụ:',
                                            appointment.dichvu.isNotEmpty
                                                ? appointment.dichvu
                                                    .map((service) =>
                                                        service.tendichvu)
                                                    .join(', ')
                                                : 'Không có dịch vụ',
                                          ),
                                          //đơn thuốc
                                          if (appointment.trangthai == 3 ||
                                              appointment.trangthai == 5 ||
                                              appointment.trangthai == 6)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: const [
                                                      Icon(
                                                          Icons
                                                              .medical_services,
                                                          size: 18,
                                                          color:
                                                              Colors.blueGrey),
                                                      SizedBox(width: 6),
                                                      Text(
                                                        'Đơn thuốc:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  OutlinedButton.icon(
                                                    icon: const Icon(
                                                        Icons.receipt_long,
                                                        size: 14),
                                                    label: const Text(
                                                      'Xem đơn',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      foregroundColor:
                                                          Colors.teal,
                                                      side: const BorderSide(
                                                          color: Colors.teal,
                                                          width: 1),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      visualDensity:
                                                          VisualDensity(
                                                              horizontal: -3,
                                                              vertical: -3),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      minimumSize: Size.zero,
                                                    ),
                                                    onPressed: () {
                                                      // 1. Gọi hàm fetchPrescriptionDetails để tải dữ liệu
                                                      //    Hàm này sẽ tự động cập nhật selectedPrescription, isLoadingPrescription, prescriptionError
                                                      controller
                                                          .fetchPrescriptionDetails(
                                                              appointment
                                                                  .idlichhen);

                                                      // 2. Hiển thị BottomSheet với nội dung từ PrescriptionModalContentWidget
                                                      Get.bottomSheet(
                                                        PrescriptionModalContentWidget(
                                                            appointmentId:
                                                                appointment
                                                                    .idlichhen),
                                                        backgroundColor: Colors
                                                            .transparent, // Để widget con tự quản lý màu nền và bo góc
                                                        isScrollControlled:
                                                            true, // Quan trọng: cho phép BottomSheet có chiều cao linh động theo nội dung, tối đa là chiều cao màn hình
                                                        enterBottomSheetDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    250), // Tùy chỉnh animation
                                                        exitBottomSheetDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (appointment.trangthai ==
                                              4) // Kiểm tra nếu trạng thái là Đã hủy
                                            _buildIconDetailRow(
                                              Icons
                                                  .info_outline, // Icon cho lý do hủy
                                              'Lý do hủy:',
                                              appointment.lydohuy != null &&
                                                      appointment
                                                          .lydohuy!.isNotEmpty
                                                  ? appointment.lydohuy!
                                                  : 'Không có thông tin.', // Hiển thị nếu không có lý do
                                            ),
                                        ],
                                      )
                                    : const SizedBox()),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ACTIONS
                            if (appointment.trangthai == 0)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    _showCancelConfirmation(
                                        context, appointment.idlichhen);
                                  },
                                  label: const Text('Hủy lịch hẹn',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            if (appointment.trangthai == 3)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.payment,
                                      color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() =>
                                        Payment(appointment: appointment));
                                  },
                                  label: const Text('Thanh toán ngay',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),

                            const SizedBox(height: 5),
                            const Divider(thickness: 0.5, color: Colors.grey),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Obx(() => TextButton.icon(
                                    onPressed: () {
                                      appointment.isExpanded.toggle();
                                    },
                                    icon: Icon(appointment.isExpanded.value
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down),
                                    label: Text(appointment.isExpanded.value
                                        ? 'Thu gọn'
                                        : 'Xem thêm'),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

void _showCancelConfirmation(BuildContext context, int appointmentId) {
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Xác nhận hủy lịch hẹn'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: 'Lý do hủy',
              hintText: 'Nhập lý do hủy...',
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Đóng dialog
          child: const Text('Không'),
        ),
        TextButton(
          onPressed: () {
            final cancelReason = reasonController.text.trim();
            if (cancelReason.isEmpty) {
              Utils.showSnackBar(
                  title: 'Thông báo', message: 'Lý do hủy không thể để trống!');
            } else {
              Navigator.pop(context); // Đóng dialog
              _cancelAppointment(appointmentId, cancelReason);
            }
          },
          child: const Text(
            'Hủy lịch',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

void _cancelAppointment(int appointmentId, String cancelReason) {
  final AppointmentController controller = Get.find<AppointmentController>();
  controller.cancelAppointment(
      appointmentId, cancelReason); // Gọi hàm hủy lịch và truyền lý do
}

Widget _buildIconDetailRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.blueGrey),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    ),
  );
}
