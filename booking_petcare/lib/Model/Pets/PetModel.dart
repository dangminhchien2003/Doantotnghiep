class PetModel {
  final int idthucung;
  final String tenthucung;
  final int idnguoidung;
  final String loaithucung;
  final String giongloai;
  final int tuoi;
  final double cannang;
  final String suckhoe;

  PetModel({
    required this.idthucung,
    required this.tenthucung,
    required this.idnguoidung,
    required this.loaithucung,
    required this.giongloai,
    required this.tuoi,
    required this.cannang,
    required this.suckhoe,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      idthucung: int.tryParse(json['idthucung'].toString()) ?? 0,
      tenthucung: json['tenthucung'] ?? '',
      idnguoidung: int.tryParse(json['idnguoidung'].toString()) ?? 0,
      loaithucung: json['loaithucung'] ?? '',
      giongloai: json['giongloai'] ?? '',
      tuoi: int.tryParse(json['tuoi'].toString()) ?? 0,
      cannang: double.tryParse(json['cannang'].toString()) ?? 0,
      suckhoe: json['suckhoe'] ?? '',
    );
  }
}
