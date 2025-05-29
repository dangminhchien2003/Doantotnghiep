import React, { useState, useEffect } from "react";
import "./EditBlog.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

function EditBlog({ blogToEdit, closeForm, onBlogUpdated }) {
  const [blog, setBlog] = useState(blogToEdit);

  // Cập nhật blog khi BlogToEdit thay đổi
  useEffect(() => {
    setBlog(blogToEdit);
  }, [blogToEdit]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setBlog({
      ...blog,
      [name]: value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    // Dữ liệu blog cần gửi để cập nhật, không cần gửi updated_at
    const blogData = {
      id: blog.id, // Giả sử id là id của bài blog
      tieu_de: blog.tieu_de,
      noi_dung: blog.noi_dung,
      hinhanh: blog.hinhanh,
    };

    try {
      const response = await fetch(`${url}/Blog/suablog.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(blogData), // Truyền dữ liệu cần cập nhật
      });

      const result = await response.json();

      if (response.ok && result.status === "success") {
        toast.success(result.message || "Cập nhật blog thành công");
        onBlogUpdated(); // Cập nhật lại danh sách blog
        closeForm(); // Đóng form
      } else {
        toast.error("Lỗi: " + (result.message || "Không xác định"));
      }
    } catch (error) {
      console.error("Lỗi khi kết nối tới server:", error);
      toast.error("Đã xảy ra lỗi khi kết nối tới server.");
    }
  };

  return (
    <div className="editblog-modal">
      <div className="editblog-modal-content">
        <span className="editblog-close-btn" onClick={closeForm}>
          &times;
        </span>
        <h3 className="editblog-title">Sửa Blog</h3>
        <form onSubmit={handleSubmit} className="editblog-form-grid">
          <div className="editblog-blog-title">
            <label>Tiêu đề:</label>
            <input
              type="text"
              name="tieu_de"
              value={blog.tieu_de}
              onChange={handleChange}
              required
              className="editblog-input"
            />
          </div>

          <div className="editblog-blog-content">
            <label>Nội dung:</label>
            <textarea
              name="noi_dung"
              value={blog.noi_dung}
              onChange={handleChange}
              required
              className="editblog-textarea"
            />
          </div>

          <div className="editblog-blog-image">
            <label>Hình ảnh (URL):</label>
            <input
              type="text"
              name="hinhanh"
              value={blog.hinhanh}
              onChange={handleChange}
              className="editblog-input"
            />
          </div>
          {/* Thêm ô hiển thị hình ảnh */}
          {blog.hinhanh && (
            <div className="editblog-image-preview">
              <img
                src={blog.hinhanh}
                alt="blog"
                className="editblog-image-preview-img"
              />
            </div>
          )}
          <div className="editblog-form-button">
            <button type="submit" className="editblog-submit-btn">
              Cập Nhật Blog
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default EditBlog;
