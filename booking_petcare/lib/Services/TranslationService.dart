import 'dart:ui';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:get/get.dart';

class TranslationService extends Translations {
  static final locale = Locale('vi', 'VN');
  static final fallbackLocale = Locale('vi', 'VN');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'welcome': 'Welcome',
          'hello': 'Hello',
          'login': 'Login',
          'account': 'Account',
          'password': 'Password',
          'forgot_password': 'Forgot password?',
          'notification': 'Notification',
          'system': 'System',
          'pet': 'Pet',
          'pet_management': 'Pet management',
          'upcoming_appointment': 'Upcoming Appointment',
          'news_blogs': 'News & Blogs',
          'message': 'Message',
          'appointment': 'Appointment',
          'overview': 'Overview',
          'personnel': 'Personnel',
          'personal_information': 'Personal information',
          'schedule_now': 'Schedule now',
          'change_password': 'Change password',
          'general_settings': 'General settings',
          'individual': 'Individual',
          'language': 'Language',
          'log_out': 'Log out',
          'home': 'Home',
          'service': 'Service',
          'center_info': 'Center_info',
          'confirm_logout_title': 'Confirm logout title',
          'search_keyword': 'Enter search keyword...',
          'total_gateways': 'Total number of Gateways',
          'filter': 'Filter',
          'select_filter': 'Select the filter criteria you need',
          'activity': 'Activity',
          'area': 'Area',
          'enter_region': 'Enter region',
          'clear_filter': 'Clear filter',
          'apply': 'Apply',
          'status': 'Status',
          'notes': 'Notes',
          'emitter_list_empty': 'Empty emitter list',
          'team_use': 'Team use',
          'team_code': 'Team code',
          'leader_team': 'Leader team',
          'collapse': 'Collapse',
          'details': 'Details',
          'enter_code_team_name': 'Enter team code or team name',
          'total_number_transmitters': 'Total number of transmitters',
          'total_active_transmitter': 'Transmitter works',
          'ng_generator': 'Total NG generator',
          'longest_ng_time': 'Longest NG time',
          'transmitter_number': 'NG transmitter number',
          'no_ng_transmitter': 'No NG transmitter',
          'transmitter_id': 'Transmitter ID',
          'static_value': 'Static value',
          'belong_to_team': 'Belong to team',
          'detection_time': 'Detection time',
          'ng_time': 'NG time',
          'processing': 'Processing',
          'confirm_processing': 'Confirm processing',
          'are_confirm_processing':
              'Are you sure you want to confirm processing?',
          'unprocessed': 'Unprocessed',
          'list_of_personnel': 'List of personnel',
          'empty_personnel': 'Empty personnel list',
          'personnel_code': 'Personnel code',
          'personnel_name': 'Personnel name',
          'position': 'Position',
          'enter_position_name': 'Enter position name',
          'personnel_details': 'Personnel details',
          'full_name': 'Full name',
          'email': 'Email',
          'phone_number': 'Phone number',
          'created_at': 'Created at',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
          'confirm_logout_message': 'Confirm logout message',
          'minute': 'minute',
          'seconds': 'seconds',
          'old_password': 'Old password',
          'enter_current_password': 'Enter current password',
          'new_password': 'New password',
          'enter_new_password': 'Enter new password',
          'confirm_password': 'Confirm password',
          're_enter_new_password': 'Re-enter new password',
          'old_password_incorrect': 'Old password is incorrect',
          '6_characters': 'New password must have at least 6 characters',
          'password_contain':
              'Password must contain at least one set of uppercase letters, lowercase letters and numbers',
          'password_not_match': 'Confirm new password does not match',
          'password_changed_successfully': 'Password changed successfully',
          'male': 'Male',
          'female': 'Female',
          'address': 'Address',
          'account_information': 'Account information',
          'update': 'Update',
          'take_photo': 'Take photo',
          'gallery': 'Gallery',
          'enter_full_name': 'Enter full name',
          'phone_number_format': 'Phone number is not in the correct format',
          'account_updated_successfully':
              'Account information updated successfully',
          'new_password_cannot_old_password':
              'New password cannot be the same as old password',
          'back': 'Back',
          'we_send_password':
              'We will send you a password change link to the email address you provided earlier.',
          'email_address': 'Email Address',
          'send_otp': 'Send OTP',
          'send_again': 'Send again',
          'enter_otp': 'Enter OTP code',
          'seconds_ago': 'seconds ago',
          'minutes_ago': 'minutes ago',
          'hours_ago': 'hours ago',
          'mark_all_read': 'Mark all read',
          'all_notifications':
              'Are you sure you want to mark all notifications as read',
          'no_announcements': 'No announcements'
        },
        'vi_VN': {
          'welcome': 'Chào mừng',
          'hello': 'Xin chào',
          'login': 'Đăng nhập',
          'account': 'Tài khoản',
          'password': 'Mật khẩu',
          'forgot_password': 'Quên mật khẩu?',
          'notification': 'Thông báo',
          'system': 'Hệ thống',
          'pet': 'Thú cưng',
          'pet_management': 'Quản lý thú cưng',
          'news_blogs': 'Tin tức & Blog',
          'message': 'Tin nhắn',
          'appointment': 'Lịch hẹn',
          'upcoming_appointment': 'Lịch hẹn sắp tới',
          'overview': 'Tổng quan',
          'transmitter': 'Bộ phát',
          'gateway': 'Gateway',
          'team': 'Team',
          'personnel': 'Nhân viên',
          'personal_information': 'Thông tin cá nhân',
          'change_password': 'Đổi mật khẩu',
          'general_settings': 'Cài đặt chung',
          'individual': 'Cá nhân',
          'language': 'Ngôn ngữ',
          'log_out': 'Đăng xuất',
          'home': 'Trang chủ',
          'service': 'Dịch vụ',
          'center_info': 'Trung tâm',
          'schedule_now': 'ĐẶT LỊCH NGAY',
          'search_keyword': 'Nhập từ khóa tìm kiếm...',
          'filter': 'Bộ lọc',
          'select_filter': 'Lựa chọn tiêu chí lọc bạn cần',
          'activity': 'Hoạt động',
          'clear_filter': 'Xóa bộ lọc',
          'apply': 'Áp dụng',
          'status': 'Trạng thái',
          'notes': 'Ghi chú',
          'collapse': 'Thu gọn',
          'details': 'Chi tiết',
          'full_name': 'Họ và tên',
          'email': 'Email',
          'phone_number': 'Số điện thoại',
          'created_at': 'Tạo lúc',
          'are_transmitter':
              'Bạn có chắc muốn ngừng sử dụng của người dùng với thiết bị phát này',
          'confirm_logout_title': 'Xác nhận đăng xuất',
          'cancel': 'Hủy bỏ',
          'confirm': 'Xác nhận',
          'confirm_logout_message': 'Bạn có chắc chắn muốn đăng xuất không?',
          'minute': 'phút',
          'seconds': 'giây',
          'old_password': 'Mật khẩu cũ',
          'enter_current_password': 'Nhập mật khẩu hiện tại',
          'new_password': 'Mật khẩu mới',
          'enter_new_password': 'Nhập mật khẩu mới',
          'confirm_password': 'Xác nhận mật khẩu',
          're_enter_new_password': 'Nhập lại mật khẩu mới',
          'old_password_incorrect': 'Mật khẩu cũ không đúng',
          '6_characters': 'Mật khẩu mới phải có ít nhất 6 ký tự',
          'password_contain':
              'Mật khẩu phải có ít nhất một nhóm chữ hoa, chữ thường và số',
          'password_not_match': 'Xác nhận mật khẩu mới không khớp',
          'password_changed_successfully': 'Đổi mật khẩu thành công',
          'date_of_birth': 'Ngày sinh',
          'select_gender': 'Chọn giới tính',
          'male': 'Nam',
          'female': 'Nữ',
          'address': 'Địa chỉ',
          'specific_address': 'Địa chỉ cụ thể: SN, Đường, Thôn...',
          'account_information': 'Thông tin tài khoản',
          'update': 'Cập nhật',
          'take_photo': 'Chụp ảnh',
          'gallery': 'Thư viện',
          'enter_full_name': 'Nhập họ và tên',
          'phone_number_format': 'Số điện thoại không đúng định dạng',
          'account_updated_successfully':
              'Cập nhật thông tin tài khoản thành công',
          'new_password_cannot_old_password':
              'Mật khẩu mới không được trùng với mật khẩu cũ',
          'back': 'Quay lại',
          'we_send_password':
              'Chúng tôi sẽ gửi cho bạn một liên kết đổi mật khẩu đến địa chỉ email bạn đã cung cấp trước đó.',
          'email_address': 'Địa chỉ Email',
          'send_otp': 'Gửi OTP',
          'send_again': 'Gửi lại',
          'enter_otp': 'Nhập mã OTP',
          'validate_password':
              'Đảm bảo mật khẩu của bạn bao gồm cả chữ hoa và chữ thường cũng như số để bảo vệ tài khoản của bạn.',
          'continue': 'Tiếp tục',
          'enter_email_address': 'Nhập địa chỉ email',
          'email_formatted': 'Email không đúng định dạng',
          'full_name_50_characters': 'Họ và tên vượt quá 50 ký tự',
          'address_255_characters': 'Địa chỉ vượt quá 255 ký tự',
          'login_session_expired': 'Đã hết phiên đăng nhập',
          'seconds_ago': 'giây trước',
          'minutes_ago': 'phút trước',
          'hours_ago': 'tiếng trước',
          'mark_all_read': 'Đánh dấu đọc tất cả',
          'all_notifications':
              'Bạn chắc chắn muốn đánh dấu đọc tất cả thông báo',
          'no_announcements': 'Không có thông báo nào',
          'Notifications': 'Thông báo'
        },
      };

  static Future<void> changeLocale(String langCode) async {
    final locale = _getLocaleFromLanguage(langCode);
    Get.updateLocale(locale);

    Utils.saveStringWithKey(Constant.LANGUAGE_CODE, langCode);
  }

  static Locale _getLocaleFromLanguage(String langCode) {
    switch (langCode) {
      case 'vi':
        return Locale('vi', 'VN');
      case 'en':
      default:
        return Locale('en', 'US');
    }
  }

  static Future<Locale> getSavedLocale() async {
    String langCode = await Utils.getStringValueWithKey(Constant.LANGUAGE_CODE);
    if (langCode.isEmpty) {
      return locale;
    }
    return _getLocaleFromLanguage(langCode);
  }
}
