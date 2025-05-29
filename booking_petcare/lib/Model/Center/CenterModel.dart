class CenterModel {
  final int idtrungtam;
  final String tentrungtam;
  final String diachi;
  final String sodienthoai;
  final String email;
  final String X_location;
  final String Y_location;
  final String hinhanh;
  final String mota;

  CenterModel({
    required this.idtrungtam,
    required this.tentrungtam,
    required this.diachi,
    required this.sodienthoai,
    required this.email,
    required this.X_location,
    required this.Y_location,
    required this.hinhanh,
    required this.mota,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      idtrungtam: int.parse(json['idtrungtam'].toString()),
      tentrungtam: json['tentrungtam'],
      diachi: json['diachi'],
      sodienthoai: json['sodienthoai'],
      email: json['email'],
      X_location: json['X_location'],
      Y_location: json['Y_location'],
      hinhanh: json['hinhanh'],
      mota: json['mota'],
    );
  }
}
