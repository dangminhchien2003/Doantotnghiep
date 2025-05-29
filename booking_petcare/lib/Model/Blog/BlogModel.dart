class BlogModel {
  String id;
  String tieuDe;
  String noiDung;
  String hinhAnh;
  String idNguoiDung;
  String createdAt;
  String updatedAt;

  BlogModel({
    required this.id,
    required this.tieuDe,
    required this.noiDung,
    required this.hinhAnh,
    required this.idNguoiDung,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'].toString(),
      tieuDe: json['tieu_de'],
      noiDung: json['noi_dung'],
      hinhAnh: json['hinhanh'],
      idNguoiDung: json['idnguoidung'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
