import 'dart:convert';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Services/PushNotification.dart';
import 'package:booking_petcare/Services/TranslationService.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

// import 'package:timeago/src/messages/vi_messages.dart' as vi_short_messages;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale savedLocale = await TranslationService.getSavedLocale();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

  // ✅ Khởi tạo Firebase một lần duy nhất
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Đăng ký xử lý khi thông báo nhận ở background
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  // ✅ Khởi tạo thông báo (local + Firebase Cloud Messaging)
  await PushNotifications.localNotiInit();
  await PushNotifications.init();
  await savetoken();
  await _requestPermissions();

  runApp(MyApp(initialLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking PetCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Cấu hình dịch ngôn ngữ cho GetMaterialApp
      locale: initialLocale, // Đặt ngôn ngữ ban đầu dựa trên giá trị đã lưu
      fallbackLocale: TranslationService.fallbackLocale, // Ngôn ngữ dự phòng
      translations: TranslationService(),

      initialRoute: Routes.splash,
      getPages: AppPages.routes,
    );
  }
}

Future<void> _requestPermissions() async {
  // 1. Yêu cầu quyền hiển thị thông báo (giữ nguyên)
  final notificationStatus = await Permission.notification.status;
  if (notificationStatus.isDenied || notificationStatus.isPermanentlyDenied) {
    if (Platform.isIOS) {
      await Permission.notification.request();
    } else if (Platform.isAndroid) {
      await Permission.notification.request();
    }
  } else {
    print('Quyền thông báo đã được cấp');
  }

  // 2. Xử lý quyền liên quan đến báo thức cho Android
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 31) {
      // Android 12 (SDK 31) trở lên
      final alarmStatus = await Permission.scheduleExactAlarm.status;
      print('Trạng thái quyền báo thức chính xác (Android 12+): $alarmStatus');
      if (alarmStatus.isDenied || alarmStatus.isPermanentlyDenied) {
        final newAlarmStatus = await Permission.scheduleExactAlarm.request();
        if (newAlarmStatus.isGranted) {
          print('Đã cấp quyền báo động chính xác (Android 12+)');
        } else {
          print('Quyền báo động chính xác bị từ chối (Android 12+)');
        }
      } else {
        print('Quyền báo động chính xác đã được cấp (Android 12+)');
      }
    } else {
      // Cho các phiên bản Android nhỏ hơn 12 (ví dụ: Android 9 của bạn)
      print(
          'Thiết bị đang chạy Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt}).');
      print(
          'Trên phiên bản này, quyền SCHEDULE_EXACT_ALARM không được yêu cầu thông qua permission_handler theo cách của Android 12+.');
      print(
          'Để đặt báo thức chính xác, hãy đảm bảo bạn đã khai báo các quyền cần thiết trong AndroidManifest.xml (ví dụ: android.permission.WAKE_LOCK) nếu ứng dụng của bạn cần đánh thức thiết bị.');
      // Bạn không cần gọi Permission.scheduleExactAlarm.request() ở đây vì nó không áp dụng.
      // Việc đặt báo thức chính xác trên các phiên bản này được thực hiện qua AlarmManager
      // và thường không yêu cầu một quyền runtime riêng biệt như SCHEDULE_EXACT_ALARM.
    }
  }
}

/// ✅ Hàm xử lý thông báo khi app đang background
Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  // Bạn có thể xử lý logic ở đây nếu cần
  print("🔔 Background message: ${message.notification?.title}");
  // Ví dụ: Hiển thị local notification khi nhận ở background (tùy chọn)
  if (message.notification != null) {
    PushNotifications.showSimpleNotification(
      title: 'Thông báo mới',
      body: message.notification!.body ?? '',
      payload: jsonEncode(message.data),
    );
  }
}

savetoken() async {
  final pushNotifications = PushNotifications();
  try {
    String? idStr = await Utils.getStringValueWithKey(Constant.ID_NGUOIDUNG);
    if (idStr == null) return;

    int idnguoidung = int.parse(idStr); // Ép kiểu tại đây

    await pushNotifications.saveFcmToken(idnguoidung);
  } catch (e, stack) {
    debugPrint('EXCEPTION khi saveFcmToken: $e');
    debugPrint('$stack');
  }
}
