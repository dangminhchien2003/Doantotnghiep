import React, { useState, useEffect } from 'react';
import url from '../../ipconfig';
import { toast } from "react-toastify";
import  './EditUser.css';

function EditUser({ userToEdit, closeForm, onUserUpdated }) {
  const [user, setUser] = useState(userToEdit);

  useEffect(() => {
    setUser(userToEdit);
  }, [userToEdit]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUser({ ...user, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${url}/Nguoidung/suanguoidung.php`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
          idnguoidung: user.idnguoidung,
          tennguoidung: user.tennguoidung,
          email: user.email,
          matkhau: user.matkhau,
          sodienthoai: user.sodienthoai,
          diachi: user.diachi,
          vaitro: user.vaitro
        })
      });

      const result = await response.json();

      if (response.ok) {
        toast.success(result.message);
        onUserUpdated();
        closeForm();
      } else {
        toast.error(`Lỗi khi cập nhật: ${result.message}`);
      }
    } catch (error) {
      console.error('Lỗi khi kết nối tới server:', error);
      alert('Đã xảy ra lỗi khi kết nối tới server.');
    }
  };

  return (
    <div className="edituser-modal">
      <div className="edituser-modal-content">
        <span className="edituser-close-btn" onClick={closeForm}>&times;</span>
        <h3 className="edituser-title">Sửa Người Dùng</h3>
        <form onSubmit={handleSubmit} className="edituser-form">
          <label className="edituser-label">ID Người Dùng:</label>
          <input type="text" name="idnguoidung" value={user.idnguoidung} readOnly className="edituser-input" />

          <label className="edituser-label">Tên Người Dùng:</label>
          <input type="text" name="tennguoidung" value={user.tennguoidung} onChange={handleChange} required className="edituser-input" />

          <label className="edituser-label">Email:</label>
          <input type="text" name="email" value={user.email} onChange={handleChange} required className="edituser-input" />

          {/* <label className="edituser-label">Mật Khẩu:</label>
          <input type="text" name="matkhau" value={user.matkhau} onChange={handleChange} required className="edituser-input" /> */}

          <label className="edituser-label">Số Điện Thoại:</label>
          <input type="text" name="sodienthoai" value={user.sodienthoai} onChange={handleChange} required className="edituser-input" />

          <label className="edituser-label">Địa Chỉ:</label>
          <input type="text" name="diachi" value={user.diachi} onChange={handleChange} required className="edituser-input" />

          <label className="edituser-label">Vai trò:</label>
          <select name="vaitro" value={user.vaitro} onChange={handleChange} required className="edituser-select">
            <option value="0">Người dùng</option>
            <option value="1">Admin</option>
          </select>

          <button type="submit" className="edituser-submit-btn">Cập Nhật Người Dùng</button>
        </form>
      </div>
    </div>
  );
}

export default EditUser;
