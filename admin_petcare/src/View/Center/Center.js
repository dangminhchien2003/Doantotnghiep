import React, { useEffect, useState } from "react";
import "./Center.css";
import EditCenter from "./EditCenter";
import "@fortawesome/fontawesome-free/css/all.min.css";
import url from "../../ipconfig"; // Đảm bảo biến url này được định nghĩa đúng
import { ToastContainer, toast } from "react-toastify"; // Thêm toast để có thể sử dụng nếu cần
import "leaflet/dist/leaflet.css";
import MapView from "../../components/MapView/MapView"; // chỉnh lại đường dẫn nếu cần

// Placeholder image URL (bạn có thể đặt trong thư mục public)
const PLACEHOLDER_IMAGE_URL = "/placeholder-image.png"; // Ví dụ: public/placeholder-image.png

const Center = () => {
  const [center, setCenter] = useState(null);
  const [error, setError] = useState(null);
  const [showEditCenter, setShowEditCenter] = useState(false);
  const [loading, setLoading] = useState(true);

  const loadCenter = async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await fetch(`${url}/Trungtam/gettrungtam.php`);
      if (!response.ok) {
        const errorData = await response.json().catch(() => null); // Cố gắng parse lỗi JSON
        throw new Error(errorData?.message || `Lỗi HTTP: ${response.status}`);
      }
      const data = await response.json();
      if (data && Object.keys(data).length > 0 && data.tentrungtam) { // Kiểm tra kỹ hơn dữ liệu
        setCenter(data);
      } else {
        setCenter(null); // Đặt là null nếu dữ liệu không hợp lệ hoặc rỗng
      }
    } catch (err) {
      console.error("Lỗi khi tải thông tin trung tâm:", err);
      setError(err.message || "Không thể tải thông tin trung tâm. Vui lòng thử lại sau.");
      setCenter(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadCenter();
  }, []);

  const handleEditCenter = () => {
    setShowEditCenter(true);
  };

  const handleCenterUpdated = () => {
    setShowEditCenter(false);
    loadCenter(); // Tải lại dữ liệu sau khi cập nhật
    toast.success("Thông tin trung tâm đã được cập nhật!"); // Thông báo thành công
  };

  const handleImageError = (e) => {
    e.target.onerror = null; // Ngăn vòng lặp lỗi nếu placeholder cũng lỗi
    e.target.src = PLACEHOLDER_IMAGE_URL;
  };

  if (loading) {
    return <div className="loading-message">Đang tải thông tin trung tâm...</div>;
  }

  // Chỉ hiển thị lỗi nếu không có dữ liệu trung tâm nào (ngay cả khi có lỗi nhưng center vẫn còn dữ liệu cũ thì vẫn hiển thị)
  if (error && !center) {
    return <p className="error-message">Lỗi: {error}</p>;
  }

  if (!center) {
    return <p className="no-data">Không tìm thấy thông tin trung tâm.</p>;
  }

  return (
    <div className="center-detail-container">
      <ToastContainer position="top-right" autoClose={3000} style={{ top: 70, zIndex: 9999 }} />

      <div className="center-card">
        {/* Cột bên trái */}
        <div className="center-left">
          <div className="center-image-wrapper">
            <img
              src={center.hinhanh || PLACEHOLDER_IMAGE_URL}
              alt={center.tentrungtam || "Hình ảnh trung tâm"}
              className="center-image"
              onError={handleImageError}
            />
          </div>
          <div className="center-info">
            <h2>{center.tentrungtam || "Chưa có tên"}</h2>
            <p>
              <i className="fas fa-map-marker-alt"></i>
              <strong>Địa chỉ:</strong> {center.diachi || "Chưa cập nhật"}
            </p>
            <p>
              <i className="fas fa-phone"></i>
              <strong>SĐT:</strong> {center.sodienthoai || "Chưa cập nhật"}
            </p>
            <p>
              <i className="fas fa-envelope"></i>
              <strong>Email:</strong> {center.email || "Chưa cập nhật"}
            </p>
            <button onClick={handleEditCenter} className="edit-button">
              <i className="fas fa-edit"></i> Chỉnh sửa
            </button>
          </div>
        </div>

        {/* Cột bên phải */}
        <div className="center-right">
           <div className="map-view-wrapper"> {/* << DIV BAO BỌC BẢN ĐỒ */}
            {(center.X_location != null && center.Y_location != null) ? (
              <MapView
                x={center.X_location} // Truyền trực tiếp, parseFloat sẽ ở trong MapView
                y={center.Y_location}
                zoom={16} // Bạn có thể điều chỉnh mức zoom
                showZoomControl={false} // << TẮT ZOOM CONTROL
                tooltipText={center.tentrungtam || "Vị trí trung tâm"}
              />
            ) : (
              <div className="no-map-data"> {/* Đảm bảo class này được style nếu muốn */}
                <p>Chưa có thông tin vị trí bản đồ.</p>
              </div>
            )}
          </div>
          {center.mota && (
            <p className="center-description">
              <i className="fas fa-info-circle"></i>
              <strong>Mô tả:</strong> {center.mota}
            </p>
          )}
          <div className="center-actions">
            <button className="action-button" onClick={() => toast.info("Chức năng đang được phát triển!")}>
              <i className="fas fa-star"></i> Xem đánh giá
            </button>
            <button className="action-button" onClick={() => toast.info("Chức năng đang được phát triển!")}>
              <i className="fas fa-paw"></i> Xem dịch vụ
            </button>
          </div>
        </div>
      </div>

      {showEditCenter && (
        <EditCenter
          CenterToEdit={center}
          closeForm={() => setShowEditCenter(false)}
          onCenterUpdated={handleCenterUpdated}
        />
      )}
    </div>
  );
};

export default Center;