import React, { useEffect, useMemo, useState } from "react";
import "./Booking.css";
import url from "../../ipconfig";
import AddPrescription from "../Prescription/AddPrescription";
import PrescriptionDetail from "../Prescription/PrescriptionDetail";
import "react-toastify/dist/ReactToastify.css";
import { toast, ToastContainer } from "react-toastify";
import { Tabs, Tab } from "@mui/material";
import PaymentDetailModal from "../PaymentDetail/PaymentDetailModal";

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faEye,
  faPlusCircle,
  faCheckCircle,
  faTimesCircle,
  faPlayCircle,
  faCreditCard,
  faMoneyCheckAlt,
  faBell,
  faBan,
} from "@fortawesome/free-solid-svg-icons";

const Bookings = () => {
  const [bookings, setBookings] = useState([]);
  const [value, setValue] = useState(0);

  const [isModalOpen, setIsModalOpen] = useState(false);
  const [cancelReason, setCancelReason] = useState("");
  const [bookingIdToCancel, setBookingIdToCancel] = useState(null);

  const [startDate, setStartDate] = useState(""); // Ngày bắt đầu
  const [endDate, setEndDate] = useState(""); // Ngày kết thúc

  const [isAddPrescriptionOpen, setIsAddPrescriptionOpen] = useState(false);
  const [isPrescriptionDetailOpen, setIsPrescriptionDetailOpen] =
    useState(false);
  const [selectedBookingId, setSelectedBookingId] = useState(null);

  //trạng thái hủy
  const [isViewReasonModalOpen, setIsViewReasonModalOpen] = useState(false);
  const [reasonToView, setReasonToView] = useState("");
  const [selectedBookingForReason, setSelectedBookingForReason] =
    useState(null);

  // State mới để theo dõi xem modal PrescriptionDetail có cho phép sửa không
  const [isPrescriptionDetailEditable, setIsPrescriptionDetailEditable] =
    useState(false);

  const [isPaymentModalOpen, setIsPaymentModalOpen] = useState(false);
  const [paymentDetails, setPaymentDetails] = useState(null); // Sẽ lưu chi tiết lịch hẹn, dịch vụ, đơn thuốc
  const [isLoadingPaymentDetails, setIsLoadingPaymentDetails] = useState(false);

  // State cho Modal Xem Chi Tiết Lịch Hẹn
  const [isViewDetailModalOpen, setIsViewDetailModalOpen] = useState(false);
  const [selectedBookingForDetail, setSelectedBookingForDetail] =
    useState(null);

  // Lọc lịch hẹn theo tab
  const filteredbookings = bookings.filter((booking) => {
    if (value === 0 && booking.trangthai === "0") return true; // Chờ xác nhận
    if (value === 1 && booking.trangthai === "1") return true; // Đã xác nhận
    if (value === 2 && booking.trangthai === "2") return true; // Đang thực hiện
    if (value === 3 && booking.trangthai === "3") return true; // Hoàn thành
    if (value === 4 && booking.trangthai === "6") return true; // Đang thanh toán (MỚI)
    if (value === 5 && booking.trangthai === "5") return true; // Đã thanh toán
    if (value === 6 && booking.trangthai === "4") return true; // Đã hủy
    return false;
  });

  // Tính toán số lượng lịch hẹn cho mỗi trạng thái
  const statusCounts = useMemo(() => {
    const counts = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
    };
    // Đếm từ danh sách `bookings` (danh sách gốc, không bị lọc bởi tab)
    bookings.forEach((booking) => {
      const status = String(booking.trangthai);
      if (counts.hasOwnProperty(status)) {
        counts[status]++;
      }
    });
    return counts;
  }, [bookings]);

  // Load danh sách đặt lịch
  const loadBookings = async () => {
    try {
      const response = await fetch(`${url}Lichhen/getlichhen.php`);
      if (!response.ok) {
        throw new Error("Lỗi khi tải danh sách đặt lịch");
      }
      const data = await response.json();

      console.log("Bookings data from API:", data);
      setBookings(data);
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      toast.error("Không thể tải danh sách đặt lịch. Vui lòng thử lại.");
    }
  };

  const filterByDate = async (startDate, endDate) => {
    console.log("Ngày bắt đầu:", startDate, "Ngày kết thúc:", endDate);

    // Kiểm tra và định dạng lại ngày
    const formattedStartDate = new Date(startDate);
    const formattedEndDate = new Date(endDate);

    if (
      isNaN(formattedStartDate.getTime()) ||
      isNaN(formattedEndDate.getTime())
    ) {
      toast.error("Ngày không hợp lệ!");
      return; // Dừng nếu ngày không hợp lệ
    }

    const isoStartDate = formattedStartDate.toISOString().split("T")[0];
    const isoEndDate = formattedEndDate.toISOString().split("T")[0];
    console.log("Ngày định dạng:", isoStartDate, isoEndDate);

    try {
      const response = await fetch(
        `${url}/Lichhen/timkiemlichhen.php?startDate=${isoStartDate}&endDate=${isoEndDate}`
      );
      const data = await response.json();
      console.log("Kết quả API tìm kiếm:", data);

      if (data.success) {
        setBookings(data.lichhen);
        toast.success("Tìm kiếm thành công");
      } else {
        setBookings([]);
        toast.error(
          data.message || "Không có lịch hẹn trong khoảng thời gian này."
        );
      }
    } catch (error) {
      console.error("Lỗi API tìm kiếm:", error);
      toast.error("Không thể tải danh sách đặt lịch. Vui lòng thử lại.");
    }
  };

  // Xác nhận đặt lịch
  const confirmBooking = async (idlichhen) => {
    try {
      const response = await fetch(`${url}/Lichhen/xacnhanlichhen.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ idlichhen }),
      });

      if (!response.ok) {
        throw new Error("Lỗi khi xác nhận lịch hẹn");
      }

      loadBookings();
      toast.success("Lịch hẹn đã được xác nhận!");
    } catch (error) {
      console.error("Lỗi khi xác nhận:", error);
      toast.error("Không thể xác nhận lịch hẹn. Vui lòng thử lại.");
    }
  };

  // thực hiện lịch hẹn
  const performBooking = async (idlichhen) => {
    try {
      const response = await fetch(`${url}/Lichhen/thuchienlichhen.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ idlichhen }),
      });

      if (!response.ok) {
        throw new Error("Lỗi khi thực hiện lịch hẹn");
      }
      loadBookings();
      toast.success("Lịch hẹn đã bắt đầu thực hiện");
    } catch (error) {
      console.error("Lỗi khi thực hiện:", error);
      toast.error("Không thể thực hiện lịch hẹn. Vui lòng thử lại.");
    }
  };

  // Hoàn thành lịch hẹn
  const completeBooking = async (idlichhen) => {
    try {
      const response = await fetch(`${url}/Lichhen/hoanthanhlichhen.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ idlichhen }),
      });

      if (!response.ok) {
        throw new Error("Lỗi khi hoàn thành lịch hẹn");
      }
      loadBookings();
      toast.success("Lịch hẹn đã được hoàn thành");
    } catch (error) {
      console.error("Lỗi khi hoàn thành:", error);
      toast.error("Không thể hoàn thành lịch hẹn. Vui lòng thử lại.");
    }
  };
  //lấy thông tin thanh toán
  const handleOpenPaymentModal = async (bookingId) => {
    setSelectedBookingId(bookingId);
    setIsLoadingPaymentDetails(true);
    setIsPaymentModalOpen(true);
    setPaymentDetails(null); // Xóa chi tiết cũ

    try {
      const response = await fetch(
        `${url}Thanhtoan/get_payment_details.php?idlichhen=${bookingId}`
      );

      if (!response.ok) {
        let errorMessage = "Lỗi khi tải chi tiết thanh toán";
        try {
          const errorData = await response.json();
          if (errorData && errorData.message) {
            errorMessage = errorData.message;
          }
        } catch (e) {}
        throw new Error(errorMessage);
      }

      const detailsData = await response.json();
      if (detailsData.success) {
        setPaymentDetails(detailsData.data);
      } else {
        throw new Error(
          detailsData.message || "Không thể tải chi tiết thanh toán từ API"
        );
      }
    } catch (error) {
      console.error("Lỗi khi tải chi tiết thanh toán:", error);
      toast.error(
        error.message || "Không thể tải chi tiết thanh toán. Vui lòng thử lại."
      );
      setIsPaymentModalOpen(false); // Đóng modal nếu có lỗi nghiêm trọng
    } finally {
      setIsLoadingPaymentDetails(false);
    }
  };

  // Thanh toán lịch hẹn
  const payBooking = async (idlichhen) => {
    try {
      const response = await fetch(`${url}Lichhen/Xacnhanthanhtoan.php`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idlichhen }),
      });

      if (!response.ok) {
        // Nếu response không OK (ví dụ: 500, 400, 404)
        let errorMessage = "Lỗi khi xác nhận thanh toán";
        try {
          // Thử đọc JSON lỗi từ server, vì server PHP của bạn có trả về JSON khi lỗi
          const errorData = await response.json();
          if (errorData && errorData.message) {
            errorMessage = errorData.message; // Lấy thông báo lỗi từ server
          }
        } catch (jsonError) {
          // Nếu không parse được JSON, hoặc server không trả JSON
          console.error(
            "Không thể parse JSON lỗi từ server hoặc server không trả JSON:",
            jsonError
          );
          // errorMessage vẫn là "Lỗi khi xác nhận thanh toán"
        }
        throw new Error(errorMessage); // Ném lỗi với thông điệp từ server (nếu có) hoặc thông điệp mặc định
      }

      const data = await response.json(); // Nếu response.ok là true
      if (data.success) {
        loadBookings();
        toast.success(data.message || "Lịch hẹn đã được thanh toán");
      } else {
        toast.error(data.message || "Không thể xác nhận thanh toán.");
      }
    } catch (error) {
      console.error("Lỗi khi thanh toán:", error); // Sẽ log ra lỗi với message từ server (nếu có)
      toast.error(
        error.message || "Không thể xác nhận thanh toán. Vui lòng thử lại."
      );
    }
  };

  // Hủy lịch hẹn
  const cancelBooking = async () => {
    if (!cancelReason.trim()) {
      // Kiểm tra lý do không được để trống
      toast.error("Vui lòng nhập lý do hủy.");
      return;
    }

    try {
      const sender = "Admin"; // Hoặc currentUser.name nếu bạn có thông tin người dùng đóng vai trò người gửi
      const reasonWithSender = `[${sender}]: ${cancelReason}`; // Thêm người gửi vào lý do

      const response = await fetch(`${url}/Lichhen/huylichhen.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          idlichhen: bookingIdToCancel,
          reason: reasonWithSender, // Gửi lý do đã có thông tin người gửi
        }),
      });

      if (!response.ok) {
        let errorMessage = "Lỗi khi hủy lịch hẹn";
        try {
          const errorData = await response.json();
          if (errorData && errorData.message) {
            errorMessage = errorData.message;
          }
        } catch (e) {
          // Bỏ qua nếu không parse được JSON lỗi
        }
        throw new Error(errorMessage);
      }

      const data = await response.json();

      if (data.success) {
        loadBookings();
        closeCancelModal();
        toast.success(data.message || "Lịch hẹn đã được hủy thành công!");
      } else {
        toast.error(
          data.message || "Không thể hủy lịch hẹn. Vui lòng thử lại."
        );
      }
    } catch (error) {
      console.error("Lỗi khi hủy lịch hẹn:", error);
      toast.error(error.message || "Không thể hủy lịch hẹn. Vui lòng thử lại.");
    }
  };

  const openCancelModal = (idlichhen) => {
    setBookingIdToCancel(idlichhen);
    setIsModalOpen(true);
  };

  const closeCancelModal = () => {
    setIsModalOpen(false);
    setCancelReason("");
  };

  // Load danh sách đặt lịch khi component mount lần đầu
  useEffect(() => {
    loadBookings();
  }, []); // Mảng dependency rỗng để chỉ chạy 1 lần khi mount

  const convertTrangThai = (trangThai) => {
    const trangThaiMap = {
      0: "Chờ xác nhận",
      1: "Đã xác nhận",
      2: "Đang thực hiện", // Sửa lỗi chính tả "hiên" -> "hiện"
      3: "Hoàn thành",
      4: "Đã hủy",
      5: "Đã thanh toán",
      6: "Đang thanh toán", // Trạng thái mới
    };
    return trangThaiMap[String(trangThai)] || "Không xác định"; // Đảm bảo trangThai là chuỗi khi truy vấn
  };

  const handleChange = (event, newValue) => {
    setValue(newValue);
  };
  const openViewReasonModal = (bookings) => {
    // Giả sử API đã trả về trường 'lydohuy' trong object booking
    if (bookings.lydohuy) {
      setReasonToView(bookings.lydohuy);
      setSelectedBookingForReason(bookings); // Lưu lại booking để hiển thị thêm thông tin nếu cần
      setIsViewReasonModalOpen(true);
    } else {
      // Nếu API không trả về lydohuy (có thể do lịch hẹn không bị hủy theo cách có ghi lý do, hoặc API chưa cập nhật)
      // Bạn có thể hiển thị một thông báo mặc định hoặc không làm gì cả
      setReasonToView("Không có lý do hủy được cung cấp.");
      setSelectedBookingForReason(bookings);
      setIsViewReasonModalOpen(true);
      // Hoặc:
      // toast.info("Không có lý do hủy cho lịch hẹn này.");
    }
  };

  const closeViewReasonModal = () => {
    setIsViewReasonModalOpen(false);
    setReasonToView("");
    setSelectedBookingForReason(null);
  };

  //Hàm mở/đóng Modal Xem Chi Tiết Lịch Hẹn
  const openViewDetailModal = (booking) => {
    setSelectedBookingForDetail(booking);
    setIsViewDetailModalOpen(true);
  };

  const closeViewDetailModal = () => {
    setSelectedBookingForDetail(null);
    setIsViewDetailModalOpen(false);
  };

  return (
    <div id="bookings" className="booking-content-section">
      {/* ToastContainer đặt ở đây để hiển thị thông báo */}
      <ToastContainer style={{ top: 70 }} />

      <div style={{ display: "flex", alignItems: "center" }}>
        <div className="date-filter-container">
          <label>Từ ngày:</label>
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="date-input"
          />
          <label>Đến ngày:</label>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            className="date-input"
          />
          <button
            onClick={() => filterByDate(startDate, endDate)}
            className="search-button"
          >
            Tìm kiếm
          </button>
          <button onClick={() => loadBookings()} className="reload-button">
            Tải lại
          </button>
        </div>
      </div>

      {/* Tab chọn trạng thái */}
      <Tabs
        className="status-tabs"
        value={value}
        onChange={handleChange}
        aria-label="Appointment Status Tabs"
        variant="scrollable" // Giúp các tab có thể cuộn nếu quá nhiều
        scrollButtons="auto" // Tự động hiển thị nút cuộn
      >
        {/* <Tab className="status-tab" label="Chờ xác nhận" />{" "}
        <Tab className="status-tab" label="Đã xác nhận" />{" "}
        <Tab className="status-tab" label="Đang thực hiện" />{" "}
        <Tab className="status-tab" label="Hoàn thành" />{" "}
        <Tab className="status-tab" label="Đang thanh toán" />{" "}
        <Tab className="status-tab" label="Đã thanh toán" />{" "}
        <Tab className="status-tab" label="Đã hủy" />{" "}
      </Tabs> */}
        <Tab
          className="status-tab"
          label={`Chờ xác nhận (${statusCounts["0"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Đã xác nhận (${statusCounts["1"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Đang thực hiện (${statusCounts["2"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Hoàn thành (${statusCounts["3"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Đang thanh toán (${statusCounts["6"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Đã thanh toán (${statusCounts["5"] || 0})`}
        />
        <Tab
          className="status-tab"
          label={`Đã hủy (${statusCounts["4"] || 0})`}
        />
      </Tabs>

      <div id="bookingsTable">
        {filteredbookings.length > 0 ? (
          <table className="booking-table">
            <thead>
              <tr>
                <th>Mã</th>
                <th>Người Dùng</th>
                <th>Thú Cưng</th>
                <th>Số điện thoại</th>
                <th>Tên Dịch Vụ</th>
                <th>Ngày Hẹn</th>
                <th>Thời Gian Hẹn</th>
                <th>Trạng Thái</th>
                <th>Ngày Tạo</th>
                <th>Đơn Thuốc</th>
                <th>Chức Năng</th>
              </tr>
            </thead>
            <tbody>
              {filteredbookings.map((booking) => (
                <tr key={booking.idlichhen}>
                  <td>{booking.idlichhen}</td>
                  <td>{booking.tennguoidung}</td>
                  <td>{booking.tenthucung}</td>
                  <td>{booking.sodienthoai}</td>
                  <td>{booking.tendichvu}</td>
                  <td>{booking.ngayhen}</td>
                  <td>{booking.thoigianhen}</td>
                  <td>{convertTrangThai(booking.trangthai)}</td>
                  <td>{booking.ngaytao}</td>
                  {/* === LOGIC HIỂN THỊ NÚT ĐƠN THUỐC ĐÃ SỬA ĐỔI === */}
                  <td>
                    {/* Kiểm tra trạng thái có liên quan đến đơn thuốc không */}
                    {booking.trangthai === "2" ||
                    booking.trangthai === "3" ||
                    booking.trangthai === "5" ||
                    booking.trangthai === "6" ? (
                      // Kiểm tra xem booking này đã có đơn thuốc chưa (dựa vào trường idonthuoc từ API)
                      booking.iddonthuoc ? (
                        // Nếu đã có idonthuoc, chỉ hiển thị nút "Xem đơn"
                        <div className="booking-actions">
                          <button
                            // className="prescription-button"
                            className="prescription-button icon-button"
                            aria-label="Xem đơn thuốc"
                            title="Xem đơn thuốc"
                            onClick={() => {
                              setSelectedBookingId(booking.idlichhen);
                              const editable = booking.trangthai === "2"; // Chỉ cho phép sửa nếu trạng thái là "Đang thực hiện"
                              setIsPrescriptionDetailEditable(editable);
                              setIsPrescriptionDetailOpen(true); // Mở modal xem
                            }}
                          >
                            {/* Xem đơn */}
                            <FontAwesomeIcon icon={faEye} />
                          </button>
                        </div>
                      ) : // Nếu chưa có idonthuoc
                      booking.trangthai === "2" ? ( // Chỉ cho phép thêm đơn khi đang thực hiện
                        <div className="booking-actions">
                          <button
                            // className="add-prescription-button"
                            className="add-prescription-button icon-button"
                            aria-label="Thêm đơn thuốc"
                            title="Thêm đơn thuốc"
                            onClick={() => {
                              setSelectedBookingId(booking.idlichhen);
                              setIsAddPrescriptionOpen(true); // Mở modal thêm
                            }}
                          >
                            {/* Thêm đơn */}
                            <FontAwesomeIcon icon={faPlusCircle} />
                          </button>
                        </div>
                      ) : (
                        // Nếu chưa có đơn và ở trạng thái Hoàn thành (3) hoặc Đã thanh toán (5)
                        <span style={{ color: "#888" }}>Chưa có đơn</span>
                      )
                    ) : (
                      // Các trạng thái khác (0, 1, 4) không áp dụng đơn thuốc
                      <span style={{ color: "#888" }}>Chưa áp dụng</span>
                    )}
                  </td>

                  <td>
                    {booking.trangthai === "0" ? ( // Nếu trạng thái là "Chờ xác nhận"
                      <div className="booking-actions">
                        <button
                          onClick={() => openViewDetailModal(booking)}
                          className="view-detail-button icon-button" // Bạn có thể thêm class này vào CSS để tùy chỉnh
                          aria-label="Xem chi tiết lịch hẹn"
                          title="Xem chi tiết lịch hẹn"
                        >
                          <FontAwesomeIcon icon={faEye} />
                        </button>
                        <button
                          onClick={() => confirmBooking(booking.idlichhen)}
                          // className="confirm-button"
                          className="confirm-button icon-button"
                          aria-label="Xác nhận lịch hẹn"
                        >
                          {/* Xác Nhận */}
                          <FontAwesomeIcon icon={faCheckCircle} />
                        </button>
                        <button
                          onClick={() => openCancelModal(booking.idlichhen)}
                          // className="cancel-button"
                          className="cancel-button icon-button"
                          aria-label="Hủy lịch hẹn"
                        >
                          {/* Hủy */}
                          <FontAwesomeIcon icon={faTimesCircle} />
                        </button>
                      </div>
                    ) : booking.trangthai === "1" ? ( // Nếu trạng thái là "Đã xác nhận"
                      <div className="booking-actions">
                        <button
                          onClick={() => openViewDetailModal(booking)}
                          className="view-detail-button icon-button" // Bạn có thể thêm class này vào CSS để tùy chỉnh
                          aria-label="Xem chi tiết lịch hẹn"
                          title="Xem chi tiết lịch hẹn"
                        >
                          <FontAwesomeIcon icon={faEye} />
                        </button>
                        <button
                          onClick={() => {
                            if (
                              window.confirm(
                                "Bạn có chắc chắn muốn xác nhận thực hiện lịch hẹn này không?"
                              )
                            ) {
                              performBooking(booking.idlichhen);
                            }
                          }}
                          // className="perform-button"
                          className="perform-button icon-button"
                          aria-label="Thực hiện lịch hẹn"
                          title="Thực hiện lịch hẹn"
                        >
                          {/* Thực hiện */}
                          <FontAwesomeIcon icon={faPlayCircle} />
                        </button>
                      </div>
                    ) : booking.trangthai === "2" ? ( // Nếu trạng thái là "Đang thực hiện"
                      <div className="booking-actions">
                        <button
                          onClick={() => openViewDetailModal(booking)}
                          className="view-detail-button icon-button"
                          aria-label="Xem chi tiết lịch hẹn"
                          title="Xem chi tiết lịch hẹn"
                        >
                          {" "}
                          <FontAwesomeIcon icon={faEye} />
                        </button>
                        <button
                          onClick={
                            () => {
                              if (
                                window.confirm(
                                  "Bạn có chắc chắn muốn xác nhận hoàn thành lịch hẹn này không?"
                                )
                              ) {
                                completeBooking(booking.idlichhen);
                              }
                            }
                            // completeBooking(booking.idlichhen)
                          }
                          // className="complete-button"
                          className="complete-button icon-button"
                          aria-label="Hoàn thành lịch hẹn"
                          title="Hoàn thành lịch hẹn"
                        >
                          {/* Hoàn thành */}
                          <FontAwesomeIcon icon={faCheckCircle} />
                        </button>
                      </div>
                    ) : booking.trangthai === "3" ? ( // Nếu trạng thái là "Hoàn thành"
                      <div className="booking-actions">
                        <button
                          onClick={() => openViewDetailModal(booking)}
                          className="view-detail-button icon-button"
                          aria-label="Xem chi tiết lịch hẹn"
                          title="Xem chi tiết lịch hẹn"
                        >
                          {" "}
                          <FontAwesomeIcon icon={faEye} />
                        </button>
                        <button
                          onClick={() =>
                            handleOpenPaymentModal(booking.idlichhen)
                          }
                          // className="pay-button"
                          className="pay-button icon-button"
                          aria-label="Tiến hành thanh toán"
                          title="Thanh toán lịch hẹn"
                        >
                          {/* Thanh toán */}
                          <FontAwesomeIcon icon={faCreditCard} />
                        </button>
                      </div>
                    ) : booking.trangthai === "6" ? ( // Đang thanh toán
                      <div className="booking-actions">
                        <button
                          onClick={() => openViewDetailModal(booking)}
                          className="view-detail-button icon-button"
                          aria-label="Xem chi tiết lịch hẹn"
                          title="Xem chi tiết lịch hẹn"
                        >
                          {" "}
                          <FontAwesomeIcon icon={faEye} />
                        </button>
                        <button
                          onClick={() => {
                            if (
                              window.confirm(
                                "Bạn có chắc chắn muốn xác nhận thanh toán cho lịch hẹn này không?"
                              )
                            ) {
                              payBooking(booking.idlichhen);
                            }
                          }}
                          className="pay-button icon-button"
                          aria-label="Xác nhận thanh toán"
                          title="Xác nhận thanh toán"
                        >
                          <FontAwesomeIcon icon={faMoneyCheckAlt} />
                        </button>

                        <button
                          onClick={() =>
                            toast.success(
                              "Tính năng đang được phát triển. Vui lòng thử lại sau!"
                            )
                          }
                          // className="remind-button"
                          className="remind-button icon-button"
                          aria-label="Gửi nhắc nhở thanh toán"
                          title="Gửi nhắc nhở thanh toán"
                          // style={{ backgroundColor: "#17a2b8", color: "white" }}
                        >
                          {/* Nhắc nhở */}
                          <FontAwesomeIcon icon={faBell} />
                        </button>
                      </div>
                    ) : booking.trangthai === "5" ? ( // === TRẠNG THÁI ĐÃ THANH TOÁN  ===
                      <button
                        onClick={() =>
                          handleOpenPaymentModal(booking.idlichhen)
                        }
                        // className="view-payment-button"
                        className="view-payment-button icon-button"
                        aria-label="Xem thông tin thanh toán"
                      >
                        {/* Xem TT Thanh Toán */}
                        <FontAwesomeIcon icon={faEye} />
                        {/* hoặc faFileInvoiceDollar */}
                      </button>
                    ) : booking.trangthai === "4" ? ( // === TRẠNG THÁI ĐÃ HỦY  ===
                      <button
                        onClick={() => openViewReasonModal(booking)}
                        // className="view-reason-button"
                        className="view-reason-button icon-button"
                        aria-label="Xem lý do hủy"
                        title="Xem lý do hủy"
                      >
                        {/* Xem Lý Do Hủy */}
                        <FontAwesomeIcon icon={faEye} />{" "}
                        {/* hoặc faQuestionCircle */}
                      </button>
                    ) : (
                      // Trạng thái không có chức năng
                      <button
                        // className="disabled-button"
                        // disabled
                        // style={{ backgroundColor: "gray", color: "white" }}
                        className="disabled-button icon-button"
                        disabled
                        aria-label="Chức năng không khả dụng"
                      >
                        {/* Không khả dụng */}
                        <FontAwesomeIcon icon={faBan} />
                      </button>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>Không có đặt lịch nào</p>
        )}
      </div>
      {/* Modal Hủy Lịch Hẹn */}
      {isModalOpen && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>Vui lòng nhập lý do hủy lịch hẹn #{bookingIdToCancel}</h3>
            <textarea
              value={cancelReason}
              onChange={(e) => setCancelReason(e.target.value)}
              placeholder="Ví dụ: Giờ này không thể thực hiện do trùng với lịch hẹn khác."
              rows="4"
              style={{ width: "100%", padding: "8px", boxSizing: "border-box" }}
            ></textarea>
            <div className="modal-actions">
              <button
                className="button-modal-actions"
                onClick={cancelBooking}
                disabled={!cancelReason.trim()}
              >
                Xác nhận hủy
              </button>
              <button
                className="cancel-close-button"
                onClick={closeCancelModal}
              >
                Đóng
              </button>
            </div>
          </div>
        </div>
      )}

      {/* trang chi tiết thanh toán */}
      <PaymentDetailModal
        isOpen={isPaymentModalOpen}
        onClose={() => {
          setIsPaymentModalOpen(false);
          setPaymentDetails(null); // Dọn dẹp state khi đóng
        }}
        paymentDetails={paymentDetails}
        isLoading={isLoadingPaymentDetails}
        onConfirm={(idlichhenToPay) => {
          payBooking(idlichhenToPay);
          setIsPaymentModalOpen(false);
          setPaymentDetails(null);
        }}
      />

      {/* Modal Xem Chi Tiết Đơn Thuốc */}
      {isPrescriptionDetailOpen && (
        <PrescriptionDetail
          bookingId={selectedBookingId}
          isEditable={isPrescriptionDetailEditable}
          // Nếu bạn cần truyền idonthuoc vào đây, bạn sẽ sửa hàm gọi setIsPrescriptionDetailOpen
          onClose={() => setIsPrescriptionDetailOpen(false)}
          onSaveSuccess={loadBookings}
        />
      )}
      {/* Modal Thêm Đơn Thuốc */}
      {isAddPrescriptionOpen && (
        <AddPrescription
          bookingId={selectedBookingId}
          onClose={() => setIsAddPrescriptionOpen(false)}
          onSuccess={() => {
            // Khi thêm đơn thành công
            toast.success("Thêm đơn thuốc thành công!");
            setIsAddPrescriptionOpen(false); // đóng modal thêm đơn
            loadBookings(); // GỌI LẠI API để fetch dữ liệu mới (có idonthuoc) và cập nhật UI
          }}
        />
      )}

      {/* Modal Xem Lý Do Hủy */}
      {isViewReasonModalOpen && (
        <div className="modal-overlay">
          <div className="modal-content">
            <h3>
              Lý do hủy lịch hẹn{" "}
              {selectedBookingForReason
                ? `#${selectedBookingForReason.idlichhen}`
                : ""}
            </h3>
            {selectedBookingForReason && (
              <>
                <p>
                  <strong>Người dùng:</strong>{" "}
                  {selectedBookingForReason.tennguoidung}
                </p>
                <p>
                  <strong>Số điện thoại:</strong>{" "}
                  {selectedBookingForReason.sodienthoai}
                </p>
                <p>
                  <strong>Thú cưng:</strong>{" "}
                  {selectedBookingForReason.tenthucung}
                </p>
                <p>
                  <strong>Ngày hẹn:</strong> {selectedBookingForReason.ngayhen}
                </p>
              </>
            )}
            <div
              style={{
                marginTop: "15px",
                padding: "10px",
                border: "1px solid #ddd",
                borderRadius: "4px",
                backgroundColor: "#f9f9f9",
                minHeight: "80px",
                whiteSpace: "pre-wrap",
              }}
            >
              {reasonToView || "Không có lý do được cung cấp."}
            </div>
            <div className="modal-actions" style={{ marginTop: "20px" }}>
              <button
                className="cancel-close-button"
                onClick={closeViewReasonModal}
              >
                Đóng
              </button>
            </div>
          </div>
        </div>
      )}

      {/* --- MỚI: Modal Xem Chi Tiết Lịch Hẹn --- */}
      {isViewDetailModalOpen && selectedBookingForDetail && (
        <div className="detailbooking-modal-overlay">
          {" "}
          <div
            className="detailbooking-modal-content"
            style={{ maxWidth: "700px" }}
          >
            {" "}
            <h3>Chi tiết Lịch hẹn #{selectedBookingForDetail.idlichhen}</h3>
            <div className="booking-detail-grid">
              {/* Phần Thông tin Khách hàng */}
              <h4 className="booking-detail-section-title">
                Thông tin Khách hàng
              </h4>
              <p>
                <strong>Người Đặt:</strong>
              </p>
              <p>{selectedBookingForDetail.tennguoidung || "N/A"}</p>

              <p>
                <strong>Số Điện Thoại:</strong>
              </p>
              <p>{selectedBookingForDetail.sodienthoai || "N/A"}</p>

              <p>
                <strong>Email:</strong>
              </p>
              <p>{selectedBookingForDetail.email || "N/A"}</p>

              {/* Phần Thông tin Thú cưng */}
              <h4 className="booking-detail-section-title">
                Thông tin Thú cưng
              </h4>
              <p>
                <strong>Tên Thú Cưng:</strong>
              </p>
              <p>{selectedBookingForDetail.tenthucung || "N/A"}</p>

              <p>
                <strong>Loài:</strong>
              </p>
              <p>{selectedBookingForDetail.loaithucung || "N/A"}</p>

              <p>
                <strong>Giống:</strong>
              </p>
              <p>{selectedBookingForDetail.giongloai || "N/A"}</p>

              <p>
                <strong>Tuổi:</strong>
              </p>
              <p>
                {selectedBookingForDetail.tuoi !== null &&
                selectedBookingForDetail.tuoi !== undefined
                  ? `${selectedBookingForDetail.tuoi} tuổi`
                  : "N/A"}
              </p>

              <p>
                <strong>Cân nặng:</strong>
              </p>
              <p>
                {selectedBookingForDetail.cannang !== null &&
                selectedBookingForDetail.cannang !== undefined
                  ? `${selectedBookingForDetail.cannang} kg`
                  : "N/A"}
              </p>

              <p>
                <strong>Tình trạng sức khỏe:</strong>
              </p>
              <p>{selectedBookingForDetail.suckhoe || "Không có ghi chú"}</p>

              {/* Phần Thông tin Lịch hẹn */}
              <h4 className="booking-detail-section-title">
                Thông tin Lịch hẹn
              </h4>
              <p>
                <strong>Mã Lịch Hẹn:</strong>
              </p>
              <p>{selectedBookingForDetail.idlichhen}</p>

              <p>
                <strong>Dịch Vụ:</strong>
              </p>
              {/* Giả sử API trả về tendichvu_lichhen như trong script PHP đã cập nhật */}
              <p>{selectedBookingForDetail.tendichvu || "N/A"}</p>

              <p>
                <strong>Ngày Hẹn:</strong>
              </p>
              <p>{selectedBookingForDetail.ngayhen || "N/A"}</p>

              <p>
                <strong>Giờ Hẹn:</strong>
              </p>
              <p>{selectedBookingForDetail.thoigianhen || "N/A"}</p>

              <p>
                <strong>Trạng Thái:</strong>
              </p>
              <p>{convertTrangThai(selectedBookingForDetail.trangthai)}</p>

              <p>
                <strong>Ngày Tạo Lịch:</strong>
              </p>
              <p>{selectedBookingForDetail.ngaytao || "N/A"}</p>

              {/*PHẦN THÔNG TIN ĐƠN THUỐC  */}
              {selectedBookingForDetail.iddonthuoc && (
                <>
                  <h4 className="booking-detail-section-title">
                    Thông tin Đơn thuốc
                  </h4>
                  <p>
                    <strong>Mã Đơn Thuốc:</strong>
                  </p>
                  <p>{selectedBookingForDetail.iddonthuoc}</p>

                  <p>
                    <strong>Ngày lập đơn:</strong>
                  </p>

                  <p>{selectedBookingForDetail.ngaylap_donthuoc || "N/A"}</p>

                  <p>
                    <strong>Ghi chú của bác sĩ (đơn thuốc):</strong>
                  </p>

                  <p>
                    {selectedBookingForDetail.ghichu_donthuoc ||
                      "Không có ghi chú"}
                  </p>

                  <p>
                    <strong>Danh sách thuốc:</strong>
                  </p>
                  {/* Giả sử API trả về danh_sach_thuoc là chuỗi các tên thuốc, phân cách bởi dấu phẩy */}
                  <p style={{ whiteSpace: "pre-line" }}>
                    {selectedBookingForDetail.danh_sach_thuoc
                      ? selectedBookingForDetail.danh_sach_thuoc.replace(
                          /,/g,
                          ",\n"
                        )
                      : "Chưa có thuốc"}
                  </p>
                </>
              )}
            </div>
            <div className="modal-actions" style={{ marginTop: "20px" }}>
              <button
                className="cancel-close-button"
                onClick={closeViewDetailModal}
              >
                Đóng
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Bookings;
