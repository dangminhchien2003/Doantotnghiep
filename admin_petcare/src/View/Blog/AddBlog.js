import React, { useState, useEffect } from "react";
import "./AddBlog.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

function AddBlog({ closeForm, onBlogAdded }) {
  const [blog, setBlog] = useState({
    tieu_de: "",
    noi_dung: "",
    hinhanh: "",
  });

  const [idNguoiDung, setIdNguoiDung] = useState(null);

  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem("user"));
    if (userData && userData.idnguoidung) {
      setIdNguoiDung(userData.idnguoidung);
    } else {
      toast.error(
        "Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại."
      );
      closeForm();
    }
  }, [closeForm]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setBlog({ ...blog, [name]: value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    if (!idNguoiDung) {
      toast.error("Không thể thêm blog vì thiếu ID người dùng.");
      return;
    }

    const blogData = { ...blog, idnguoidung: idNguoiDung };

    try {
      const response = await fetch(`${url}/Blog/themblog.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(blogData),
      });

      const result = await response.json();

      if (result.status === "success") {
        toast.success(result.message || "Thêm blog thành công");
        onBlogAdded();
        closeForm();
        setBlog({
          tieu_de: "",
          noi_dung: "",
          hinhanh: "",
        });
      } else {
        toast.error("Lỗi: " + (result.message || "Không xác định"));
      }
    } catch (error) {
      console.error("Lỗi khi thêm blog:", error);
      toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
    }
  };

  return (
    <div className="blog-modal">
      <div className="blog-modal-content">
        <span className="blog-close-btn" onClick={closeForm}>
          &times;
        </span>
        <h3>Thêm Blog</h3>
        <form onSubmit={handleSubmit} className="blog-form-grid">
          <div>
            <label>Tiêu đề:</label>
            <input
              type="text"
              name="tieu_de"
              value={blog.tieu_de}
              onChange={handleChange}
              required
            />
          </div>

          <div>
            <label>Nội dung:</label>
            <textarea
              name="noi_dung"
              value={blog.noi_dung}
              onChange={handleChange}
              required
            />
          </div>

          <div className="blog-image-preview-container">
            <div className="blog-image-input">
              <label>Hình ảnh (URL):</label>
              <input
                type="text"
                name="hinhanh"
                value={blog.hinhanh}
                onChange={handleChange}
              />
            </div>
            {blog.hinhanh && (
              <div className="blog-image-preview">
                <img src={blog.hinhanh} alt="Xem trước" />
              </div>
            )}
          </div>

          <div className="blog-form-button">
            <button type="submit">Thêm Blog</button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default AddBlog;
