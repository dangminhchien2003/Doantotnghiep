import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Addpets extends StatelessWidget {
  Addpets({super.key});

  // Các controller để nhập liệu
  final TextEditingController nameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController healthController = TextEditingController();

  final PetsController petsController = Get.find<PetsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            const Text('Thêm thú cưng', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Tên thú cưng', nameController),
            const SizedBox(height: 10),
            _buildTextField('Loài thú cưng', speciesController),
            const SizedBox(height: 10),
            _buildTextField('Giống loài', breedController),
            const SizedBox(height: 10),
            _buildTextField('Tuổi', ageController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField('Cân nặng (kg)', weightController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            _buildTextField('Tình trạng sức khỏe', healthController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim();
                  String species = speciesController.text.trim();
                  String breed = breedController.text.trim();
                  int? age = int.tryParse(ageController.text.trim());
                  double? weight =
                      double.tryParse(weightController.text.trim());
                  String health = healthController.text.trim();

                  if (name.isEmpty || species.isEmpty || age == null) {
                    Get.snackbar(
                        'Lỗi', 'Vui lòng nhập đầy đủ thông tin bắt buộc!');
                    return;
                  }

                  // Gọi controller để thêm thú cưng mới
                  try {
                    await petsController.addPet(
                      tenthucung: name,
                      loaithucung: species,
                      giongloai: breed,
                      tuoi: age,
                      cannang: weight?.toInt() ?? 0,
                      suckhoe: health,
                    );

                    // Hiển thị thông báo thành công
                    // Get.snackbar('Thành công', 'Đã thêm thú cưng mới!');

                    // Quay lại trang trước sau khi thêm thành công
                    Navigator.pop(context);
                  } catch (e) {
                    // Hiển thị thông báo lỗi nếu có lỗi khi thêm thú cưng
                    Get.snackbar('Lỗi', 'Có lỗi xảy ra, vui lòng thử lại!');
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Text('Thêm thú cưng',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm build ô nhập liệu
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
