import React, { useEffect, useState, useCallback } from "react"; // Thêm useCallback nếu chưa có
import {
  FaUser,
  FaDollarSign,
  FaServicestack,
  FaCalendarAlt,
} from "react-icons/fa";
import "./Dashboard.css";
import { toast, ToastContainer } from "react-toastify";
import { useLocation } from "react-router-dom";
import {
  BarChart,
  CartesianGrid,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
  Bar,
  LineChart,
  Line,
  ResponsiveContainer,
} from "recharts";
import url from "../../ipconfig";
import { RiLoader2Fill } from "react-icons/ri";
import { messaging, getToken, onMessage } from "../../firebaseConfig";

const Dashboard = () => {
  const [userCount, setUserCount] = useState(0);
  const [bookingCount, setBookingCount] = useState(0);
  const [serviceCount, setServiceCount] = useState(0);
  const [RevenueCount, setRevenueCount] = useState(0);
  const location = useLocation();
  const [loading, setLoading] = useState(true);

  const [month, setMonth] = useState(new Date().getMonth() + 1); // Tháng hiện tại
  const [year, setYear] = useState(new Date().getFullYear()); // Năm hiện tại
  const [data, setData] = useState([]); // Dữ liệu biểu đồ BarChart
  const [monthlyRevenueData, setMonthlyRevenueData] = useState([]); // Dữ liệu doanh thu

  const [notifications, setNotifications] = useState([]);
  const [adminId, setAdminId] = useState(null);

  // Hàm fetch dữ liệu doanh thu theo tháng cho LineChart (đã có sẵn trong code của bạn)
  // THÊM useCallback nếu chưa có, và đảm bảo mảng phụ thuộc của nó là đúng (ở đây là [])
  const fetchMonthlyRevenueChartData = useCallback((selectedYear) => {
    setLoading(true);
    fetch(`${url}/TongQuan/getDoanhThuTheoThang.php?year=${selectedYear}`)
      .then((response) => response.json())
      .then((apiData) => {
        if (apiData.success) {
          setMonthlyRevenueData(apiData.monthly_revenue_stats || []);
        } else {
          toast.error(apiData.message || "Lỗi tải dữ liệu biểu đồ doanh thu");
          setMonthlyRevenueData([]);
        }
      })
      .catch(() => toast.error("Không thể kết nối API biểu đồ doanh thu"))
      .finally(() => setLoading(false));
  }, []); // Mảng phụ thuộc rỗng vì hàm này không dùng state/props nào từ Dashboard

  const fetchData = (selectedMonth, selectedYear) => {
    setLoading(true);
    fetch(
      `${url}/TongQuan/thongkeTheoThang.php?month=${selectedMonth}&year=${selectedYear}`
    )
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          const formattedData = data.daily_stats.map((item) => ({
            name: item.date,
            users: item.users,
            bookings: item.bookings,
          }));
          setData(formattedData);
        } else {
          toast.error(data.message || "Error fetching data");
        }
      })
      .catch(() => toast.error("Unable to connect to API"))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    fetchData(month, year);
  }, [month, year]); // Giữ nguyên useEffect này

  // **** THAY ĐỔI useEffect CHO BIỂU ĐỒ DOANH THU ****
  useEffect(() => {
    fetchMonthlyRevenueChartData(year); // Chỉ truyền `year`
  }, [year, fetchMonthlyRevenueChartData]); // Phụ thuộc vào `year` và hàm fetch đã được memoize

  const handleMonthChange = (e) => {
    setMonth(parseInt(e.target.value, 10));
  };

  const handleYearChange = (e) => {
    setYear(parseInt(e.target.value, 10));
  };

  useEffect(() => {
    if (location.state?.toastMessage) {
      toast.success(location.state.toastMessage);
    }
    // Các fetch API cho card thống kê và notification setup giữ nguyên
    setLoading(true);
    fetch(`${url}/TongQuan/demnguoidung.php`)
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          setUserCount(data.total_users);
        } else {
          toast.error(data.message || "Lỗi khi lấy số người dùng");
        }
      })
      .catch(() => toast.error("Không thể kết nối tới API"));

    fetch(`${url}/TongQuan/demlichhen.php`)
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          setBookingCount(data.total_booking);
        } else {
          toast.error(data.message || "Lỗi khi lấy số lịch hẹn");
        }
      })
      .catch(() => toast.error("Không thể kết nối tới API"));

    fetch(`${url}/TongQuan/demdichvu.php`)
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          setServiceCount(data.total_service);
        } else {
          toast.error(data.message || "Lỗi khi lấy số dịch vụ");
        }
      })
      .catch(() => toast.error("Không thể kết nối tới API"))

       fetch(`${url}/TongQuan/getTongDoanhThu.php`)
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          setRevenueCount(data.total_revenue);
        } else {
          toast.error(data.message || "Lỗi khi lấy tổng doanh thu");
        }
      })
      .catch(() => toast.error("Không thể kết nối tới API"))
      .finally(() => setLoading(false)); // setLoading này có thể bị gọi sớm nếu các chart vẫn đang load

    // Phần notification setup giữ nguyên
    const storedUser = localStorage.getItem('user');
    if (storedUser) {
      try {
        const userObject = JSON.parse(storedUser);
        setAdminId(userObject.idnguoidung);
      } catch (error) {
        console.error('Error parsing user data from localStorage:', error);
      }
    } else {
      console.log('User data not found in localStorage.');
    }
    const requestNotificationPermission = async () => {
      const permission = await Notification.requestPermission();
      if (permission === 'granted') {
        console.log('Đã cấp quyền thông báo.');
        await getAdminFCMToken();
      } else {
        console.log('Quyền thông báo bị từ chối.');
      }
    };
    const getAdminFCMToken = async () => {
      try {
        const token = await getToken(messaging);
        if (token) {
          console.log('Admin FCM Token:', token);
          sendTokenToServer(token);
          subscribeToAdminTopic();
        } else {
          console.log('Can not get FCM token...');
        }
      } catch (error) {
        console.error('An error occurred while retrieving token: ', error);
      }
    };
    const sendTokenToServer = async (token) => {
      const localStoredUser = localStorage.getItem('user');
      let currentAdminId = null;
      if (localStoredUser) {
        try {
          const userObject = JSON.parse(localStoredUser);
          currentAdminId = userObject.idnguoidung;
        } catch (error) {
          console.error('Error parsing user data from localStorage:', error);
        }
      }
      if (!currentAdminId) {
        console.error('Admin ID not found in localStorage. Cannot save FCM token.');
        return;
      }
      try {
        const response = await fetch(`${url}/Dangnhap/save-admin-fcm-token.php`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', },
          body: JSON.stringify({ token: token, idnguoidung: currentAdminId }),
        });
        const responseData = await response.json(); // Đổi tên biến data để tránh trùng
        console.log('Admin FCM token saved:', responseData);
      } catch (error) {
        console.error('Error saving admin FCM token:', error);
      }
    };
    const subscribeToAdminTopic = async () => {
      try {
        const token = await getToken(messaging);
        if (token) {
          await fetch(`${url}/Thongbao/subscribe-to-topic.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', },
            body: JSON.stringify({ token: token, topic: 'admin-notifications' }),
          });
          console.log('Subscribed to admin-notifications topic.');
        }
      } catch (error) {
        console.error('Error subscribing to topic:', error);
      }
    };
    requestNotificationPermission();
    const unsubscribe = onMessage(messaging, (payload) => {
      console.log('Message received:', payload);
      setNotifications((prevNotifications) => [
        {
          title: payload.notification.title,
          body: payload.notification.body,
          data: payload.data,
          timestamp: new Date().toLocaleTimeString(),
        },
        ...prevNotifications,
      ]);
      showBrowserNotification(payload.notification.title, payload.notification.body, payload.data);
    });
    return () => {
      unsubscribe();
    };
  }, [location]); // Giữ nguyên

  const showBrowserNotification = (title, body, data) => {
    if (Notification.permission === 'granted') {
      new Notification(title, {
        body: body,
        icon: '/admin_petcare/src/assets/images/logopet.jpg',
        data: data,
      });
    }
  };

  const stats = { revenue: 50000 }; // Phần này giữ nguyên theo yêu cầu

  return (
    <div id="dashboard" className="content-section">
      <ToastContainer style={{ top: 70 }} />
      <div className="card-container">
        {/* Các Card giữ nguyên, card Doanh thu vẫn hiển thị static data */}
        <div className="card">
          <FaUser size={30} style={{ marginBottom: "5px" }} />
          <h3>Người dùng</h3>
          {loading && userCount === 0 ? (
            <RiLoader2Fill className="spinner" />
          ) : (
            <p>{userCount}</p>
          )}
        </div>
        <div className="card">
          <FaDollarSign size={30} style={{ marginBottom: "5px" }} />
          <h3>Doanh thu</h3>
           {loading && RevenueCount === 0 ? (
            <RiLoader2Fill className="spinner" />
          ) : (
           <p>{parseFloat(RevenueCount).toLocaleString('vi-VN')} VNĐ</p>
          )}
        </div>
        <div className="card">
          <FaServicestack size={30} style={{ marginBottom: "5px" }} />
          <h3>Dịch vụ</h3>
          {loading && serviceCount === 0 ? (
            <RiLoader2Fill className="spinner" />
          ) : (
            <p>{serviceCount}</p>
          )}
        </div>
        <div className="card">
          <FaCalendarAlt size={30} style={{ marginBottom: "5px" }} />
          <h3>Tổng lịch hẹn</h3>
          {loading && bookingCount === 0 ? (
            <RiLoader2Fill className="spinner" />
          ) : (
            <p>{bookingCount}</p>
          )}
        </div>
      </div>
      
      <div style={{ marginBottom: "20px", textAlign: "center" }}>
        <label className="label-container">
          Chọn tháng:{" "}
          <select className="select" value={month} onChange={handleMonthChange}>
            {Array.from({ length: 12 }, (_, i) => (
              <option key={i + 1} value={i + 1}>
                Tháng {i + 1}
              </option>
            ))}
          </select>
        </label>
        <label style={{ marginLeft: "10px" }}>
          Chọn năm:{" "}
          <select className="select" value={year} onChange={handleYearChange}>
            {Array.from({ length: 5 }, (_, i) => (
              <option key={i} value={new Date().getFullYear() - i}> {/* Sửa lại cách tạo năm */}
                {new Date().getFullYear() - i}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div style={{ display: "flex", justifyContent: "center", gap: "20px", flexWrap: "wrap" }}>
        <div style={{ flex: 1, minWidth: "400px" }}>
          <h4 style={{ textAlign: "center" }}>
            Biểu đồ Thống kê Người Dùng và Lịch Hẹn (Tháng {month}/{year})
          </h4>
          {loading && data.length === 0 ? ( // Kiểm tra data rỗng
            <div style={{ textAlign: "center", height: '380px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <RiLoader2Fill className="spinner" />
              <p>Đang tải dữ liệu...</p>
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={380}>
              <BarChart data={data} style={{ margin: "0 auto" }}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="users" fill="#8884d8" name="Số người dùng" />
                <Bar dataKey="bookings" fill="#82ca9d" name="Số lịch hẹn" />
              </BarChart>
            </ResponsiveContainer>
          )}
        </div>

        <div style={{ flex: 1, minWidth: "400px" }}>
          <h4 style={{ textAlign: "center" }}>Biểu đồ Doanh thu theo tháng (Năm {year})</h4>
          {/* **** SỬ DỤNG monthlyRevenueData CHO BIỂU ĐỒ DOANH THU **** */}
          {loading && monthlyRevenueData.length === 0 ? ( // Kiểm tra monthlyRevenueData rỗng
            <div style={{ textAlign: "center", height: '380px', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              <RiLoader2Fill className="spinner" />
              <p>Đang tải dữ liệu...</p>
            </div>
          ) : (
            <ResponsiveContainer width="100%" height={380}>
              <LineChart
                data={monthlyRevenueData} 
                margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
              >
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="month" /> 
                <YAxis />
                {/* **** THÊM TOOLTIP FORMATTER VÀ NAME CHO LINE **** */}
                <Tooltip formatter={(value) => `${parseFloat(value).toLocaleString('vi-VN')} VNĐ`} />
                <Legend />
                <Line
                  type="monotone"
                  dataKey="revenue" 
                  stroke="#8884d8"
                  activeDot={{ r: 8 }}
                  name="Doanh thu (VNĐ)" 
                />
              </LineChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>
    </div>
  );
};

export default Dashboard;