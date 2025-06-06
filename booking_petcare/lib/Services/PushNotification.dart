import 'dart:convert';
import 'dart:ffi';
import 'package:booking_petcare/Controller/Home/HomeController.dart';
import 'package:booking_petcare/Global/Constant.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class PushNotifications {
  static final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Yêu cầu quyền thông báo và khởi tạo FCM
  static Future init() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Lấy và lưu token ban đầu
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      Utils.saveStringWithKey(Constant.FCMTOKEN, token);
      print('Device token: $token');
    }

    // Lắng nghe sự kiện làm mới token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      Utils.saveStringWithKey(Constant.FCMTOKEN, newToken);
      print('New token: $newToken');
    });

    // Xử lý tin nhắn đến khi ứng dụng đang ở foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showSimpleNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
          payload: jsonEncode(message.data), // Truyền dữ liệu làm payload
        );
      }
    });

    // Xử lý khi ứng dụng được mở từ một thông báo (background hoặc đã tắt)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        navigationInNotification(message.data);
      }
    });

    // Xử lý tin nhắn ban đầu nếu ứng dụng được mở từ trạng thái đã tắt
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data.isNotEmpty) {
        navigationInNotification(message.data);
      }
    });
  }

  //lưu token
  Future<void> saveFcmToken(int idnguoidung) async {
    // DateTime timeNow = DateTime.now();
    String? token = await FirebaseMessaging.instance.getToken();
    // String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    print('token: $token');
    if (token != null) {
      var body = {
        "id": idnguoidung,
        "fcm_tokens": token,
        // "keyCert":
        //     Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        // "time": formattedTime,
      };
      try {
        var data =
            await APICaller.getInstance().post('User/Login/luutoken.php', body);
        print('body: $body');
        if (data != null && data["error"]["code"] == 0) {
          print('Response data: $data');
        } else {
          print('Token cant save');
        }
      } catch (e) {
        debugPrint("Lỗi Token: $e", wrapWidth: 1024);
      }
    }
  }

  // Khởi tạo thông báo cục bộ
  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      final NotificationResponse? response =
          notificationAppLaunchDetails.notificationResponse;
      if (response?.payload != null) {
        Map<String, dynamic> data = jsonDecode(response!.payload!);
        await onNotificationTap(response);
      }
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

// Khi bạn chạm vào một thông báo cục bộ ở foreground
  static onNotificationTap(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      Map<String, dynamic> data = jsonDecode(notificationResponse.payload!);
      navigationInNotification(data);
    }
  }

  static navigationInNotification(dynamic data) async {
    Get.offAllNamed(Routes.dashboard);
    final controller = Get.put(HomeController());
    // controller.textSearch.text = data['MacNumber'];
    // controller.teamSelectList.add(data['TeamUuid']);
  }

// Hiển thị một thông báo đơn giản
  static Future showSimpleNotification(
      {required String title, required String body, String? payload}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('bookingpetcare', 'Demo1 Notifications',
            channelDescription: 'Kênh thông báo demo1',
            channelShowBadge: true,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
            fullScreenIntent: true);
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: payload); // Truyền payload vào phương thức show()
  }

  // Hàm lưu thông báo vào CSDL
  static Future<void> saveNotification(
    int idnguoidung,
    String tieude,
    String noidung,
  ) async {
    final now = DateTime.now();
    final formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(now);
    final keyCert =
        Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime);

    final payload = {
      'idnguoidung': idnguoidung,
      'tieude': tieude,
      'noidung': noidung,
      'keyCert': keyCert,
      'time': formattedTime,
    };

    final data = await APICaller.getInstance().post(
      'User/Thongbao/add_notifications.php',
      payload,
    );
    if (data != null && data['status'] == 'success') {
      print('Notification saved: $data');
    } else {
      print('Failed to save notification');
    }
  }

  static Future<void> scheduleReminders(
    int idnguoidung, // uid người dùng
    DateTime appointmentDateTime, // thời điểm lịch hẹn
    {
    required String tieude,
    String? noidung,
  }) async {
    print(
        'DEBUG: scheduleReminders được gọi với idnguoidung: $idnguoidung, appointmentDateTime: $appointmentDateTime');
    final plugin = _flutterLocalNotificationsPlugin;
    final now = tz.TZDateTime.now(tz.local);

    // Các khoảng cần nhắc
    final reminders = [
      const Duration(hours: 1),
      const Duration(minutes: 10),
    ];

    for (var dur in reminders) {
      // Tính thời điểm firing
      final fireTime = tz.TZDateTime.from(
        appointmentDateTime.subtract(dur),
        tz.local,
      );
      print('fireTime $fireTime');
      if (fireTime.isAfter(now)) {
        final label = dur.inMinutes >= 60 ? '1 giờ trước' : '10 phút trước';
        final notiftieude = tieude;
        final notifnoidung = noidung ?? '$tieude ($label)';

        await plugin.zonedSchedule(
          fireTime.hashCode, // id
          notiftieude,
          notifnoidung,
          fireTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'bookingpetcare',
              'Demo1 Notifications',
              channelDescription: 'Kênh thông báo demo1',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
        );

        await saveNotification(idnguoidung, notiftieude, notifnoidung);
      }
    }
  }
}
