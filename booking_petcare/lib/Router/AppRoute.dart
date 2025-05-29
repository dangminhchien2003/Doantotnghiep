part of 'AppPage.dart';

abstract class Routes {
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const splash = _Paths.splash;
  static const onbroading = _Paths.onbroading;
  static const login = _Paths.login;
  static const signup = _Paths.signup;
  static const profile = _Paths.profile;
  static const services = _Paths.services;
  static const messages = _Paths.messages;
  static const account = _Paths.account;
  static const setting = _Paths.setting;
  static const serviceDetails = _Paths.serviceDetails;
  static const blog = _Paths.blog;
  static const blogdetail = _Paths.blogdetail;
  static const centerdetail = _Paths.centerdetail;
  static const appointmentDetail = _Paths.appointmentDetail;
  static const notification = _Paths.notification;
  static const upcomingAppointments = _Paths.upcomingAppointments;
  static const appointmentList = _Paths.appointmentList;
  static const booking = _Paths.booking;
  static const pets = _Paths.pets;
  static const addpets = _Paths.addpets;
  static const editpets = _Paths.editpets;
  static const payment = _Paths.payment;
  static const settings = _Paths.settings;
  static const language = _Paths.language;
  static const changepassword = _Paths.changepassword;
  static const personalInformation = _Paths.personalInformation;
  // static const profile = _Paths.home + _Paths.profile;
  Routes._();
}

abstract class _Paths {
  _Paths._();
  static const dashboard = '/';
  static const home = '/home';
  static const splash = '/splash';
  static const onbroading = '/onbroading';
  static const login = '/login';
  static const signup = '/signup';
  static const profile = '/profile';
  static const services = '/services';
  static const messages = '/messages';
  static const account = '/account';
  static const setting = '/setting';
  static const serviceDetails = '/serviceDetails';
  static const blog = '/blog';
  static const blogdetail = '/blogdetail';
  static const centerdetail = '/centerdetail';
  static const appointmentDetail = '/appointmentDetail';
  static const notification = '/notification';
  static const upcomingAppointments = '/upcomingAppointments';
  static const appointmentList = '/appointmentList';
  static const booking = '/booking';
  static const pets = '/pets';
  static const addpets = '/addpets';
  static const editpets = '/editpets';
  static const payment = '/payment';
  static const settings = '/settings';
  static const language = '/language';
  static const changepassword = '/changepassword';
  static const personalInformation = '/personalInformation';
}
