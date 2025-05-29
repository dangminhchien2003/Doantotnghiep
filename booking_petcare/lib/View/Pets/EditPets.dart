import 'package:booking_petcare/Controller/Pets/PetsController.dart';
import 'package:booking_petcare/Model/Pets/PetModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Editpets extends StatelessWidget {
  final PetModel pet;

  const Editpets({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    // Các controller cho từng field
    TextEditingController nameController =
        TextEditingController(text: pet.tenthucung ?? '');
    TextEditingController speciesController =
        TextEditingController(text: pet.loaithucung ?? '');
    TextEditingController breedController =
        TextEditingController(text: pet.giongloai ?? '');
    TextEditingController ageController =
        TextEditingController(text: pet.tuoi?.toString() ?? '');
    TextEditingController weightController =
        TextEditingController(text: pet.cannang?.toString() ?? '');
    TextEditingController healthController =
        TextEditingController(text: pet.suckhoe ?? '');

    // Khởi tạo PetsController
    final PetsController petsController = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh sửa thú cưng',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTextField('Tên thú cưng', nameController),
            const SizedBox(height: 20),
            _buildTextField('Loài thú cưng', speciesController),
            const SizedBox(height: 20),
            _buildTextField('Giống loài', breedController),
            const SizedBox(height: 20),
            _buildTextField('Tuổi', ageController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField('Cân nặng (kg)', weightController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField('Tình trạng sức khỏe', healthController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Lấy giá trị mới từ các TextEditingController
                  String name = nameController.text;
                  String species = speciesController.text;
                  String breed = breedController.text;
                  int age = int.tryParse(ageController.text) ?? 0;
                  int weight = int.tryParse(weightController.text) ?? 0;
                  String health = healthController.text;

                  // Gọi hàm sửa thú cưng từ PetsController
                  await petsController.editPet(
                    idthucung: pet.idthucung.toString(), // Giữ lại idthucung
                    tenthucung: name,
                    loaithucung: species,
                    giongloai: breed,
                    tuoi: age,
                    cannang: weight,
                    suckhoe: health,
                  );

                  // Trở lại màn hình trước
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('Lưu thay đổi',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tiện ích để build TextField
  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
