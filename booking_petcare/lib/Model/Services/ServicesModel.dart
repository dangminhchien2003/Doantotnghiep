class ServicesModel {
  final int id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String duration;

  ServicesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.duration,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    try {
      print('Đang parse dịch vụ: $json'); // Debug dữ liệu đầu vào

      return ServicesModel(
        id: (json['iddichvu'] is int)
            ? json['iddichvu']
            : int.tryParse(json['iddichvu'].toString()) ?? 0,
        name: json['tendichvu']?.toString() ?? 'Không có tên',
        description: json['mota']?.toString() ?? '',
        price: (json['gia'] is int)
            ? json['gia']
            : int.tryParse(json['gia'].toString()) ?? 0,
        imageUrl: json['hinhanh']?.toString() ?? '',
        duration: json['thoigianthuchien']?.toString() ?? '00:00:00',
      );
    } catch (e) {
      print('Lỗi khi parse ServicesModel: $e\nDữ liệu nhận: $json');
      rethrow; // Giữ nguyên lỗi để debug
    }
  }
}
