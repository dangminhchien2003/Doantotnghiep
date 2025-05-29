import React, { useState, useEffect } from 'react';
import './PaymentDetailModal.css'; 

const convertLichHenTrangThaiTrongModal = (trangThai) => {
  const trangThaiMap = {
    "0": "Chờ xác nhận",
    "1": "Đã xác nhận",
    "2": "Đang thực hiện",
    "3": "Hoàn thành",
    "4": "Đã hủy",
    "5": "Đã thanh toán",
    "6": "Đang thanh toán",
  };
  return trangThaiMap[String(trangThai)] || trangThai || "Không xác định"; // Trả về mã nếu không tìm thấy, hoặc "Không xác định"
};

const PaymentDetailModal = ({ isOpen, onClose, paymentDetails, isLoading, onConfirm }) => {
  const [totalServiceCost, setTotalServiceCost] = useState(0);
  const [totalPrescriptionCost, setTotalPrescriptionCost] = useState(0);
  const [grandTotal, setGrandTotal] = useState(0);

  // Xác định xem modal đang ở chế độ xem (view mode) hay chế độ xác nhận (confirm mode)
  // Chế độ xem: khi có thông tin giao dịch (transactionInfo) VÀ trạng thái lịch hẹn là "5" (Đã thanh toán)
  const isViewOnlyMode = paymentDetails?.transactionInfo && paymentDetails?.lichhen?.trangthai === "5";

  useEffect(() => {
    if (paymentDetails && !isLoading) {
      let serviceCost = 0;
      if (paymentDetails.services && Array.isArray(paymentDetails.services)) {
        serviceCost = paymentDetails.services.reduce((sum, service) => sum + parseFloat(service.gia || 0), 0);
      }

      let prescriptionCost = 0;
      if (paymentDetails.prescription && paymentDetails.prescription.items && Array.isArray(paymentDetails.prescription.items)) {
        prescriptionCost = paymentDetails.prescription.items.reduce((sum, item) => sum + (parseFloat(item.soluong || 0) * parseFloat(item.giaban || 0)), 0);
      }
      
      setTotalServiceCost(serviceCost);
      setTotalPrescriptionCost(prescriptionCost);

      // Nếu ở chế độ xem và có thông tin tiền đã trả, ưu tiên hiển thị số tiền đó
      if (isViewOnlyMode && paymentDetails.transactionInfo && typeof paymentDetails.transactionInfo.tongtien_paid !== 'undefined') {
        setGrandTotal(parseFloat(paymentDetails.transactionInfo.tongtien_paid));
      } else {
        setGrandTotal(serviceCost + prescriptionCost); // Tổng tính toán cho trường hợp xác nhận
      }
    } else {
      setTotalServiceCost(0);
      setTotalPrescriptionCost(0);
      setGrandTotal(0);
    }
  }, [paymentDetails, isLoading, isViewOnlyMode]); // Thêm isViewOnlyMode vào dependencies

  if (!isOpen) {
    return null;
  }

  return (
    <div className="payment-detail-modal-overlay"> 
      <div className="payment-detail-modal-content" style={{ width: '700px', maxHeight: '80vh', overflowY: 'auto' }}>
        <h3>
          {isViewOnlyMode ? "Chi Tiết Thanh Toán Đã Hoàn Tất" : "Xác Nhận Thông Tin Thanh Toán"}
        </h3>
        {isLoading && <p>Đang tải chi tiết hóa đơn...</p>}
        {!isLoading && paymentDetails && (
          <div>
            <h4>Thông Tin Lịch Hẹn</h4>
            <p><strong>Mã Lịch Hẹn:</strong> {paymentDetails.lichhen?.idlichhen}</p>
            <p><strong>Tên Khách Hàng:</strong> {paymentDetails.lichhen?.tennguoidung}</p>
            <p><strong>Số điện thoại:</strong> {paymentDetails.lichhen?.sodienthoai}</p>
            <p><strong>Tên Thú Cưng:</strong> {paymentDetails.lichhen?.tenthucung}</p>
            <p><strong>Ngày Hẹn:</strong> {paymentDetails.lichhen?.ngayhen} - {paymentDetails.lichhen?.thoigianhen}</p>
            
           
            <p>
              <strong>Trạng thái lịch hẹn: </strong> 
              {paymentDetails.lichhen?.trangthai 
                ? convertLichHenTrangThaiTrongModal(paymentDetails.lichhen.trangthai) 
                : 'N/A'}
            </p>
            <hr />
            <h4>Chi Tiết Dịch Vụ</h4>
            {paymentDetails.services && paymentDetails.services.length > 0 ? (
              <table className="payment-detail-info-table"> 
                <thead>
                  <tr><th>Tên Dịch Vụ</th><th>Giá</th></tr>
                </thead>
                <tbody>
                {paymentDetails.services.map((service, index) => (
                  <tr key={`service-${service.iddichvu || index}`}>
                    <td>{service.tendichvu}</td>
                    <td>{parseFloat(service.gia || 0).toLocaleString('vi-VN')} VNĐ</td>
                  </tr>
                ))}
                </tbody>
              </table>
            ) : <p>Không có dịch vụ.</p>}
            <div className="payment-detail-total-section">
              <p><strong>Tổng tiền dịch vụ: {totalServiceCost.toLocaleString('vi-VN')} VNĐ</strong></p>
            </div>

            {paymentDetails.prescription && paymentDetails.prescription.iddonthuoc && (
              <>
                <hr />
                <h4>Chi Tiết Đơn Thuốc (Mã đơn: {paymentDetails.prescription.iddonthuoc})</h4>
                {/* ... (phần hiển thị bảng chi tiết đơn thuốc giữ nguyên) ... */}
                {paymentDetails.prescription.items && paymentDetails.prescription.items.length > 0 ? (
                  <table className="payment-detail-info-table">
                    <thead>
                      <tr>
                        <th>Tên Thuốc</th>
                        <th>Số Lượng</th>
                        <th>Đơn Giá</th>
                        <th>Thành Tiền</th>
                      </tr>
                    </thead>
                    <tbody>
                      {paymentDetails.prescription.items.map((item, index) => (
                        <tr key={`item-${item.idthuoc || index}`}>
                          <td>{item.tenthuoc}</td>
                          <td>{item.soluong}</td>
                          <td>{parseFloat(item.giaban || 0).toLocaleString('vi-VN')} VNĐ</td>
                          <td>{(parseFloat(item.soluong || 0) * parseFloat(item.giaban || 0)).toLocaleString('vi-VN')} VNĐ</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                ) : <p>Đơn thuốc không có thuốc nào.</p>}
                <div className="payment-detail-total-section">
                  <p><strong>Tổng tiền thuốc: {totalPrescriptionCost.toLocaleString('vi-VN')} VNĐ</strong></p>
                </div>
              </>
            )}
            
            {/* HIỂN THỊ THÔNG TIN GIAO DỊCH NẾU ĐANG Ở CHẾ ĐỘ XEM VÀ CÓ transactionInfo */}
            {isViewOnlyMode && paymentDetails.transactionInfo && (
              <>
                <hr />
                <h4>Thông Tin Giao Dịch Đã Thanh Toán</h4>
                <p><strong>Mã thanh toán (Hóa đơn):</strong> {paymentDetails.transactionInfo.idthanhtoan}</p>
                <p><strong>Phương thức:</strong> {paymentDetails.transactionInfo.phuongthuc}</p>
                <p><strong>Ngày thanh toán:</strong> 
                  {paymentDetails.transactionInfo.ngaythanhtoan_actual 
                    ? new Date(paymentDetails.transactionInfo.ngaythanhtoan_actual).toLocaleString('vi-VN') 
                    : 'N/A'}
                </p>
                <p><strong>Số tiền đã trả:</strong> 
                  {typeof paymentDetails.transactionInfo.tongtien_paid !== 'undefined' 
                    ? parseFloat(paymentDetails.transactionInfo.tongtien_paid).toLocaleString('vi-VN') 
                    : 'N/A'} VNĐ
                </p>
                {paymentDetails.transactionInfo.vnp_transaction_no && <p><strong>Mã GD VNPAY:</strong> {paymentDetails.transactionInfo.vnp_transaction_no}</p>}
                {paymentDetails.transactionInfo.vnp_bank_code && <p><strong>Ngân hàng (VNPAY):</strong> {paymentDetails.transactionInfo.vnp_bank_code}</p>}
              </>
            )}

            <hr style={{borderTop: '2px solid #333', margin: '20px 0'}}/>
            <div className="payment-detail-total-section">
              <h4 style={{fontSize: '1.3em'}}>
                {isViewOnlyMode ? "SỐ TIỀN ĐÃ THANH TOÁN:" : "TỔNG CỘNG PHẢI THANH TOÁN:"} {grandTotal.toLocaleString('vi-VN')} VNĐ
              </h4>
            </div>
          </div>
        )}
        {!isLoading && !paymentDetails && <p>Không thể tải chi tiết thanh toán. Vui lòng thử lại.</p>}

        <div className="payment-detail-modal-actions"> 
          {/* Chỉ hiển thị nút "Xác Nhận Thanh Toán" nếu không phải đang ở chế độ xem */}
          {!isViewOnlyMode && (
            <button
              className="payment-detail-button-confirm" 
              onClick={() => {
                if (paymentDetails?.lichhen?.idlichhen && onConfirm) { // Kiểm tra onConfirm tồn tại
                  onConfirm(paymentDetails.lichhen.idlichhen);
                }
              }}
              disabled={isLoading || !paymentDetails}
            >
              Xác Nhận Thanh Toán
            </button>
          )}
          <button
            className="payment-detail-button-close" 
            onClick={onClose}
            disabled={isLoading}
          >
            Đóng
          </button>
        </div>
      </div>
    </div>
  );
};

export default PaymentDetailModal;