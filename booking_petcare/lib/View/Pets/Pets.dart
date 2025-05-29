import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart';
import 'package:booking_petcare/View/Pets/AddPets.dart';
import 'package:booking_petcare/Widgets/pets_item/pets_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Pets extends StatelessWidget {
  Pets({super.key});

  final PetsController petsController = Get.put(PetsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quản lý thú cưng',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Ô tìm kiếm
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm thú cưng...',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          petsController.searchPets(query);
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        petsController.fetchPets(); // Làm mới danh sách
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Danh sách thú cưng
            Expanded(
              child: Obx(() {
                if (petsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (petsController.filteredPets.isEmpty) {
                  return const Center(child: Text('Không có thú cưng nào.'));
                }

                return ListView.builder(
                  itemCount: petsController.filteredPets.length,
                  itemBuilder: (context, index) {
                    final pet = petsController.filteredPets[index];
                    return PetsItem(
                      pet: pet,
                      onDelete: () {
                        _showDeleteConfirmation(context, pet, petsController);
                      },
                      onEdit: () {
                        Get.toNamed('/editpets', arguments: pet);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // Nút thêm thú cưng
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => Addpets());
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, PetModel pet, PetsController controller) {
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.orange.shade700, size: 28),
            const SizedBox(width: 10),
            const Text('Xác nhận xóa',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        content: Text.rich(
          TextSpan(
            text: 'Bạn có thật sự muốn xóa thú cưng ',
            style: const TextStyle(fontSize: 16, height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text: (pet.tenthucung != null && pet.tenthucung!.isNotEmpty)
                    ? '"${pet.tenthucung}"'
                    : 'này',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                    fontSize: 17),
              ),
              const TextSpan(
                  text:
                      '?\nHành động này sẽ xóa vĩnh viễn thông tin và không thể hoàn tác.'),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
            ),
            child: Text('Hủy',
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            onPressed: () {
              if (Get.isDialogOpen ?? false) {
                Get.back();
              }
            },
          ),
          const SizedBox(width: 8),
          _DeleteConfirmButton(pet: pet, petsController: controller),
        ],
      ),
      barrierDismissible: true, // Cho phép đóng bằng cách nhấn ra ngoài
    );
  }
}

// Widget riêng cho nút xác nhận xóa để quản lý trạng thái loading
class _DeleteConfirmButton extends StatefulWidget {
  final PetModel pet;
  final PetsController petsController;

  const _DeleteConfirmButton({
    required this.pet,
    required this.petsController,
  });

  @override
  _DeleteConfirmButtonState createState() => _DeleteConfirmButtonState();
}

class _DeleteConfirmButtonState extends State<_DeleteConfirmButton> {
  // Không cần _isLoading nữa vì dialog sẽ đóng ngay
  // bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () async {
        // 1. Đóng dialog xác nhận ngay lập tức
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // 2. Hiển thị Snackbar thông báo "Đang xử lý"
        final SnackbarController processingSnackbar = Get.snackbar(
          'Đang xử lý',
          'Đang xóa thú cưng "${widget.pet.tenthucung ?? 'không tên'}"...',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(15),
          borderRadius: 10,
          backgroundColor:
              Colors.blueGrey.shade700, // Màu nền cho snackbar đang xử lý
          colorText: Colors.white,
          showProgressIndicator: true,
          progressIndicatorBackgroundColor: Colors.blue.shade300,
          progressIndicatorValueColor:
              const AlwaysStoppedAnimation<Color>(Colors.white),
          isDismissible: false, // Ngăn người dùng tự ý đóng
          duration: const Duration(
              seconds: 60), // Thời gian chờ tối đa (phòng trường hợp treo)
        );

        // 3. Thực hiện hành động xóa và hiển thị Snackbar kết quả
        try {
          if (widget.pet.idthucung == null) {
            throw Exception("ID thú cưng không hợp lệ.");
          }
          await widget.petsController
              .deletePet(widget.pet.idthucung.toString());

          await processingSnackbar.close(); // Đóng snackbar "Đang xử lý"

          Get.snackbar(
            'Thành công',
            'Đã xóa thú cưng "${widget.pet.tenthucung ?? 'không tên'}"!',
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(15),
            borderRadius: 10,
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          );
        } catch (e) {
          await processingSnackbar.close(); // Đóng snackbar "Đang xử lý"

          Get.snackbar(
            'Lỗi',
            'Xóa thú cưng "${widget.pet.tenthucung ?? 'không tên'}" thất bại. ${e is Exception ? e.toString().replaceFirst("Exception: ", "") : e.toString()}',
            backgroundColor: Colors.red.shade700,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.all(15),
            borderRadius: 10,
            icon: const Icon(Icons.error_outline, color: Colors.white),
          );
        }
      },
      child: const Text('Xóa ngay',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
