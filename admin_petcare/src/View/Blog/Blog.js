import React, { useEffect, useState } from "react";
import AddBlog from "./AddBlog";
import EditBlog from "./EditBlog";
import "./Blog.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import url from "../../ipconfig";
import { toast, ToastContainer } from "react-toastify";
import useDebounce from "../../common/useDebounce";

function Blog() {
  const [blogs, setBlogs] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [filteredBlogs, setFilteredBlogs] = useState([]);
  const [showAddBlog, setShowAddBlog] = useState(false);
  const [showEditBlog, setShowEditBlog] = useState(false);
  const [blogToEdit, setBlogToEdit] = useState(null);

  const debounceKeyword = useDebounce(searchTerm, 500);

  // thu gọn mô tả
    const [expandedDescriptions, setExpandedDescriptions] = useState({});
    const toggleDescription = (id) => {
      setExpandedDescriptions((prev) => ({
        ...prev,
        [id]: !prev[id],
      }));
    };

  // phân trang
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 4; // số blog mỗi trang

  // Tính toán các phần tử cho trang hiện tại
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentBlog = filteredBlogs.slice(indexOfFirstItem, indexOfLastItem);

  const totalPages = Math.ceil(filteredBlogs.length / itemsPerPage);

  // Hàm chuyển trang
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const loadBlogs = async () => {
    try {
      const response = await fetch(`${url}/Blog/getblog.php`);
      if (!response.ok) throw new Error("Lỗi khi tải dữ liệu");
      const data = await response.json();
      console.log("Dữ liệu Blog nhận được từ API:", data);
      setBlogs(data.data);
      setFilteredBlogs(data.data);
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      alert(
        "Không thể tải danh sách Blog. Vui lòng kiểm tra kết nối hoặc dữ liệu."
      );
    }
  };

  const searchBlogs = async (term) => {
    try {
      const response = await fetch(
        `${url}/Blog/timkiemblog.php?searchTerm=${term}`
      );
      if (!response.ok) throw new Error("Lỗi khi tìm kiếm Blog");
      const data = await response.json();
      if (data.blogs) {
        setFilteredBlogs(data.blogs);
      } else {
        setFilteredBlogs([]);
      }
    } catch (error) {
      console.error("Lỗi khi tìm kiếm:", error);
      alert("Không thể tìm kiếm Blog. Vui lòng thử lại.");
    }
  };

  useEffect(() => {
    loadBlogs();
  }, []);

  useEffect(() => {
    if (debounceKeyword.trim() === "") {
      setFilteredBlogs(blogs);
    } else {
      searchBlogs(debounceKeyword);
    }
  }, [debounceKeyword, blogs]);

  const editBlog = (blog) => {
    setBlogToEdit(blog);
    setShowEditBlog(true);
  };

  const deleteBlog = async (id) => {
    const confirmDelete = window.confirm("Bạn có muốn xóa Blog này không?");
    if (confirmDelete) {
      try {
        const response = await fetch(`${url}/Blog/xoablog.php?id=${id}`, {
          method: "DELETE",
        });

        if (response.ok) {
          const result = await response.json();
          toast.success(result.message);
          loadBlogs();
        } else {
          const errorResult = await response.json();
          alert("Có lỗi xảy ra khi xóa Blog: " + errorResult.message);
        }
      } catch (error) {
        console.error("Lỗi khi xóa Blog:", error);
        toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
      }
    }
  };

  return (
    <div id="Blog" className="Blog-content-section">
      <ToastContainer style={{ top: 70 }} />
      <div className="Blog-search-container">
        <i className="fas fa-search Blog-search-icon"></i>
        <input
          type="text"
          placeholder="Tìm kiếm Blog..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="Blog-search-input"
        />
      </div>

      <div id="BlogTable">
        {filteredBlogs.length > 0 ? (
          <table className="Blog-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Tiêu đề</th>
                <th>Nội dung</th>
                <th>Hình ảnh</th>
                <th>Người đăng</th>
                <th>Ngày tạo</th>
                <th>Ngày cập nhật</th>
                <th>Chức năng</th>
              </tr>
            </thead>
            <tbody>
              {/* {filteredBlogs.map((blog) => ( */}
              {currentBlog.map((blog) => (
                <tr key={blog.id}>
                  <td>{blog.id}</td>
                  <td>{blog.tieu_de}</td>
                  {/* <td>{blog.noi_dung}</td> */}
                  <td>
                    {expandedDescriptions[blog.id]
                      ? blog.noi_dung
                      :  blog.noi_dung.length > 50
                      ?  blog.noi_dung.slice(0, 50) + "..."
                      :  blog.noi_dung}
                    { blog.noi_dung.length > 50 && (
                      <button
                        onClick={() => toggleDescription(blog.id)}
                        className="blog-toggle-description-btn"
                      >
                        {expandedDescriptions[blog.id]
                          ? "Thu gọn"
                          : "Xem thêm"}
                      </button>
                    )}
                  </td>
                  <td>
                    <img
                      src={blog.hinhanh}
                      alt="Hình ảnh"
                      style={{
                        width: "100px",
                        height: "100px",
                        objectFit: "cover",
                      }}
                    />
                  </td>
                  <td>{blog.tennguoidung}</td>
                  <td>{blog.created_at}</td>
                  <td>{blog.updated_at}</td>
                  <td>
                    <button
                      className="Blog-edit"
                      onClick={() => editBlog(blog)}
                    >
                      Sửa
                    </button>
                    <button
                      className="Blog-delete"
                      onClick={() => deleteBlog(blog.id)}
                    >
                      Xóa
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>Không có Blog nào</p>
        )}
      </div>
     {filteredBlogs.length > 0 && totalPages > 0 && (
        <div className="blog-pagination">
          <button
            className="blog-page-nav blog-page-prev"
            onClick={() => paginate(currentPage - 1)}
            disabled={currentPage === 1}
            aria-label="Trang trước"
          >
            <i className="fas fa-chevron-left"></i>
          </button>
          <span className="blog-page-current">{currentPage}</span>
          <button
            className="blog-page-nav blog-page-next"
            onClick={() => paginate(currentPage + 1)}
            disabled={currentPage === totalPages}
            aria-label="Trang sau"
          >
            <i className="fas fa-chevron-right"></i>
          </button>
        </div>
      )}
      <button
        className="Blog-floating-btn"
        onClick={() => setShowAddBlog(true)}
      >
        +
      </button>

      {showAddBlog && (
        <AddBlog
          closeForm={() => setShowAddBlog(false)}
          onBlogAdded={loadBlogs}
        />
      )}

      {showEditBlog && (
        <EditBlog
          blogToEdit={blogToEdit}
          closeForm={() => setShowEditBlog(false)}
          onBlogUpdated={loadBlogs}
        />
      )}
    </div>
  );
}

export default Blog;
