import 'package:booking_petcare/Model/Prescription/PrescriptionModel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class AppointmentModel {
  final int idlichhen;
  final int idnguoidung;
  final int idthucung;
  final String tenthucung;
  final int idtrungtam;
  final String tentrungtam;
  final String ngayhen;
  final String thoigianhen;
  final int trangthai;
  final String ngaytao;
  final String lydohuy;
  final List<ServiceDetail> dichvu;

  AppointmentModel({
    required this.idlichhen,
    required this.idnguoidung,
    required this.idthucung,
    required this.tenthucung,
    required this.idtrungtam,
    required this.tentrungtam,
    required this.ngayhen,
    required this.thoigianhen,
    required this.trangthai,
    required this.ngaytao,
    required this.lydohuy,
    required this.dichvu,
  });

  RxBool isExpanded = false.obs;

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    var dichvuListFromJson = json['dichvu'] as List<dynamic>? ?? [];
    List<ServiceDetail> parsedDichvuList = dichvuListFromJson
        .map((serviceJson) =>
            ServiceDetail.fromJson(serviceJson as Map<String, dynamic>))
        .toList();
    return AppointmentModel(
      idlichhen: int.tryParse(json['idlichhen'].toString()) ?? 0,
      idnguoidung: int.tryParse(json['idnguoidung'].toString()) ?? 0,
      idthucung: int.tryParse(json['idthucung'].toString()) ?? 0,
      tenthucung: json['tenthucung'] ?? '',
      idtrungtam: int.tryParse(json['idtrungtam'].toString()) ?? 0,
      tentrungtam: json['tentrungtam'] ?? '',
      ngayhen: json['ngayhen'] ?? '',
      thoigianhen: json['thoigianhen'] ?? '',
      trangthai: int.tryParse(json['trangthai'].toString()) ?? 0,
      ngaytao: json['ngaytao'] ?? '',
      lydohuy: json['lydohuy'] ?? '',
      // dichvu: (json['dichvu'] as List<dynamic>?)
      //         ?.map((e) => e.toString())
      //         .toList() ??
      //     [],
      dichvu: parsedDichvuList,
    );
  }

  static List<AppointmentModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  static Map<String, dynamic> parseResponse(Map<String, dynamic> responseData) {
    // Here you can handle errors if needed, e.g. checking response["error"]
    if (responseData["error"]["code"] != 0) {
      return {"error": responseData["error"]["message"], "data": []};
    }

    // Parse the data list to AppointmentModel list
    List<AppointmentModel> appointments = fromJsonList(responseData["data"]);
    return {
      "error": null,
      "data": appointments,
    };
  }
}

class ServiceDetail {
  final String tendichvu;
  final double gia;

  ServiceDetail({required this.tendichvu, required this.gia});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      tendichvu: json['tendichvu'] as String? ??
          'N/A', // Cung cấp giá trị mặc định nếu null
      gia: (json['gia'] as num?)?.toDouble() ??
          0.0, // Chuyển đổi an toàn sang double, mặc định là 0.0 nếu null
    );
  }

  Map<String, dynamic> toJson() {
    // Tùy chọn: nếu bạn cần gửi lại dữ liệu này
    return {
      'tendichvu': tendichvu,
      'gia': gia,
    };
  }
}
