import 'dart:developer';
import 'dart:isolate';
import 'package:booking_petcare/Model/Blog/BlogModel.dart';
import 'package:booking_petcare/View/Account/Changepassword.dart';
import 'package:booking_petcare/View/Account/PersonalInformation.dart';
import 'package:booking_petcare/View/Appointment/AppoinmentList.dart';
import 'package:booking_petcare/View/Appointment/AppointmentDetail.dart';
import 'package:booking_petcare/View/Appointment/UpcomingAppointments.dart';
import 'package:booking_petcare/View/Blog/Blog.dart';
import 'package:booking_petcare/View/Blog/BlogDetail.dart';
import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:booking_petcare/View/Center/CenterDetails.dart';
import 'package:booking_petcare/View/Dashboard/Dashboard.dart';
import 'package:booking_petcare/View/Home/Home.dart';
import 'package:booking_petcare/View/Language/Language.dart';
import 'package:booking_petcare/View/Login/Login.dart';
import 'package:booking_petcare/View/Login/Onbroading.dart';
import 'package:booking_petcare/View/Login/Signup.dart';
import 'package:booking_petcare/View/Login/splash.dart';
import 'package:booking_petcare/View/Messages/Messages.dart';
import 'package:booking_petcare/View/Notification/Notification.dart';
import 'package:booking_petcare/View/Payment/Payment.dart';
import 'package:booking_petcare/View/Pets/AddPets.dart';
import 'package:booking_petcare/View/Pets/EditPets.dart';
import 'package:booking_petcare/View/Pets/Pets.dart';
import 'package:booking_petcare/View/Profile/Profile.dart';
import 'package:booking_petcare/View/Services/ServiceDetails.dart';
import 'package:booking_petcare/View/Services/Services.dart';
import 'package:booking_petcare/View/Settings/SettingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

part 'AppRoute.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.dashboard;
  static const splash = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const Splash(),
    ),
    GetPage(
      name: Routes.onbroading,
      page: () => const Onbroading(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const Signup(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const Dashboard(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const Home(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const Profile(),
    ),
    GetPage(
      name: Routes.services,
      page: () => const Services(),
    ),
    GetPage(
      name: Routes.messages,
      page: () => const Messages(),
    ),
    GetPage(
      name: Routes.serviceDetails,
      page: () {
        final service = Get.arguments; // Lấy đối số service từ Get.arguments
        return ServiceDetails(service: service);
      },
    ),
    GetPage(
      name: Routes.blog,
      page: () => const Blog(),
    ),
    GetPage(
      name: Routes.blogdetail,
      page: () {
        final BlogModel blog =
            Get.arguments; // Lấy tham số 'blog' từ Get.arguments
        return BlogDetail(blog: blog); // Truyền tham số 'blog' vào BlogDetail
      },
    ),
    GetPage(
      name: Routes.centerdetail,
      page: () => CenterDetails(),
    ),
    GetPage(
      name: Routes.appointmentDetail,
      page: () {
        final appointment = Get.arguments;
        return AppointmentDetail(appointment: appointment);
      },
    ),
    GetPage(
      name: Routes.upcomingAppointments,
      page: () => UpcomingAppointments(),
    ),
    GetPage(
      name: Routes.appointmentList,
      page: () => AppointmentList(),
    ),
    GetPage(
      name: Routes.booking,
      page: () => Booking(),
    ),
    GetPage(
      name: Routes.pets,
      page: () => Pets(),
    ),
    GetPage(
      name: Routes.addpets,
      page: () => Addpets(),
    ),
    GetPage(
      name: Routes.editpets,
      page: () {
        final pet = Get.arguments; // Lấy đối tượng thú cưng từ arguments
        return Editpets(pet: pet); // Truyền vào Editpets
      },
    ),
    GetPage(
      name: Routes.payment,
      page: () {
        final appointment =
            Get.arguments; // lấy dữ liệu appointment từ Get.arguments
        return Payment(appointment: appointment);
      },
    ),
    GetPage(
      name: Routes.settings,
      page: () => SettingScreen(),
    ),
    GetPage(
      name: Routes.language,
      page: () => Language(),
    ),
    GetPage(
      name: Routes.changepassword,
      page: () => Changepassword(),
    ),
    GetPage(
      name: Routes.personalInformation,
      page: () => PersonalInformation(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const Notification(),
    ),
  ];
}
