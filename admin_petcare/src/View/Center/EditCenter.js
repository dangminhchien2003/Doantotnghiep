import React, { useState, useEffect } from 'react';
import './EditCenter.css';
import url from '../../ipconfig';
import { toast } from "react-toastify";

function EditCenter({ CenterToEdit, closeForm, onCenterUpdated }) {
  const [center, setCenter] = useState(CenterToEdit);

  useEffect(() => {
    setCenter(CenterToEdit);
  }, [CenterToEdit]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setCenter({ ...center, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${url}/Trungtam/suatrungtam.php`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
          idtrungtam: center.idtrungtam,
          tentrungtam: center.tentrungtam,
          mota: center.mota,
          diachi: center.diachi,
          sodienthoai: center.sodienthoai,
          email: center.email,
          X_location: center.X_location,
          Y_location: center.Y_location,
          hinhanh: center.hinhanh
        })
      });

      const result = await response.json();

      if (response.ok) {
        toast.success(result.message);
        onCenterUpdated();
        closeForm();
      } else {
        alert(`Lỗi khi cập nhật trung tâm: ${result.message}`);
      }
    } catch (error) {
      console.error('Lỗi khi kết nối tới server:', error);
      toast.error('Đã xảy ra lỗi khi kết nối tới server.');
    }
  };

  return (
    <div className="editcenter-modal">
      <div className="editcenter-modal-content">
        <span className="editcenter-close-btn" onClick={closeForm}>&times;</span>
        <h3 className="editcenter-title">Sửa Trung Tâm</h3>
        <form className="editcenter-form" onSubmit={handleSubmit}>
          <label className="editcenter-label">ID Trung Tâm:</label>
          <input className="editcenter-input" type="text" name="idtrungtam" value={center.idtrungtam} readOnly />

          <label className="editcenter-label">Tên Trung Tâm:</label>
          <input className="editcenter-input" type="text" name="tentrungtam" value={center.tentrungtam} onChange={handleChange} required />

          <label className="editcenter-label">Địa Chỉ:</label>
          <input className="editcenter-input" type="text" name="diachi" value={center.diachi} onChange={handleChange} required />

          <label className="editcenter-label">Số Điện Thoại:</label>
          <input className="editcenter-input" type="text" name="sodienthoai" value={center.sodienthoai} onChange={handleChange} required />

          <label className="editcenter-label">Email:</label>
          <input className="editcenter-input" type="text" name="email" value={center.email} onChange={handleChange} required />

          <label className="editcenter-label">X-location:</label>
          <input className="editcenter-input" type="text" name="X_location" value={center.X_location} onChange={handleChange} required />

          <label className="editcenter-label">Y-location:</label>
          <input className="editcenter-input" type="text" name="Y_location" value={center.Y_location} onChange={handleChange} required />

          <label className="editcenter-label">Mô Tả:</label>
          <input className="editcenter-input" type="text" name="mota" value={center.mota} onChange={handleChange} required />

          <label className="editcenter-label">Hình Ảnh (URL):</label>
          <input className="editcenter-input" type="text" name="hinhanh" value={center.hinhanh} onChange={handleChange} required />

          {center.hinhanh && (
            <div className="editcenter-image-preview">
              <img src={center.hinhanh} alt="Xem trước hình ảnh" />
            </div>
          )}

          <button className="editcenter-submit-btn" type="submit">Cập Nhật Trung Tâm</button>
        </form>
      </div>
    </div>
  );
}

export default EditCenter;
