import React, { useState } from "react";
import "./AddServices.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

function AddService({ closeForm, onServiceAdded }) {
  const [service, setService] = useState({
    tendichvu: "",
    mota: "",
    gia: "",
    thoigianthuchien: "",
    hinhanh: "",
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setService({ ...service, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    console.log("Dữ liệu gửi đi:", service);

    try {
      const response = await fetch(`${url}/Dichvu/themdichvu.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(service),
      });

      const result = await response.json();
      console.log(result);

      if (response.ok) {
        toast.success(result.message);
        onServiceAdded();
        closeForm();
        setService({
          tendichvu: "",
          mota: "",
          gia: "",
          thoigianthuchien: "",
          hinhanh: "",
        });
      } else {
        alert("Có lỗi xảy ra: " + result.message);
      }
    } catch (error) {
      console.error("Lỗi khi thêm dịch vụ:", error);
      toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
    }
  };

  return (
    <div className="addservice-modal">
      <div className="addservice-modal-content">
        <span className="addservice-close-btn" onClick={closeForm}>
          &times;
        </span>
        <h3 className="addservice-title">Thêm Dịch Vụ</h3>
        <form className="addservice-form" onSubmit={handleSubmit}>
          <label className="addservice-label">Tên Dịch Vụ:</label>
          <input
            className="addservice-input"
            type="text"
            name="tendichvu"
            value={service.tendichvu}
            onChange={handleChange}
            required
          />

          <label className="addservice-label">Mô Tả:</label>
          <input
            className="addservice-input"
            type="text"
            name="mota"
            value={service.mota}
            onChange={handleChange}
            required
          />

          <label className="addservice-label">Giá:</label>
          <input
            className="addservice-input"
            type="text"
            name="gia"
            value={service.gia}
            onChange={handleChange}
            required
          />

          <label className="addservice-label">Thời Gian Thực Hiện:</label>
          <input
            className="addservice-input"
            type="text"
            name="thoigianthuchien"
            value={service.thoigianthuchien}
            onChange={handleChange}
            required
          />

          <label className="addservice-label">Hình Ảnh:</label>
          <div className="addservice-image-preview-container">
            <div className="addservice-image-input">
              <input
                className="addservice-input"
                type="text"
                name="hinhanh"
                value={service.hinhanh}
                onChange={handleChange}
                required
              />
            </div>
            {service.hinhanh && (
              <div className="addservice-image-preview">
                <img src={service.hinhanh} alt="Xem trước" />
              </div>
            )}
          </div>
          <button className="addservice-submit-btn" type="submit">
            Thêm Dịch Vụ
          </button>
        </form>
      </div>
    </div>
  );
}

export default AddService;
