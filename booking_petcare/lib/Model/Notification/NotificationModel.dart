class NotificationModel {
  int? idthongbao;
  int? idnguoidung;
  String? tieude;
  String? noidung;
  int? trangthai;
  DateTime? thoigiantao;

  NotificationModel({
    this.idthongbao,
    this.idnguoidung,
    this.tieude,
    this.noidung,
    this.trangthai,
    this.thoigiantao,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    idthongbao = json['idthongbao'];
    idnguoidung = json['idnguoidung'];
    tieude = json['tieude'];
    noidung = json['noidung'];
    trangthai = json['trangthai'];
    // Chuyển đổi chuỗi ngày giờ thành DateTime
    final rawDate = json['thoigiantao'];
    if (rawDate != null) {
      thoigiantao = DateTime.tryParse(rawDate.replaceFirst(' ', 'T'));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idthongbao'] = idthongbao;
    data['idnguoidung'] = idnguoidung;
    data['tieude'] = tieude;
    data['noidung'] = noidung;
    data['trangthai'] = trangthai;
    data['thoigiantao'] = thoigiantao?.toIso8601String(); // Định dạng chuẩn ISO
    return data;
  }
}
