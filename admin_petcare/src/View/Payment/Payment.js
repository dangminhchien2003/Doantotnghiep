import React, { useState, useEffect, useCallback } from "react";
import "@fortawesome/fontawesome-free/css/all.min.css";
import { toast, ToastContainer } from "react-toastify";
import url from "../../ipconfig";
import "./Payment.css";
import PaymentDetailModal from "../PaymentDetail/PaymentDetailModal";

const Payment = () => {
  const [payments, setPayments] = useState([]);
  const [filteredPayments, setFilteredPayments] = useState([]);

  const [startDate, setStartDate] = useState(""); // Ngày bắt đầu
  const [endDate, setEndDate] = useState(""); // Ngày kết thúc

  // State cho Modal chi tiết thanh toán
  const [isViewDetailModalOpen, setIsViewDetailModalOpen] = useState(false);
  const [selectedPaymentForDetail, setSelectedPaymentForDetail] =
    useState(null);
  const [isLoadingDetail, setIsLoadingDetail] = useState(false);

  const getPaymentStatusText = (status) => {
    // API trả về CAST(tt.trangthai AS CHAR) nên status có thể là chuỗi "0" hoặc "1"
    switch (String(status)) {
      case "0":
        return "Thanh toán chưa hoàn tất";
      case "1":
        return "Thanh toán thành công";
      default:
        return "Không xác định";
    }
  };

  // phân trang
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 6;

  // Tính toán các phần tử cho trang hiện tại
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentPayment = filteredPayments.slice(
    indexOfFirstItem,
    indexOfLastItem
  );

  const totalPages = Math.ceil(filteredPayments.length / itemsPerPage);

  // Hàm chuyển trang
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  // Load danh sách thanh toán ban đầu (hoặc tất cả)
  const loadAllPayments = useCallback(async () => {
    try {
      const response = await fetch(`${url}/Thanhtoan/getthanhtoan.php`);
      if (!response.ok) {
        throw new Error("Lỗi khi tải dữ liệu thanh toán");
      }
      const data = await response.json();
      if (data.success) {
        setPayments(data.danhsachthanhtoan || []);
        setFilteredPayments(data.danhsachthanhtoan || []);
      } else {
        setPayments([]);
        setFilteredPayments([]);
        // toast.info(data.message || "Không có dữ liệu thanh toán ban đầu.");
      }
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      setPayments([]);
      setFilteredPayments([]);
      toast.error("Không thể tải danh sách thanh toán. Vui lòng thử lại.");
    }
  }, []);

  // Hàm tìm kiếm thanh toán theo khoảng ngày
  const filterByDateRange = async () => {
    if (!startDate || !endDate) {
      toast.error("Vui lòng chọn cả ngày bắt đầu và ngày kết thúc.");
      return;
    }

    // Kiểm tra và định dạng lại ngày
    // Input type="date" thường đã trả về YYYY-MM-DD
    const isoStartDate = startDate;
    const isoEndDate = endDate;

    console.log("Tìm kiếm từ ngày:", isoStartDate, "Đến ngày:", isoEndDate);

    try {
      const response = await fetch(
        // Sử dụng đúng đường dẫn API tìm kiếm thanh toán bạn đã tạo
        `${url}/Thanhtoan/timkiemthanhtoan.php?startDate=${isoStartDate}&endDate=${isoEndDate}`
      );
      if (!response.ok) {
        throw new Error(`Lỗi HTTP: ${response.status}`);
      }
      const data = await response.json();
      console.log("Kết quả API tìm kiếm:", data);

      if (data.success) {
        setPayments(data.danhsachthanhtoan || []); // Cập nhật danh sách gốc
        setFilteredPayments(data.danhsachthanhtoan || []); // Cập nhật danh sách hiển thị
        if ((data.danhsachthanhtoan || []).length === 0) {
          toast.info(
            "Không tìm thấy thanh toán nào trong khoảng thời gian đã chọn."
          );
        } else {
          toast.success("Tìm kiếm thanh toán thành công!");
        }
      } else {
        setPayments([]);
        setFilteredPayments([]);
        toast.error(
          data.message || "Không có thanh toán nào trong khoảng thời gian này."
        );
      }
    } catch (error) {
      console.error("Lỗi API khi tìm kiếm thanh toán:", error);
      setPayments([]);
      setFilteredPayments([]);
      toast.error("Lỗi khi tìm kiếm thanh toán. Vui lòng thử lại.");
    }
  };

  useEffect(() => {
    loadAllPayments();
  }, [loadAllPayments]);

  // 3. Hàm để mở modal và fetch chi tiết thanh toán
  const handleOpenViewDetailsModal = async (paymentId) => {
    setIsLoadingDetail(true);
    setIsViewDetailModalOpen(true);
    setSelectedPaymentForDetail(null); // Xóa chi tiết cũ

    try {
      const response = await fetch(
        `${url}/Thanhtoan/get_completed_payment_details.php?idthanhtoan=${paymentId}`
      );

      if (!response.ok) {
        let errorMessage = "Lỗi khi tải chi tiết thanh toán";
        try {
          const errorData = await response.json();
          if (errorData && errorData.message) {
            errorMessage = errorData.message;
          }
        } catch (e) {
          // Bỏ qua lỗi parse JSON của lỗi
        }
        throw new Error(errorMessage);
      }

      const detailData = await response.json();
      if (detailData.success) {
        setSelectedPaymentForDetail(detailData.data);
      } else {
        throw new Error(
          detailData.message || "Không thể tải chi tiết thanh toán từ API."
        );
      }
    } catch (error) {
      console.error("Lỗi khi tải chi tiết thanh toán:", error);
      toast.error(
        error.message || "Không thể tải chi tiết thanh toán. Vui lòng thử lại."
      );
      setIsViewDetailModalOpen(false);
    } finally {
      setIsLoadingDetail(false);
    }
  };

  return (
    <div id="payment" className="payment-content-section">
      <ToastContainer style={{ top: 70, zIndex: 9999 }} />

      <div
        style={{ display: "flex", alignItems: "center", marginBottom: "20px" }}
      >
        <div className="date-filter-container">
          <label htmlFor="startDateInput">Từ ngày:</label>
          <input
            id="startDateInput"
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="date-input"
          />
          <label htmlFor="endDateInput" style={{ marginLeft: "10px" }}>
            Đến ngày:
          </label>
          <input
            id="endDateInput"
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            className="date-input"
          />
          <button
            onClick={filterByDateRange}
            className="search-button"
            style={{ marginLeft: "10px" }}
          >
            <i className="fas fa-search" style={{ marginRight: "5px" }}></i>
            Tìm kiếm
          </button>
          <button
            onClick={loadAllPayments}
            className="reload-button"
            style={{ marginLeft: "10px" }}
          >
            <i className="fas fa-sync-alt" style={{ marginRight: "5px" }}></i>
            Tải lại
          </button>
        </div>
      </div>

      <div id="paymentTable" className="payment-table">
        {filteredPayments.length > 0 ? (
          <table>
            <thead>
              <tr>
                <th>Mã Thanh toán</th>
                <th>Mã Lịch hẹn</th>
                <th>Tên người dùng</th>
                <th>Tên thú cưng</th>
                <th>Phương thức</th>
                <th>Ngày thanh toán</th>
                <th>Tổng tiền (VNĐ)</th>
                <th>Trạng thái TT</th>
                <th>Chức năng</th>
              </tr>
            </thead>
            <tbody>
              {/* {filteredPayments.map((payment) => ( */}
              {currentPayment.map((payment) => (
                <tr key={payment.idthanhtoan}>
                  <td>{payment.idthanhtoan}</td>
                  <td>{payment.idlichhen || "N/A"}</td>
                  <td>{payment.tennguoidung || "N/A"}</td>
                  <td>{payment.tenthucung || "N/A"}</td>
                  <td>{payment.phuongthuc}</td>
                  <td>
                    {new Date(payment.ngaythanhtoan).toLocaleDateString(
                      "vi-VN"
                    )}
                  </td>
                  <td>
                    {parseFloat(payment.tongtien).toLocaleString("vi-VN")}
                  </td>
                  <td>{getPaymentStatusText(payment.trangthaithanhtoan)}</td>
                  <td>
                    {/* Nếu chưa thanh toán, hiển thị nút nhắc nhở */}
                    {String(payment.trangthaithanhtoan) === "0" &&
                      payment.idlichhen && (
                        <button
                          onClick={() =>
                            toast.success(
                              "Tính năng đang được phát triển. Vui lòng thử lại sau!"
                            )
                          }
                          className="payment-action-button payment-remind-button"
                          title={`Nhắc nhở thanh toán cho lịch hẹn ${payment.idlichhen}`}
                        >
                          <i className="fas fa-bell"></i> Nhắc nhở
                        </button>
                      )}

                    {String(payment.trangthaithanhtoan) === "1" && (
                      <button
                        className="payment-action-button payment-detail-button"
                        onClick={() =>
                          handleOpenViewDetailsModal(payment.idthanhtoan)
                        }
                      >
                        <i className="fas fa-eye"></i> Xem chi tiết
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>Không có dữ liệu thanh toán để hiển thị.</p>
        )}
      </div>

      {filteredPayments.length > 0 && totalPages > 0 && (
        <div className="payment-pagination">
          <button
            className="payment-page-nav payment-page-prev"
            onClick={() => paginate(currentPage - 1)}
            disabled={currentPage === 1}
            aria-label="Trang trước"
          >
            <i className="fas fa-chevron-left"></i>
          </button>
          <span className="payment-page-current">{currentPage}</span>
          <button
            className="payment-page-nav payment-page-next"
            onClick={() => paginate(currentPage + 1)}
            disabled={currentPage === totalPages}
            aria-label="Trang sau"
          >
            <i className="fas fa-chevron-right"></i>
          </button>
        </div>
      )}

      <PaymentDetailModal
        isOpen={isViewDetailModalOpen}
        onClose={() => setIsViewDetailModalOpen(false)}
        paymentDetails={selectedPaymentForDetail}
        isLoading={isLoadingDetail}
        onConfirm={() => {
          /* No action needed for view-only mode */
        }}
      />
    </div>
  );
};

export default Payment;
