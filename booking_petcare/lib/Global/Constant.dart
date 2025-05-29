class Constant {
  // Base URL cho hình ảnh
  static const String BASE_URL_IMAGE = 'http://192.168.0.128:9500/';

  // Khóa bảo mật (giữ nguyên nếu cần)
  static const String NEXT_PUBLIC_KEY_CERT = "VGhhaWh1bmdTb2Z0";
  static const String NEXT_PUBLIC_KEY_PASS = "";

  // Thông tin người dùng
  static const String ID_NGUOIDUNG = "idnguoidung";
  static const String TEN_NGUOIDUNG = "tennguoidung";
  static const String EMAIL = "email";
  static const String MATKHAU =
      "matkhau"; // Không lưu mật khẩu nếu không cần thiết
  static const String SDT = "sodienthoai";
  static const String DIACHI = "diachi";
  static const String VAITRO = "vaitro";

  // Token & thời gian hết hạn
  static const String ACCESS_TOKEN = "accessToken";
  static const String TOKEN_EXPIRY = "token_expiry";

  // FCM Token (nếu có)
  static const String FCMTOKEN = "fcm_token";

  static const String UUID_USER_ACC = "uuid";

  static const String LANGUAGE_CODE = "language_code";
}
