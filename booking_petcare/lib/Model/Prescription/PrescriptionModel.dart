import 'package:booking_petcare/Utils/Utils.dart'; // Giả định Utils.dart của bạn có hàm formatCurrency

class Prescription {
  final String?
      ngaylap; // Có thể là String vì API trả về ngày giờ dưới dạng chuỗi
  final String? ghichu;
  final List<PrescriptionDetail> chitiet;

  Prescription({
    this.ngaylap,
    this.ghichu,
    required this.chitiet,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    List<PrescriptionDetail> details = [];
    if (json['chitiet'] is List) {
      details = (json['chitiet'] as List)
          .map((detailJson) {
            try {
              // Ép kiểu tường minh sang Map<String, dynamic>
              return PrescriptionDetail.fromJson(
                  detailJson as Map<String, dynamic>);
            } catch (e) {
              // Ghi log chi tiết lỗi nếu một PrescriptionDetail cụ thể không parse được
              print(
                  '❌ Lỗi parse một PrescriptionDetail: $e, Dữ liệu gốc: $detailJson');
              return null; // Trả về null nếu có lỗi
            }
          })
          .whereType<
              PrescriptionDetail>() // Lọc bỏ các phần tử null khỏi danh sách
          .toList();
    } else {
      print(
          '❌ chitiet không phải là List trong Prescription: ${json['chitiet']}');
    }

    return Prescription(
      ngaylap: json['ngaylap'] as String?, // API trả về String
      ghichu: json['ghichu'] as String?,
      chitiet: details,
    );
  }
}

class PrescriptionDetail {
  final int idthuoc; // API trả về int
  final String tenthuoc;
  final double giaban; // API trả về số, dùng double để bao quát
  final String donvitinh;
  final String lieudung;
  final int soluong; // API trả về int

  PrescriptionDetail({
    required this.idthuoc,
    required this.tenthuoc,
    required this.giaban,
    required this.donvitinh,
    required this.lieudung,
    required this.soluong,
  });

  factory PrescriptionDetail.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetail(
      // Chuyển đổi an toàn: nếu là int thì dùng trực tiếp, nếu không thì toString() rồi parse
      idthuoc: json['idthuoc'] is int
          ? json['idthuoc']
          : int.tryParse(json['idthuoc'].toString()) ?? 0,
      tenthuoc: json['tenthuoc'] as String,
      // Chuyển đổi an toàn: nếu là num (int hoặc double) thì toDouble(), nếu không thì toString() rồi parse
      giaban: json['giaban'] is num
          ? json['giaban'].toDouble()
          : double.tryParse(json['giaban'].toString()) ?? 0.0,
      donvitinh: json['donvitinh'] as String,
      lieudung: json['lieudung'] as String,
      // Chuyển đổi an toàn tương tự
      soluong: json['soluong'] is int
          ? json['soluong']
          : int.tryParse(json['soluong'].toString()) ?? 0,
    );
  }

  // **LOẠI BỎ CÁC GETTER parsedGiaban VÀ parsedSoluong**
  // Vì các trường giaban và soluong đã là double và int rồi, không cần parse lại
}
