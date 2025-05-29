import React, { useState, useEffect } from "react";
import "./EditMedicine.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

function EditMedicine({ medicineToEdit, closeForm, onMedicineUpdated }) {
  const [medicine, setMedicine] = useState(medicineToEdit);

  useEffect(() => {
    setMedicine(medicineToEdit);
  }, [medicineToEdit]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setMedicine({
      ...medicine,
      [name]:
        name === "soluongton" || name === "giaban" || name === "trangthai"
          ? Number(value)
          : value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${url}/Thuoc/suathuoc.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(medicine),
      });

      const result = await response.json();

      if (response.ok && result.status === "success") {
        toast.success(result.message || "Cập nhật thuốc thành công");
        onMedicineUpdated();
        closeForm();
      } else {
        toast.error("Lỗi: " + (result.message || "Không xác định"));
      }
    } catch (error) {
      console.error("Lỗi khi kết nối tới server:", error);
      toast.error("Đã xảy ra lỗi khi kết nối tới server.");
    }
  };

  return (
    <div className="editmedicine-modal">
      <div className="editmedicine-modal-content">
        <span className="editmedicine-close-btn" onClick={closeForm}>
          &times;
        </span>
        <h3 className="editmedicine-title">Sửa Thuốc</h3>
        <form onSubmit={handleSubmit} className="editmedicine-form-grid">
          <div>
            <label className="editmedicine-label">ID Thuốc:</label>
            <input
              className="editmedicine-input"
              type="text"
              name="id"
              value={medicine.id}
              readOnly
            />
          </div>

          <div>
            <label className="editmedicine-label">Tên thuốc:</label>
            <input
              className="editmedicine-input"
              type="text"
              name="tenthuoc"
              value={medicine.tenthuoc}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="editmedicine-label">Mô tả:</label>
            <textarea
              className="editmedicine-input"
              name="mota"
              value={medicine.mota}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="editmedicine-label">Đơn vị tính:</label>
            <input
              className="editmedicine-input"
              type="text"
              name="donvitinh"
              value={medicine.donvitinh}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="editmedicine-label">Số lượng tồn:</label>
            <input
              className="editmedicine-input"
              type="number"
              name="soluongton"
              value={medicine.soluongton}
              onChange={handleChange}
              min="0"
            />
          </div>

          <div>
            <label className="editmedicine-label">Giá bán (VNĐ):</label>
            <input
              className="editmedicine-input"
              type="number"
              name="giaban"
              value={medicine.giaban}
              onChange={handleChange}
              min="0"
              step="1000"
              required
            />
          </div>

          <div>
            <label className="editmedicine-label">Hạn sử dụng:</label>
            <input
              className="editmedicine-input"
              type="date"
              name="hansudung"
              value={medicine.hansudung}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="editmedicine-label">Nhà cung cấp:</label>
            <input
              className="editmedicine-input"
              type="text"
              name="nhacungcap"
              value={medicine.nhacungcap}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="editmedicine-label">Loại:</label>
            <input
              className="editmedicine-input"
              type="text"
              name="loai"
              value={medicine.loai}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="editmedicine-label">Trạng thái:</label>
            <select
              className="editmedicine-input"
              name="trangthai"
              value={String(medicine.trangthai)}
              onChange={handleChange}
            >
              <option value="1">Còn bán</option>
              <option value="0">Ngừng bán</option>
            </select>
          </div>

          <div className="editmedicine-form-button">
            <button type="submit">Cập Nhật Thuốc</button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default EditMedicine;
