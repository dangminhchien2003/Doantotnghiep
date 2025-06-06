import 'dart:developer';
import 'dart:math';
import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart';
import 'package:booking_petcare/Controller/Appointment/UpcomingAppointmentController.dart';
import 'package:booking_petcare/Controller/Blog/BlogController.dart';
import 'package:booking_petcare/Controller/Home/HomeController.dart';
import 'package:booking_petcare/Controller/Notification/NotificationController.dart';
import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Router/AppPage.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/View/Appointment/AppointmentDetail.dart';
import 'package:booking_petcare/View/Appointment/UpcomingAppointments.dart';
import 'package:booking_petcare/View/Blog/Blog.dart';
import 'package:booking_petcare/View/Blog/BlogDetail.dart';
import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:booking_petcare/View/Center/CenterDetails.dart';
import 'package:booking_petcare/View/Services/Services.dart';
import 'package:booking_petcare/Widgets/blog_item/blog_item.dart';
import 'package:booking_petcare/Widgets/promo_item/promo_item.dart';
import 'package:booking_petcare/Widgets/service_item/service_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // Hàm để mở URL (ví dụ: gọi điện, mở Zalo, Messenger)
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Xử lý lỗi nếu không thể mở URL, ví dụ hiển thị SnackBar
      Get.snackbar('Lỗi', 'Không thể mở liên kết: $urlString',
          snackPosition: SnackPosition.TOP); // Đổi thành TOP cho dễ thấy hơn
    }
  }

  void _showCustomerSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0)), // Giảm nhẹ bo tròn nếu cần
      ),
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'CHĂM SÓC KHÁCH HÀNG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/phone.svg',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // THÊM DÒNG NÀY
                      children: [
                        Text('ĐẶT LỊCH CHĂM SÓC'),
                        Text('0963829989'),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF007AFF),
                    size: 18,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/messenger.svg',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('MESSENGER'),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF007AFF),
                    size: 18,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/zalo.png',
                    width: 35,
                    height: 35,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('ZALO'),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF007AFF),
                    size: 18,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final ServiceController servicecontroller = Get.put(ServiceController());
    final UpcomingAppointmentController upcomingAppointmentController =
        Get.put(UpcomingAppointmentController());
    final BlogController blogcontroller = Get.put(BlogController());
    final NotificationController notificationController =
        Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: ClipOval(
              child: Image.asset(
                'assets/images/image.png',
                height: 38,
                width: 38,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PetMart Care 🐾',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2),
            Obx(() => Text(
                  'Xin chào, ${controller.userName.value}!'.tr,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.storefront_outlined,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {
              Get.to(() => CenterDetails());
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Gọi hàm tải lại dữ liệu từ Controller
          await servicecontroller.fetchServices();
          await blogcontroller.fetchBlogs();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Banner
              SizedBox(
                height: 200,
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) =>
                      controller.currentPage.value = index,
                  children: const [
                    BannerWidget(imagePath: 'assets/images/banner.jpg'),
                    BannerWidget(imagePath: 'assets/images/banner1.jpg'),
                    BannerWidget(imagePath: 'assets/images/banner4.jpg'),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Đường kẻ bên trái ngắn
                    Expanded(
                      flex: 1,
                      child: Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                    ),
                    // Nút đặt lịch dài hơn
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width *
                            0.7, // 👈 Chiếm 60% chiều ngang
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => Booking());
                          },
                          icon: Icon(Icons.calendar_today),
                          label: Text("schedule_now".tr),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Đường kẻ bên phải ngắn
                    Expanded(
                      flex: 1,
                      child: Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // Tiêu đề danh sách dịch vụ
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "service".tr,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.arrow_forward, color: Colors.blue),
                    //   onPressed: () => Get.to(Services()),
                    // ),
                    TextButton(
                      onPressed: () => Get.to(Services()),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Danh sách dịch vụ
              SizedBox(
                height: 140,
                child: Obx(() {
                  if (servicecontroller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  print(
                      'Dịch vụ đã load: ${servicecontroller.services.length}'); // Debug số lượng dịch vụ
                  if (servicecontroller.services.isEmpty) {
                    return const Center(child: Text("Không có dịch vụ nào."));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: servicecontroller.services.length,
                    itemBuilder: (context, index) {
                      final service = servicecontroller.services[index];
                      print('Hiển thị dịch vụ: ${service.name}');
                      return GestureDetector(
                        onTap: () {
                          // Điều hướng đến trang chi tiết dịch vụ và truyền đối số service
                          Get.toNamed(Routes.serviceDetails,
                              arguments: service);
                        },
                        child: ServiceItem(service: service),
                      );
                    },
                  );
                }),
              ),

              // Tiêu đề "Lịch hẹn sắp tới"
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Icon(Icons.calendar_today_rounded, color: Colors.blue),
                        // SizedBox(width: 8),
                        Text(
                          "upcoming_appointment".tr,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.arrow_forward, color: Colors.blue),
                    //   onPressed: () => Get.to(UpcomingAppointments()),
                    // ),
                    TextButton(
                      onPressed: () => Get.to(UpcomingAppointments()),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() {
                if (upcomingAppointmentController.isLoadingAppointments.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (upcomingAppointmentController.appointments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFFFC107), width: 1.2),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.event_busy,
                              size: 40, color: Colors.orange),
                          SizedBox(height: 10),
                          Text(
                            "Bạn chưa có lịch hẹn nào.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.to(Booking());
                            },
                            icon: Icon(Icons.add_circle_outline),
                            label: Text("schedule_now".tr),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFC107),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => SizedBox(width: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                        upcomingAppointmentController.appointments.length,
                    itemBuilder: (context, index) {
                      final appt =
                          upcomingAppointmentController.appointments[index];
                      final statusText =
                          Utils.getAppointmentStatusText(appt.trangthai);
                      final statusColor =
                          Utils.getAppointmentStatusColor(appt.trangthai);

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => AppointmentDetail(appointment: appt));
                        },
                        child: Container(
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.asset(
                                  'assets/images/lichhen.jpg',
                                  height: 90,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween, // căn đều trên - dưới
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today,
                                                      size: 16,
                                                      color: Colors.grey[700]),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    appt.ngayhen,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.access_time,
                                                      size: 16,
                                                      color: Colors.grey[700]),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    appt.thoigianhen,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Icon(Icons.info_outline,
                                                  size: 16, color: statusColor),
                                              SizedBox(width: 6),
                                              Text(
                                                statusText,
                                                style: TextStyle(
                                                  color: statusColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // Nút chi tiết
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            Get.to(() => AppointmentDetail(
                                                appointment: appt));
                                          },
                                          icon: Icon(Icons.visibility_outlined,
                                              size: 18),
                                          label: Text("Chi tiết"),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blueAccent,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              SizedBox(
                height: 10,
              ),
              // Tiêu đề "Tin tức & Blog"
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "news_blogs".tr,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () => Get.to(Blog()),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Xem tất cả",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Danh sách bài viết (mới nhất về chăm sóc thú cưng, sức khỏe)
              Obx(() {
                if (blogcontroller.isLoadingBlogs.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (blogcontroller.blogs.isEmpty) {
                  return const Center(child: Text("Không có bài viết nào."));
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Tắt cuộn trong GridView khi dùng SingleChildScrollView
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Hiển thị 2 ô trong 1 dòng
                      crossAxisSpacing: 8, // Khoảng cách giữa các ô ngang
                      mainAxisSpacing: 8, // Khoảng cách giữa các ô dọc
                      childAspectRatio:
                          0.85, // Tỉ lệ chiều rộng/chiều cao của từng ô
                    ),
                    // itemCount: blogcontroller.blogs.length,
                    itemCount: min(blogcontroller.blogs.length,
                        4), // Chỉ lấy tối đa 4 bài viết
                    itemBuilder: (context, index) {
                      final blog = blogcontroller.blogs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlogDetail(blog: blog),
                            ),
                          );
                        },
                        child: BlogItem(
                          id: int.parse(blog.id),
                          tieu_de: blog.tieuDe,
                          noi_dung: blog.noiDung,
                          hinhanh: blog.hinhAnh,
                          createdAt: blog.createdAt,
                          updatedAt: blog.updatedAt,
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCustomerSupportBottomSheet(context);
        },
        child: Icon(Icons.headset_mic_rounded), // ICON MỚI CHO FAB
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Hỗ trợ khách hàng',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Widget hiển thị banner
class BannerWidget extends StatelessWidget {
  final String imagePath;
  const BannerWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}
