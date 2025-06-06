// payment_view.dart (hoặc Payment.dart theo đường dẫn của bạn)
import 'package:booking_petcare/Controller/Payment/PaymentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:booking_petcare/Model/Appointment/AppointmentModel.dart';
import 'package:booking_petcare/Model/Prescription/PrescriptionModel.dart';
import 'package:booking_petcare/Utils/Utils.dart';

class Payment extends StatelessWidget {
  final AppointmentModel appointment;
  final PaymentController controller;

  Payment({super.key, required this.appointment})
      : controller = Get.put(PaymentController()) {
    // Khởi tạo hoặc tìm controller
    controller.initializePayment(appointment);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.blue[700],
            ) ??
            TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool isTotal = false, bool isNote = false, Color? valueColor}) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment:
            isNote ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    fontSize: 13.5,
                  ) ??
                  TextStyle(fontSize: 13.5, color: Colors.grey.shade700)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: isNote ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: valueColor ??
                    (isTotal
                        ? theme.colorScheme.error
                        : theme.textTheme.bodyLarge?.color ?? Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const String userFriendlyNoPrescriptionMessage =
        "Lịch hẹn này không có đơn thuốc.";
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Thanh toán lịch hẹn',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 8.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Thông tin lịch hẹn'),
                  Card(
                    color: Colors.white,
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                              context, 'Thú cưng:', appointment.tenthucung),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dịch vụ:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontSize: 13.5,
                                        ) ??
                                        TextStyle(
                                            fontSize: 13.5,
                                            color: Colors.grey.shade700)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: appointment.dichvu.map((service) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: RichText(
                                          textAlign: TextAlign.right,
                                          text: TextSpan(
                                            style: theme.textTheme.bodyLarge
                                                    ?.copyWith(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: theme.textTheme
                                                          .bodyLarge?.color ??
                                                      Colors.black87,
                                                ) ??
                                                TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black87,
                                                ),
                                            children: <TextSpan>[
                                              TextSpan(text: service.tendichvu),
                                              TextSpan(
                                                  text: ' - ',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              TextSpan(
                                                text: Utils.formatCurrency(
                                                    service.gia),
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.secondary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildInfoRow(
                              context,
                              'Ngày hẹn:',
                              Utils.formatDate(
                                  DateTime.parse(appointment.ngayhen))),
                          _buildInfoRow(
                              context, 'Giờ hẹn:', appointment.thoigianhen),
                          const Divider(height: 16, thickness: 0.5),
                          _buildInfoRow(
                              context,
                              'Tổng tiền dịch vụ:',
                              Utils.formatCurrency(controller
                                  .totalServiceCost), // Gọi trực tiếp getter
                              isTotal: true,
                              valueColor: Colors.blue[700]),
                        ],
                      ),
                    ),
                  ),
                  _buildSectionTitle(context, 'Thông tin đơn thuốc (nếu có)'),
                  Card(
                    color: Colors.white,
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      // Obx này đúng vì nó sử dụng các biến observable
                      child: Obx(() {
                        if (controller.isLoadingPrescription.value) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ));
                        }
                        if (controller.prescriptionError.value != null) {
                          bool isNoPrescriptionError =
                              controller.prescriptionError.value ==
                                  userFriendlyNoPrescriptionMessage;
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isNoPrescriptionError
                                        ? Icons.info_outline_rounded
                                        : Icons.error_outline_rounded,
                                    color: isNoPrescriptionError
                                        ? Colors.blueAccent
                                        : theme.colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      controller.prescriptionError.value!,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: isNoPrescriptionError
                                            ? Colors.blueGrey.shade700
                                            : theme.colorScheme.error,
                                      ),
                                      textAlign: isNoPrescriptionError
                                          ? TextAlign.left
                                          : TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final Prescription? prescription =
                            controller.selectedPrescription.value;
                        if (prescription == null) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                                child: Text('Lịch hẹn này không có đơn thuốc.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 13.5,
                                        color: Colors.grey.shade600))),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (prescription.ghichu != null &&
                                prescription.ghichu!.isNotEmpty) ...[
                              _buildInfoRow(context, 'Ghi chú đơn thuốc:',
                                  prescription.ghichu!,
                                  isNote: true),
                              const SizedBox(height: 6),
                            ],
                            ...prescription.chitiet.map((detail) => Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(
                                              '- ${detail.tenthuoc} (x${detail.soluong})',
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                      Text(
                                          Utils.formatCurrency(
                                              detail.giaban * detail.soluong),
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontSize: 13.5,
                                                  color: Colors.grey.shade800)),
                                    ],
                                  ),
                                )),
                            if (prescription.chitiet.isNotEmpty) ...[
                              const Divider(height: 16, thickness: 0.5),
                              _buildInfoRow(
                                  context,
                                  'Tổng tiền thuốc:',
                                  Utils.formatCurrency(
                                      controller.prescriptionSubTotal),
                                  isTotal: true,
                                  valueColor: Colors.blue[700]),
                            ] else
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Không có thuốc trong đơn này.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 13.5,
                                        fontStyle: FontStyle.italic)),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Chọn phương thức thanh toán:',
                      style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500) ??
                          const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedMethod.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.blue[700]!, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.0),
                          ),
                        ),
                        style:
                            theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                        items: controller.paymentMethods.map((method) {
                          return DropdownMenuItem(
                              value: method, child: Text(method));
                        }).toList(),
                        onChanged: (value) {
                          controller.onPaymentMethodChanged(value);
                        },
                      )),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          _buildBottomSummaryAndPayButton(context, theme),
        ],
      ),
    );
  }

  Widget _buildBottomSummaryAndPayButton(
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: 16.0 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CẦN THANH TOÁN:',
                    style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontSize: 11.5,
                        ) ??
                        TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    Utils.formatCurrency(controller.finalTotalAmount),
                    style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ) ??
                        TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.error),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              icon: controller.isProcessingVnPay.value
                  ? Container(
                      width: 18,
                      height: 18,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.payment_rounded, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: controller.isProcessingVnPay.value
                  ? null
                  : () => controller.handlePaymentButtonPressed(),
              label: Text(
                'Thanh toán',
                style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 14.5,
                      color: Colors.white,
                    ) ??
                    const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
              ),
            ),
          ],
        );
      }),
    );
  }
}
