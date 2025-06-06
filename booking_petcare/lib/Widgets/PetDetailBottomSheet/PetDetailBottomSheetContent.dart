// Widgets/PetDetailBottomSheetContent/PetDetailBottomSheetContent.dart
import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart'; // Model PetModel của bạn
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetDetailBottomSheetContent extends StatelessWidget {
  final PetsController controller = Get.find<PetsController>();
  final int idthucung; // Nhận petId kiểu int

  PetDetailBottomSheetContent({Key? key, required this.idthucung})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    Get.put(AppointmentController());
    Get.put(PetsController());

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
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  "Thông Tin Thú Cưng",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade700),
                  onPressed: () {
                    controller
                        .clearSelectedPetDetails(); // Xóa dữ liệu khi đóng
                    Get.back();
                  },
                  tooltip: 'Đóng',
                )
              ],
            ),
            const Divider(thickness: 1, height: 16),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingSelectedPetDetail.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.selectedPetDetailError.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Lỗi: ${controller.selectedPetDetailError.value}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  );
                }
                final PetModel? pet = controller.selectedPetDetail.value;
                if (pet == null) {
                  return const Center(
                    child: Text(
                      "Không có thông tin chi tiết cho thú cưng này.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(Icons.pets,
                              size: 40, color: Colors.orange.shade700),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPetInfoRow(
                          "ID Thú cưng:", pet.idthucung.toString(), theme),
                      _buildPetInfoRow("Tên:", pet.tenthucung, theme),
                      _buildPetInfoRow("Loài:", pet.loaithucung, theme),
                      _buildPetInfoRow("Giống:", pet.giongloai, theme),
                      _buildPetInfoRow("Tuổi:", "${pet.tuoi} tuổi", theme),
                      _buildPetInfoRow("Cân nặng:", "${pet.cannang} kg", theme),
                      const SizedBox(height: 10),
                      Text(
                        "Tình trạng sức khỏe:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: theme.primaryColorDark.withOpacity(0.9)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pet.suckhoe.isNotEmpty
                            ? pet.suckhoe
                            : "Không có ghi chú.",
                        style: const TextStyle(
                            fontSize: 14.5, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  controller.clearSelectedPetDetails();
                  Get.back();
                },
                child: const Text("Đóng", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPetInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: theme.primaryColorDark.withOpacity(0.9)),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
