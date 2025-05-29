import React, { useState } from "react";
import "./AddMedicine.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

function AddMedicine({ closeForm, onMedicineAdded }) {
  const [medicine, setMedicine] = useState({
    tenthuoc: "",
    mota: "",
    donvitinh: "",
    soluongton: 0,
    giaban: 0,
    hansudung: "",
    nhacungcap: "",
    loai: "",
    trangthai: 1,
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setMedicine({
      ...medicine,
      [name]: name === "trangthai" ? Number(value) : value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await fetch(`${url}/Thuoc/themthuoc.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(medicine),
      });

      const result = await response.json();

      if (response.ok) {
        toast.success(result.message || "Thêm thuốc thành công");
        onMedicineAdded();
        closeForm();
        setMedicine({
          tenthuoc: "",
          mota: "",
          donvitinh: "",
          soluongton: 0,
          giaban: 0,
          hansudung: "",
          nhacungcap: "",
          loai: "",
          trangthai: 1,
        });
      } else {
        toast.error("Lỗi: " + (result.error || "Không xác định"));
      }
    } catch (error) {
      console.error("Lỗi khi thêm thuốc:", error);
      toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
    }
  };

  return (
    <div className="addmedicine-modal">
      <div className="addmedicine-modal-content">
        <span className="addmedicine-close-btn" onClick={closeForm}>
          &times;
        </span>
        <h3 className="addmedicine-title">Thêm Thuốc</h3>
        <form onSubmit={handleSubmit} className="addmedicine-form-grid">
          <div>
            <label className="addmedicine-label">Tên thuốc:</label>
            <input
              className="addmedicine-input"
              type="text"
              name="tenthuoc"
              value={medicine.tenthuoc}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="addmedicine-label">Mô tả:</label>
            <input
              className="addmedicine-input"
              type="text"
              name="mota"
              value={medicine.mota}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="addmedicine-label">Đơn vị tính:</label>
            <input
              className="addmedicine-input"
              type="text"
              name="donvitinh"
              value={medicine.donvitinh}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="addmedicine-label">Số lượng tồn:</label>
            <input
              className="addmedicine-input"
              type="number"
              name="soluongton"
              value={medicine.soluongton}
              onChange={handleChange}
              min="0"
            />
          </div>

          <div>
            <label className="addmedicine-label">Giá bán (VNĐ):</label>
            <input
              className="addmedicine-input"
              type="number"
              name="giaban"
              value={medicine.giaban}
              onChange={handleChange}
              step="1000"
              min="0"
            />
          </div>

          <div>
            <label className="addmedicine-label">Hạn sử dụng:</label>
            <input
              className="addmedicine-input"
              type="date"
              name="hansudung"
              value={medicine.hansudung}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label className="addmedicine-label">Nhà cung cấp:</label>
            <input
              className="addmedicine-input"
              type="text"
              name="nhacungcap"
              value={medicine.nhacungcap}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="addmedicine-label">Loại thuốc:</label>
            <input
              className="addmedicine-input"
              type="text"
              name="loai"
              value={medicine.loai}
              onChange={handleChange}
            />
          </div>

          <div>
            <label className="addmedicine-label">Trạng thái:</label>
            <select
              className="addmedicine-input"
              name="trangthai"
              value={medicine.trangthai}
              onChange={handleChange}
            >
              <option value={"1"}>Còn bán</option>
              <option value={"0"}>Ngừng bán</option>
            </select>
          </div>

          <div className="addmedicine-form-button">
            <button type="submit">Thêm Thuốc</button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default AddMedicine;
