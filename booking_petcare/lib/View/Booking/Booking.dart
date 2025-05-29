import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Booking/BookingController.dart';
import 'package:booking_petcare/Controller/Center/CenterController.dart';
import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/Widgets/ServiceModal_Booking/ServiceModalContent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Booking extends StatelessWidget {
  // final BookingController controller = Get.put(BookingController());
  final AppointmentController controller = Get.put(AppointmentController());
  final CenterController centerController = Get.put(CenterController());
  final ServiceController serviceController = Get.put(ServiceController());
  final PetsController petsController = Get.put(PetsController());

  Booking({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Đặt lịch chăm sóc',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Thông tin trung tâm và người dùng
              Obx(() {
                if (centerController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (centerController.center.value == null) {
                  return const Center(
                      child: Text('Không có thông tin trung tâm'));
                }
                final center = centerController.center.value!;
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "🏢 Trung tâm: ${center.tentrungtam}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "📍 Địa chỉ: ${center.diachi}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "📞 Số điện thoại: ${center.sodienthoai}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // Chọn thú cưng
              const Text(
                "🐾 Chọn thú cưng",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(() => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.selectedPet.value.isEmpty
                            ? null
                            : controller.selectedPet.value,
                        hint: const Text('Chọn thú cưng'),
                        items: petsController.pets.map((pet) {
                          return DropdownMenuItem<String>(
                            value: pet.idthucung
                                .toString(), // dùng idthucung làm value
                            child: Text(pet.tenthucung),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedPet.value = value ?? '';
                        },
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // Chọn dịch vụ
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "🛁 Dịch vụ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list_alt_rounded),
                    label: Obx(() => Text(controller.selectedServiceIds.isEmpty
                        ? 'Chọn dịch vụ'
                        : 'Đã chọn ${controller.selectedServiceIds.length} dịch vụ')),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.white, // Màu nền
                      foregroundColor: Colors.blue, // Màu chữ và icon
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.blue)),
                    ),
                    onPressed: () {
                      Get.bottomSheet(
                        const ServiceModalContent(),
                        backgroundColor: Colors.white,
                        isScrollControlled: true, // Cho phép nội dung dài hơn
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                      );
                    },
                  ),
                  // Hiển thị tên các dịch vụ đã chọn (tùy chọn)
                  Obx(() {
                    if (controller.selectedServiceIds.isNotEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Đã chọn: ${controller.getSelectedServiceNames()}",
                          style: const TextStyle(color: Colors.black54),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
              const SizedBox(height: 24),

              // Chọn ngày
              const Text(
                "🗓️ Ngày hẹn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        controller.selectedDate.value = picked;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy')
                              .format(controller.selectedDate.value)),
                          const Icon(Icons.calendar_today, color: Colors.blue),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // Chọn giờ
              const Text(
                "⏰ Giờ hẹn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: () async {
                      DateTime now = DateTime.now();
                      DateTime selectedDate = controller
                          .selectedDate.value; // Ngày đã chọn từ DatePicker

                      TimeOfDay initialTimeForPicker =
                          controller.selectedTime.value;
                      bool isSelectedDateToday =
                          selectedDate.year == now.year &&
                              selectedDate.month == now.month &&
                              selectedDate.day == now.day;

                      if (isSelectedDateToday) {
                        TimeOfDay currentTimeOfDay =
                            TimeOfDay.fromDateTime(now);
                        // Nếu giờ hiện tại trong controller đã là quá khứ so với giờ thực tế,
                        // thì đặt initialTime cho picker là giờ thực tế
                        if ((controller.selectedTime.value.hour <
                                currentTimeOfDay.hour) ||
                            (controller.selectedTime.value.hour ==
                                    currentTimeOfDay.hour &&
                                controller.selectedTime.value.minute <
                                    currentTimeOfDay.minute)) {
                          initialTimeForPicker = currentTimeOfDay;
                        }
                      }

                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime:
                            initialTimeForPicker, // Sử dụng initialTime đã được điều chỉnh
                      );

                      if (picked != null) {
                        // Kiểm tra tính hợp lệ của giờ đã chọn
                        if (isSelectedDateToday) {
                          // Tạo đối tượng DateTime từ ngày đã chọn và giờ vừa pick
                          DateTime pickedDateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            picked.hour,
                            picked.minute,
                          );

                          // So sánh với thời điểm hiện tại (chỉ cần chính xác đến phút)
                          // DateTime currentDateTimeForComparison = DateTime(now.year, now.month, now.day, now.hour, now.minute);
                          // Thực ra so sánh trực tiếp với "now" là đủ, vì pickedDateTime đã bao gồm ngày
                          // và chúng ta chỉ quan tâm khi isSelectedDateToday = true

                          if (pickedDateTime.isBefore(now)) {
                            // Nếu giờ đã chọn là trong quá khứ của ngày hôm nay

                            Get.snackbar(
                              'Giờ không hợp lệ',
                              'Vui lòng chọn một giờ trong tương lai cho ngày hôm nay.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );

                            return; // Không cập nhật giờ
                          }
                        }
                        // Nếu hợp lệ (ngày tương lai, hoặc ngày hôm nay nhưng giờ hợp lệ)
                        controller.selectedTime.value = picked;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(controller.selectedTime.value.format(context)),
                          const Icon(Icons.access_time, color: Colors.blue),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              Obx(() => Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thông tin đặt lịch',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text('👤 Người dùng: ${controller.userName.value}'),
                          Text(
                              '📞 Số điện thoại: ${controller.phoneNumber.value}'),
                          Text('🏠 Địa chỉ: ${controller.address.value}'),
                          const Divider(height: 24, thickness: 1),
                          Text(
                              '🐾 Thú cưng: ${controller.getSelectedPetName()}'),
                          Text(
                              '🛁 Dịch vụ: ${controller.getSelectedServiceNames()}'),
                          Text(
                              '🗓️ Ngày: ${DateFormat('dd/MM/yyyy').format(controller.selectedDate.value)}'),
                          Text(
                              '⏰ Giờ: ${controller.selectedTime.value.format(Get.context!)}'),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // Nút đặt lịch
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.check,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Đặt lịch ngay',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Xác nhận đặt lịch'),
                          content: const Text(
                              'Bạn có chắc chắn muốn đặt lịch hẹn này không?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Hủy'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Xác nhận'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        bool success = await controller
                            .submitBooking(); // submitBooking sẽ trả về true nếu hợp lệ

                        if (success) {
                          await Future.delayed(const Duration(seconds: 2));
                          Get.offNamed('/appointmentList');
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
