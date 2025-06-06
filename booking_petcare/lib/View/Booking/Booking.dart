import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Booking/BookingController.dart';
import 'package:booking_petcare/Controller/Center/CenterController.dart';
import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/View/Pets/AddPets.dart';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Căn giữa các item theo chiều dọc
                children: [
                  const Text(
                    "🐾 Chọn thú cưng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add,
                        size: 20, color: Colors.blue), // Icon dấu cộng
                    label: const Text(
                      "Thêm mới",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.normal),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4), // Điều chỉnh padding cho nhỏ gọn
                      minimumSize:
                          Size.zero, // Cho phép nút co lại theo nội dung
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // Giảm vùng chạm thừa
                    ),
                    onPressed: () {
                      Get.to(() => Addpets());
                    },
                  ),
                ],
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
                        lastDate: DateTime.now().add(const Duration(days: 14)),
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

              //  Phần Chọn giờ - dùng Wrap các ChoiceChip
              const Text(
                "⏰ Giờ hẹn",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.displayableTimeSlots.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      controller.selectedDate.value.isBefore(DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day))
                          ? 'Vui lòng chọn ngày hiện tại hoặc tương lai.'
                          : 'Không có khung giờ làm việc cho ngày này.',
                      style: TextStyle(color: Colors.orange[700]),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                bool hasAnySelectableSlots = controller.displayableTimeSlots
                    .any((slot) => slot.isSelectable);

                if (!hasAnySelectableSlots) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      'Tất cả các khung giờ cho ngày này đã được đặt hoặc đã qua. Vui lòng thử ngày khác.',
                      style: TextStyle(color: Colors.orange[700]),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: controller.displayableTimeSlots.map((slotInfo) {
                    final TimeOfDay time = slotInfo.time;
                    final bool isCurrentlySelected =
                        controller.selectedTime.value?.hour == time.hour &&
                            controller.selectedTime.value?.minute ==
                                time.minute;
                    final bool isSelectable = slotInfo.isSelectable;

                    Color chipBackgroundColor;
                    Color labelColor;
                    TextDecoration labelDecoration = TextDecoration.none;
                    BorderSide borderSide;
                    String suffix = "";
                    double elevation = 0;

                    if (isCurrentlySelected && isSelectable) {
                      chipBackgroundColor = Colors.blue;
                      labelColor = Colors.white;
                      borderSide = BorderSide(color: Colors.blue);
                      elevation = 2;
                    } else if (!isSelectable) {
                      chipBackgroundColor = Colors.grey.shade300;
                      labelColor = Colors.grey.shade500;
                      labelDecoration = TextDecoration.lineThrough;
                      borderSide = BorderSide(color: Colors.grey.shade300);
                      if (slotInfo.isBooked) suffix = " (Đã đặt)";
                    } else {
                      chipBackgroundColor = Colors.grey[200]!;
                      labelColor = Colors.black87;
                      borderSide = BorderSide(color: Colors.grey.shade400);
                    }

                    return ChoiceChip(
                      label: Text('${time.format(context)}$suffix'),
                      selected: isCurrentlySelected && isSelectable,
                      backgroundColor: chipBackgroundColor,
                      selectedColor: Colors.blue,
                      disabledColor: Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: labelColor,
                        decoration: labelDecoration,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: borderSide,
                      ),
                      elevation: elevation,
                      onSelected: (bool selectedValue) {
                        if (isSelectable) {
                          if (selectedValue) {
                            controller.selectedTime.value = time;
                          } else {}
                        }
                      },
                    );
                  }).toList(),
                );
              }),

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
                          // Text(
                          //     '⏰ Giờ: ${controller.selectedTime.value.format(Get.context!)}'),
                          Text(
                              '⏰ Giờ: ${controller.selectedTime.value != null ? controller.selectedTime.value!.format(context) : "Chưa chọn"}'),
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
                          controller.resetBookingForm();
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
