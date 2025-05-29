// payment_controller.dart
import 'package:booking_petcare/Services/APICaller.dart';
import 'package:booking_petcare/View/Dashboard/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booking_petcare/Controller/Appointment/AppointmentController.dart'
    as MainAppController;
import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:booking_petcare/Model/Prescription/PrescriptionModel.dart';
import 'package:booking_petcare/Utils/Utils.dart';

class PaymentController extends GetxController {
  // --- TRẠNG THÁI (OBSERVABLES) ---
  final RxString selectedMethod = 'Tiền mặt'.obs;
  final Rx<Prescription?> selectedPrescription = Rx<Prescription?>(null);
  final Rx<String?> prescriptionError = Rx<String?>(null);
  final RxBool isLoadingPrescription = true.obs;
  final RxBool isProcessingVnPay = false.obs;

  final List<String> paymentMethods = ['Tiền mặt', 'Chuyển khoản', 'Vn Pay'];
  final String vnpayCreatePaymentUrl =
      'https://a7e8-171-225-202-214.ngrok-free.app/API/User/Thanhtoan/create_payment_vnpay.php';
  // **** THÊM URL CHO API GHI NHẬN THANH TOÁN TIỀN MẶT ****
  final String recordCashPaymentUrl = '/User/Thanhtoan/record_cash_payment.php';

  // --- DEPENDENCIES ---
  final MainAppController.AppointmentController appointmentController =
      Get.find<MainAppController.AppointmentController>();

  // Dữ liệu Appointment sẽ được truyền từ View
  late AppointmentModel currentAppointment;

  // Cờ để theo dõi trạng thái xử lý kết quả thanh toán từ WebView
  bool _isPaymentOutcomeBeingHandled = false;

  // --- GETTERS ĐỂ TÍNH TOÁN ---
  double get totalServiceCost {
    double total = 0.0;
    if (currentAppointment.dichvu.isNotEmpty) {
      for (var service in currentAppointment.dichvu) {
        total += service.gia;
      }
    }
    return total;
  }

  double get prescriptionSubTotal {
    double subTotal = 0;
    if (selectedPrescription.value != null && prescriptionError.value == null) {
      for (var detail in selectedPrescription.value!.chitiet) {
        subTotal += (detail.giaban * detail.soluong);
      }
    }
    return subTotal;
  }

  double get finalTotalAmount {
    return totalServiceCost + prescriptionSubTotal;
  }

  // --- KHỞI TẠO LOGIC ---
  @override
  void onInit() {
    super.onInit();
    _isPaymentOutcomeBeingHandled = false; // Khởi tạo cờ
  }

  void initializePayment(AppointmentModel appointment) {
    currentAppointment = appointment;
    selectedPrescription.value = null;
    prescriptionError.value = null;
    isLoadingPrescription.value = true;
    _isPaymentOutcomeBeingHandled =
        false; // Reset cờ mỗi khi bắt đầu thanh toán mới
    fetchPrescriptionDetailsAndUpdateState(
        currentAppointment.idlichhen.toString());
  }

  Future<void> fetchPrescriptionDetailsAndUpdateState(String idLichHen) async {
    isLoadingPrescription.value = true;
    try {
      await appointmentController
          .fetchPrescriptionDetails(int.parse(idLichHen));
      selectedPrescription.value =
          appointmentController.selectedPrescription.value;
      prescriptionError.value = appointmentController.prescriptionError.value;
    } catch (e) {
      prescriptionError.value = "Lỗi khi tải đơn thuốc: ${e.toString()}";
    } finally {
      isLoadingPrescription.value = false;
    }
  }

  // --- PHƯƠNG THỨC XỬ LÝ SỰ KIỆN ---
  void onPaymentMethodChanged(String? newValue) {
    if (newValue != null) {
      selectedMethod.value = newValue;
    }
  }

  Future<void> processVnPayPayment() async {
    if (finalTotalAmount <= 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Tổng tiền cần thanh toán phải lớn hơn 0.',
        isError: true,
      );
      return;
    }

    isProcessingVnPay.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator(strokeWidth: 3)),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        Uri.parse(vnpayCreatePaymentUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idlichhen': currentAppointment.idlichhen,
          'tongtien': finalTotalAmount,
        }),
      );

      if (Get.isDialogOpen ?? false) Get.back(); // Đóng dialog loading

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          final String paymentUrl = responseData['payment_url'];
          print('VNPAY Redirect URL: $paymentUrl');
          _openVnPayWebView(paymentUrl);
        } else {
          Utils.showSnackBar(
            title: 'Lỗi Khởi Tạo Thanh Toán',
            message: responseData['message'] ??
                'Không thể tạo yêu cầu thanh toán VNPAY.',
            isError: true,
          );
        }
      } else {
        Utils.showSnackBar(
          title: 'Lỗi Kết Nối Máy Chủ',
          message:
              'Không thể kết nối đến API backend. Status Code: ${response.statusCode}',
          isError: true,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      print('Error initiating VNPAY payment: $e');
      Utils.showSnackBar(
        title: 'Lỗi Hệ Thống',
        message: 'Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.',
        isError: true,
      );
    } finally {
      isProcessingVnPay.value = false;
    }
  }

  // **** HÀM THANH TOÁN TIỀN MẶT ****
  Future<void> _processCashPayment() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận thanh toán tiền mặt'),
        content: Text(
            'Vui lòng thanh toán lịch hẹn với số tiền là ${Utils.formatCurrency(finalTotalAmount)} tại quầy của Petmart Care.\n\nBạn có muốn tiếp tục ghi nhận yêu cầu này?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Hủy'),
            onPressed: () {
              if (Get.isDialogOpen ?? false) Get.back();
            },
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () async {
              if (Get.isDialogOpen ?? false) Get.back(); // Đóng dialog xác nhận

              isProcessingVnPay.value = true; // Sử dụng cờ loading chung
              Get.dialog(
                // Hiển thị loading dialog
                const Center(child: CircularProgressIndicator(strokeWidth: 3)),
                barrierDismissible: false,
              );

              try {
                final Map<String, dynamic> requestBody = {
                  'idlichhen': currentAppointment.idlichhen,
                  'tongtien': finalTotalAmount,
                  'phuongthuc': 'Tiền mặt',
                  'trangthai': 0, // 0: Thanh toán chưa hoàn tất
                  // 'idnguoidung': appointmentController.currentUser.value?.idnguoidung, // Nếu cần
                };

                // Gọi API sử dụng APICaller.post(String endpoint, dynamic body)
                // APICaller sẽ tự động xử lý jsonEncode, headers, timeout, và các lỗi cơ bản.
                // Nó trả về dynamic (thường là Map<String, dynamic> đã parse) hoặc null nếu có lỗi.
                final dynamic responseData = await APICaller.getInstance().post(
                  recordCashPaymentUrl,
                  requestBody,
                );

                if (Get.isDialogOpen ?? false)
                  Get.back(); // Đóng loading dialog

                if (responseData != null) {
                  // Nếu responseData không phải là null, nghĩa là APICaller đã xử lý thành công
                  // và 'success' trong JSON response không phải là false (vì APICaller sẽ trả về null nếu success=false)
                  // Thông báo message từ API (nếu có) hoặc một thông báo mặc định.
                  _showFlutterSuccessDialogAndNavigateHome(responseData[
                              'message']
                          as String? ?? // APICaller trả về Map nên có thể truy cập key 'message'
                      'Yêu cầu thanh toán tiền mặt đã được ghi nhận. Vui lòng thanh toán tại quầy.');
                }
                // Không cần else ở đây để hiển thị lỗi, vì APICaller đã tự hiển thị SnackBar lỗi
                // và trả về null trong trường hợp đó.
              } catch (e) {
                // Catch này để bắt các lỗi không lường trước có thể xảy ra bên ngoài APICaller
                // hoặc nếu APICaller ném ra lỗi thay vì trả về null (ít khả năng dựa trên code APICaller bạn cung cấp)
                if (Get.isDialogOpen ?? false)
                  Get.back(); // Đảm bảo đóng loading dialog
                print(
                    'Unhandled error in _processCashPayment during APICaller use: $e');
                Utils.showSnackBar(
                    title: 'Lỗi Hệ Thống',
                    message:
                        'Đã xảy ra lỗi không mong muốn khi xử lý thanh toán tiền mặt.',
                    isError: true);
              } finally {
                isProcessingVnPay.value = false; // Kết thúc trạng thái xử lý
              }
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Hiển thị dialog thành công bằng Flutter
  void _showFlutterSuccessDialogAndNavigateHome(String successMessage) {
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Colors.green[600], size: 32),
            const SizedBox(width: 12),
            Text('Thành Công!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green[700])),
          ],
        ),
        content: Text(
          successMessage.isNotEmpty
              ? successMessage
              : "Giao dịch của bạn đã được xử lý thành công.",
          style: const TextStyle(fontSize: 16),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Hoặc Get.theme.primaryColor
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
            child: Text('Đóng'.tr, style: TextStyle(fontSize: 15)),
            onPressed: () {
              if (Get.isDialogOpen ?? false)
                Get.back(); // Đóng dialog thành công này

              Get.offAll(() => Dashboard());
            },
          ),
        ],
      ),
      barrierDismissible: false, // Người dùng phải nhấn nút
    );
  }

  void _openVnPayWebView(String url) {
    _isPaymentOutcomeBeingHandled = false; // Reset cờ khi mở WebView mới
    final WebViewController webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'VNPAYResultChannel',
        onMessageReceived: (JavaScriptMessage message) {
          print('Received message from WebView: ${message.message}');
          if (_isPaymentOutcomeBeingHandled) {
            print(
                'Payment outcome already handled, ignoring further messages from this WebView session.');
            return;
          }

          try {
            final data = jsonDecode(message.message);
            final event = data['vnpay_event'];

            if (event == 'payment_result') {
              final outcome = data['outcome'];
              final msg = data['message'] ?? 'Không có thông báo chi tiết.';

              if (outcome == 'success') {
                _isPaymentOutcomeBeingHandled = true;
                if (Get.isDialogOpen ?? false) {
                  Get.back(); // Đóng WebView dialog
                }
                Future.delayed(const Duration(milliseconds: 250), () {
                  _showFlutterSuccessDialogAndNavigateHome(msg);
                });
              } else {
                // outcome == 'failure' hoặc 'invalid_signature'
                _isPaymentOutcomeBeingHandled = true;
                if (Get.isDialogOpen ?? false) {
                  // Cân nhắc đóng webview ở đây và hiển thị dialog lỗi Flutter
                  // Get.back();
                  // _showFlutterFailureDialog(msg);
                }
                Utils.showSnackBar(
                  title: 'Thanh Toán Thất Bại',
                  message: msg,
                  isError: true,
                );
              }
            } else if (event == 'close_webview') {
              // Sự kiện này được gửi từ nút "Đóng" trên trang PHP hoặc tự động sau timeout
              if (!_isPaymentOutcomeBeingHandled) {
                _isPaymentOutcomeBeingHandled = true;
                if (Get.isDialogOpen ?? false) {
                  Get.back(); // Đóng WebView
                }
                final status = data['status'] ?? 'unknown';
                if (status == 'success') {
                  // Dự phòng nếu payment_result không được xử lý kịp thời
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _showFlutterSuccessDialogAndNavigateHome(
                        data['message'] ?? "Giao dịch hoàn tất.");
                  });
                } else {
                  Utils.showSnackBar(
                      title: 'Thông Báo',
                      message: 'Màn hình thanh toán VNPAY đã được đóng.',
                      isError: false);
                }
              } else {
                // payment_result đã xử lý, chỉ đảm bảo WebView đã đóng
                if (Get.isDialogOpen ?? false) {
                  Get.back();
                }
              }
            }
          } catch (e) {
            print('Error parsing message from WebView: $e');
            if (!_isPaymentOutcomeBeingHandled) {
              // Chỉ hiển thị lỗi nếu chưa có xử lý nào khác
              Utils.showSnackBar(
                  title: 'Lỗi Phân Tích Dữ Liệu',
                  message: 'Không thể xử lý phản hồi từ trang thanh toán.',
                  isError: true);
            }
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            /* print('WebView is loading (progress: $progress%)'); */
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
            if (!_isPaymentOutcomeBeingHandled) {
              _isPaymentOutcomeBeingHandled = true;
              if (Get.isDialogOpen ?? false) Get.back();
              Utils.showSnackBar(
                title: 'Lỗi Tải Trang Thanh Toán',
                message: 'Không thể tải trang VNPAY. ${error.description}',
                isError: true,
              );
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigating to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    Get.dialog(
      AlertDialog(
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        buttonPadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        titlePadding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Thanh toán VNPAY', style: Get.theme.textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                if (!_isPaymentOutcomeBeingHandled) {
                  _isPaymentOutcomeBeingHandled = true;
                  Utils.showSnackBar(
                      title: 'Thông báo',
                      message: 'Bạn đã hủy thanh toán VNPAY.',
                      isError: false);
                }
                if (Get.isDialogOpen ?? false) Get.back();
              },
            ),
          ],
        ),
        content: Container(
          width: Get.width * 0.95,
          height: Get.height * 0.80, // Tăng chiều cao một chút nếu cần
          color: Colors.white,
          child: WebViewWidget(controller: webViewController),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      barrierDismissible: false,
    );
  }

  void handlePaymentButtonPressed() {
    // Kiểm tra nếu tổng tiền <= 0 thì không cho thanh toán
    if (finalTotalAmount <= 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Tổng tiền cần thanh toán phải lớn hơn 0.',
        isError: true,
      );
      return;
    }

    if (selectedMethod.value == 'Vn Pay') {
      processVnPayPayment();
    } else if (selectedMethod.value == 'Tiền mặt') {
      // Gọi hàm xử lý tiền mặt mới
      _processCashPayment();
    } else if (selectedMethod.value == 'Chuyển khoản') {
      // Logic cho chuyển khoản (nếu có) - Hiện tại chưa triển khai
      Utils.showSnackBar(
        title: 'Thông báo',
        message:
            'Chức năng thanh toán bằng "Chuyển khoản" đang được phát triển.',
        isError: false,
      );
    } else {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Vui lòng chọn một phương thức thanh toán hợp lệ.',
        isError: true,
      );
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
