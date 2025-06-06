import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceModalContent extends StatefulWidget {
  const ServiceModalContent({Key? key}) : super(key: key);

  @override
  _ServiceModalContentState createState() => _ServiceModalContentState();
}

final TextEditingController _searchController = TextEditingController();

class _ServiceModalContentState extends State<ServiceModalContent> {
  // Không cần _selectedServiceIds cục bộ nữa nếu bạn cập nhật trực tiếp AppointmentController
  final AppointmentController appointmentController =
      Get.find<AppointmentController>();
  final ServiceController serviceController = Get.find<ServiceController>();

  void _toggleServiceSelection(int serviceId) {
    // Cập nhật trực tiếp vào RxList của AppointmentController
    // GetX sẽ tự động rebuild các widget đang lắng nghe (Obx)
    if (appointmentController.selectedServiceIds.contains(serviceId)) {
      appointmentController.selectedServiceIds.remove(serviceId);
    } else {
      appointmentController.selectedServiceIds.add(serviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Chiều cao modal
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Chọn Dịch Vụ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm dịch vụ...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              serviceController.filterServices(value); // gọi hàm lọc
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (serviceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (serviceController.filteredServices.isEmpty) {
                return const Center(child: Text('Không có dịch vụ nào'));
              }
              return ListView.builder(
                itemCount: serviceController.filteredServices.length,
                itemBuilder: (context, index) {
                  final service = serviceController.filteredServices[index];
                  // Sử dụng Obx cho từng CheckboxListTile để nó rebuild khi selectedServiceIds thay đổi
                  return Obx(() => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: CheckboxListTile(
                          title: Text(service.name),
                          subtitle: Text(
                              'Giá: ${Utils.formatCurrency(service.price)}'),
                          value: appointmentController.selectedServiceIds
                              .contains(service.id),
                          onChanged: (bool? value) {
                            _toggleServiceSelection(service.id);
                          },
                          activeColor: Colors.blue,
                        ),
                      ));
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 48),
                textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
            onPressed: () {
              Navigator.pop(context); // Đóng modal
            },
            child: const Text('XONG', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
