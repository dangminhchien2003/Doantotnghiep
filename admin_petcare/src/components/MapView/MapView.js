// src/components/MapView/MapView.js
import React from "react";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css"; // Đảm bảo đã import CSS của Leaflet

// Tùy chỉnh icon marker cho đúng (fix lỗi icon không hiện)
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require("leaflet/dist/images/marker-icon-2x.png"),
  iconUrl: require("leaflet/dist/images/marker-icon.png"),
  shadowUrl: require("leaflet/dist/images/marker-shadow.png"),
});

const MapView = ({
  x,
  y,
  zoom = 16, // Mức zoom mặc định
  showZoomControl = false, // Mặc định là ẩn zoom control theo yêu cầu
  tooltipText = "Vị trí trung tâm", // Tooltip mặc định
}) => {
  // Kiểm tra nếu không có tọa độ x, y
  if (x == null || y == null) {
    return (
      <div
        style={{
          height: "100%", // Chiếm toàn bộ chiều cao của wrapper
          width: "100%",  // Chiếm toàn bộ chiều rộng của wrapper
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          backgroundColor: "#e9ecef", // Màu nền nhẹ
          color: "#6c757d",
        }}
      >
        Không có dữ liệu vị trí bản đồ.
      </div>
    );
  }

  const center = [parseFloat(y), parseFloat(x)]; // Đảm bảo là số: lat = y, lng = x

  return (
    <MapContainer
      center={center}
      zoom={zoom}
      style={{ height: "100%", width: "100%" }} // Để MapContainer lấp đầy div cha
      zoomControl={showZoomControl} // Prop để ẩn/hiện zoom control
    >
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <Marker position={center}>
        <Popup>{tooltipText}</Popup>
      </Marker>
    </MapContainer>
  );
};

export default MapView;