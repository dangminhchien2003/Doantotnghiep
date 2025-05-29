import React, { useState } from 'react';
import './AddUser.css';
import url from '../../ipconfig';
import { toast } from "react-toastify";

function AddUser({ closeForm, onUserAdded }) {
  const [user, setUser] = useState({
    tennguoidung: '',
    email: '',
    matkhau: '',
    sodienthoai: '',
    diachi: '',
    vaitro: '0' // Đặt giá trị mặc định cho vai trò là 0
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setUser({ ...user, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    console.log("Dữ liệu gửi đi:", user);

    try {
      const response = await fetch(`${url}/Nguoidung/themnguoidung.php`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(user),
      });

      const result = await response.json();
      console.log(result);

      if (response.ok) {
        toast.success(result.message);
        onUserAdded();
        closeForm();
        setUser({
          tennguoidung: '',
          email: '',
          matkhau: '',
          sodienthoai: '',
          diachi: '',
          vaitro: '0'
        });
      } else {
        toast.error("Có lỗi xảy ra: " + result.message);
      }
    } catch (error) {
      console.error('Lỗi khi thêm người dùng:', error);
      toast.error('Đã xảy ra lỗi. Vui lòng thử lại.');
    }
  };

  return (
    <div className="adduser-modal">
      <div className="adduser-modal-content">
        <span className="adduser-close-btn" onClick={closeForm}>&times;</span>
        <h3 className="adduser-title">Thêm Người Dùng</h3>
        <form onSubmit={handleSubmit} className="adduser-form">
          <label className="adduser-label">Tên Người Dùng:</label>
          <input type="text" name="tennguoidung" value={user.tennguoidung} onChange={handleChange} required className="adduser-input" />

          <label className="adduser-label">Email:</label>
          <input type="text" name="email" value={user.email} onChange={handleChange} required className="adduser-input" />

          <label className="adduser-label">Mật Khẩu:</label>
          <input type="text" name="matkhau" value={user.matkhau} onChange={handleChange} required className="adduser-input" />

          <label className="adduser-label">Số Điện Thoại:</label>
          <input type="text" name="sodienthoai" value={user.sodienthoai} onChange={handleChange} required className="adduser-input" />

          <label className="adduser-label">Địa Chỉ:</label>
          <input type="text" name="diachi" value={user.diachi} onChange={handleChange} required className="adduser-input" />

          <label className="adduser-label">Vai trò:</label>
          <select name="vaitro" value={user.vaitro} onChange={handleChange} required className="adduser-select">
            <option value="0">Người dùng</option>
            <option value="1">Admin</option>
          </select>

          <button type="submit" className="adduser-submit-btn">Thêm Người Dùng</button>
        </form>
      </div>
    </div>
  );
}

export default AddUser;
