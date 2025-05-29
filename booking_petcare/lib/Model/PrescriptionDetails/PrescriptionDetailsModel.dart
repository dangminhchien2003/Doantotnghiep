class PrescriptionDetailsModel {
  final int idthuoc;
  final String tenthuoc;
  final int soluong;
  final String lieudung;

  PrescriptionDetailsModel({
    required this.idthuoc,
    required this.tenthuoc,
    required this.soluong,
    required this.lieudung,
  });

  factory PrescriptionDetailsModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetailsModel(
      idthuoc: int.tryParse(json['idthuoc'].toString()) ?? 0,
      tenthuoc: json['tenthuoc'] ?? '',
      soluong: int.tryParse(json['soluong'].toString()) ?? 0,
      lieudung: json['lieudung'] ?? '',
    );
  }

  static List<PrescriptionDetailsModel> fromJsonList(List<dynamic> list) {
    return list
        .map(
            (e) => PrescriptionDetailsModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
