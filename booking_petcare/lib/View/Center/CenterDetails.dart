import 'package:booking_petcare/Controller/Services/ServiceController.dart';
import 'package:booking_petcare/Model/Services/ServicesModel.dart';
import 'package:booking_petcare/Utils/Utils.dart';
import 'package:booking_petcare/View/Booking/Booking.dart';
import 'package:booking_petcare/View/Messages/Messages.dart';
import 'package:booking_petcare/View/Services/ServiceDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:booking_petcare/Controller/Center/CenterController.dart'; // Đảm bảo đường dẫn đúng

class CenterDetails extends StatelessWidget {
  final CenterController controller = Get.put(CenterController());
  final ServiceController serviceController = Get.put(ServiceController());

  CenterDetails({super.key});

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text, {
    Color iconColor = Colors.black54,
    Color textColor = Colors.black87,
    VoidCallback? onTap,
  }) {
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: textColor),
          ),
        ),
      ],
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        child: content,
        highlightColor: Colors.grey.withOpacity(0.1),
        splashColor: Colors.transparent,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: content,
    );
  }

  Widget _buildServiceItem(BuildContext context, ServicesModel service) {
    return InkWell(
      onTap: () {
        Get.to(() => ServiceDetails(service: service));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (service.imageUrl != null && service.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    service.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(Icons.pets,
                            color: Colors.grey[400], size: 40)),
                  ),
                )
              else
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Icon(
                      Icons.pets,
                      color: Colors.grey[400],
                      size: 40,
                    )),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name ?? 'Tên dịch vụ không xác định',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (service.description != null &&
                        service.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        service.description!,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.price != null
                              ? Utils.formatCurrency(service.price)
                              : 'Liên hệ',
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${service.duration} phút",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> danhSachUrlHinhAnh = [
      'https://channel.mediacdn.vn/2019/9/24/photo-1-1569261606684716246154.jpg',
      'https://cdn.24h.com.vn/upload/3-2019/images/2019-09-23/Cong-vien-thu-cung-thu-nho-tai-sieu-thi-cho-meo-Pet-Mart-cong-vien-cho-meo--4--1569208501-401-width660height495.jpg',
      'https://image.tienphong.vn/w890/Uploaded/2025/pcgycivo/2019_09_23/image001_SCWN.jpg',
      'https://static.riviu.co/960/image/2020/12/16/84760e8a5813375b8fb4d60da205654a_output.jpeg',
      'https://swimtobelive.com/wp-content/uploads/2020/11/shop-ban-phu-kien-thu-cung-tphcm.jpg',
      'https://sieupet.com/sites/default/files/khach_san_cho_thu_cung.jpg',
    ];
    final List<IconData> icons = [
      Icons.sentiment_very_satisfied,
      Icons.sentiment_satisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_dissatisfied,
    ];

    final List<Color> colors = [
      Colors.green,
      Colors.lightGreen,
      Colors.orange,
      Colors.deepOrange,
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Thông tin trung tâm",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final center = controller.center.value;
        if (center == null) {
          return const Center(child: Text("Không có dữ liệu trung tâm"));
        }

        final double? lat = double.tryParse(center.Y_location ?? '');
        final double? lng = double.tryParse(center.X_location ?? '');
        final String openingHoursText = '09:00 AM - 09:00 PM';
        final String imageCountText = "${danhSachUrlHinhAnh.length} ảnh";

        return DefaultTabController(
          length: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (center.hinhanh != null && center.hinhanh.isNotEmpty)
                ClipRRect(
                  child: Image.network(
                    center.hinhanh!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey[600]),
                    ),
                  ),
                ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "TRUNG TÂM CHĂM SÓC THÚ CƯNG",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      center.tentrungtam ?? 'N/A',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on,
                            color: Colors.blue[700], size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(
                          center.diachi ?? 'N/A',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                indicatorWeight: 3.0,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                tabs: [
                  Tab(text: "Thông tin"),
                  Tab(text: "Dịch vụ"),
                  Tab(text: "Ưu đãi"),
                  Tab(text: "Đánh giá"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          const Text(
                            "THÔNG TIN",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          _buildInfoRow(
                            context,
                            Icons.near_me_outlined,
                            "Cách tôi: -- km",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.access_time_outlined,
                            "Mở cửa: $openingHoursText",
                          ),
                          _buildInfoRow(
                            context,
                            Icons.phone_outlined,
                            center.sodienthoai ?? 'N/A',
                            onTap: () => controller
                                .makePhoneCall(center.sodienthoai ?? ''),
                          ),
                          _buildInfoRow(context, Icons.email_outlined,
                              center.email ?? 'N/A',
                              onTap: () =>
                                  controller.launchEmail(center.email ?? '')),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, bottom: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                onTap: () {
                                  controller.toggleHienThiThongTinMoRong();
                                },
                                child: Obx(() => Text(
                                      controller.hienThiThongTinMoRong.value
                                          ? "THU GỌN BỚT"
                                          : "XEM THÊM THÔNG TIN",
                                      style: TextStyle(
                                        color: Colors.teal[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    )),
                                highlightColor: Colors.teal.withOpacity(0.1),
                                splashColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Obx(() {
                            if (!controller.hienThiThongTinMoRong.value) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(
                                    height: 20,
                                    thickness: 0.8,
                                    color: Colors.black12),
                                const Text("Giới thiệu:",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                if (center.mota != null &&
                                    center.mota.isNotEmpty)
                                  Text(
                                    // Hiển thị toàn bộ mô tả
                                    center.mota!,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[800],
                                        height: 1.4),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      "Chưa có thông tin giới thiệu.",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                if (lat != null && lng != null) ...[
                                  const Text("Vị trí trên bản đồ:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: 250,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: FlutterMap(
                                            options: MapOptions(
                                              center: LatLng(lat, lng),
                                              initialZoom: 15,
                                            ),
                                            children: [
                                              TileLayer(
                                                urlTemplate:
                                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                userAgentPackageName:
                                                    'com.example.booking_petcare',
                                              ),
                                              MarkerLayer(
                                                markers: [
                                                  Marker(
                                                    point: LatLng(lat, lng),
                                                    width: 40,
                                                    height: 40,
                                                    child: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                        size: 40),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        right: 12,
                                        child: ElevatedButton(
                                          onPressed: () => controller
                                              .openGoogleMaps(lat, lng),
                                          child: const Icon(Icons.map,
                                              color: Colors.white, size: 16),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueAccent,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Text(
                                          "Không thể xác định vị trí trên bản đồ."),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),
                              ],
                            );
                          }),
                          const SizedBox(height: 10),
                          const Text(
                            "HÌNH ẢNH",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            imageCountText,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          if (danhSachUrlHinhAnh.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: danhSachUrlHinhAnh
                                    .length, // Sử dụng danh sách URL cố định
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      // Sử dụng Image.network
                                      danhSachUrlHinhAnh[
                                          index], // Lấy URL từ danh sách cố định
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            "Lỗi tải ảnh GridView từ URL: ${danhSachUrlHinhAnh[index]} - $error");
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                              Icons.broken_image_outlined,
                                              color: Colors.grey[400],
                                              size: 30),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                  "Không có hình ảnh nào được cấu hình.",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Obx(() {
                        if (serviceController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (serviceController.filteredServices.isEmpty) {
                          return const Center(
                            child: Text(
                              "Hiện tại trung tâm chưa có dịch vụ nào.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: serviceController.filteredServices.length,
                          itemBuilder: (context, index) {
                            final service =
                                serviceController.filteredServices[index];
                            return _buildServiceItem(context, service);
                          },
                        );
                      }),
                    ),
                    Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text("Trung tâm này hiện chưa có ưu đãi"),
                        SizedBox(height: 8),
                        SvgPicture.asset(
                          'assets/icons/voucher.svg',
                          width: 80,
                          height: 80,
                        ),
                      ]),
                    ),
                    SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ĐÁNH GIÁ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 4),
                            Text('0 bình luận',
                                style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 16),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text('--',
                                              style: TextStyle(fontSize: 20)),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text('Điểm trung bình'),
                                    ],
                                  ),
                                  SizedBox(width: 12),
                                  VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                  SizedBox(width: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: List.generate(4, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Column(
                                            children: [
                                              Icon(icons[index],
                                                  color: colors[index],
                                                  size: 50),
                                              SizedBox(height: 4),
                                              Text('0'),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Center(
                              child: SizedBox(
                                width: 500,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Viết bình luận',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.blue),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Center(
                              child: Text(
                                '- Tải thêm -',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.phone_outlined),
                        iconSize: 28.0,
                        color: Colors.green,
                        tooltip: 'Gọi ngay',
                        onPressed: () =>
                            controller.makePhoneCall(center.sodienthoai ?? ''),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        iconSize: 28.0,
                        color: Colors.blue,
                        tooltip: 'Nhắn tin',
                        onPressed: () {
                          Get.to(() => const Messages());
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          icon: const Icon(Icons.email_outlined),
                          iconSize: 28.0,
                          color: Colors.deepOrange,
                          tooltip: 'Email',
                          onPressed: () {
                            controller.launchEmail(center.email ?? '');
                          }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => Booking());
                        },
                        icon: const Icon(Icons.calendar_today,
                            color: Colors.white, size: 20),
                        label: const Text("ĐẶT LỊCH",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
