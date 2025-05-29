import React, { useEffect, useState } from "react";
import AddMedicine from "./AddMedicine";
import EditMedicine from "./EditMedicine";
import "./Medicine.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import url from "../../ipconfig";
import { toast, ToastContainer } from "react-toastify";
import useDebounce from "../../common/useDebounce";

function Medicine() {
  const [medicine, setMedicine] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [filteredMedicine, setFilteredMedicine] = useState([]);
  const [showAddMedicine, setShowAddMedicine] = useState(false);
  const [showEditMedicine, setShowEditMedicine] = useState(false);
  const [medicineToEdit, setMedicineToEdit] = useState(null);

  // phân trang
  const [currentPage, setCurrentPage] = useState(1);
  const itemsPerPage = 4;

  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentItems = filteredMedicine.slice(
    indexOfFirstItem,
    indexOfLastItem
  );
  const totalPages = Math.ceil(filteredMedicine.length / itemsPerPage);

  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const debounceKeyword = useDebounce(searchTerm, 500);

  // Tải danh sách thuốc từ API
  const loadMedicine = async () => {
    try {
      const response = await fetch(`${url}/Thuoc/getthuoc.php`);
      if (!response.ok) {
        throw new Error("Lỗi khi tải dữ liệu");
      }
      const data = await response.json();

      // Kiểm tra cấu trúc dữ liệu nhận được
      console.log("Dữ liệu thuốc nhận được từ API:", data);

      // Sử dụng data.data thay vì data
      setMedicine(data.data); // data.data là mảng thuốc thực sự
      setFilteredMedicine(data.data); // Sử dụng mảng thuốc thực sự
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      alert(
        "Không thể tải danh sách thuốc. Vui lòng kiểm tra kết nối hoặc dữ liệu."
      );
    }
  };

  // Hàm tìm kiếm thuốc
  const searchMedicine = async (searchTerm) => {
    try {
      const response = await fetch(
        `${url}/Thuoc/timkiemthuoc.php?searchTerm=${searchTerm}`
      );
      if (!response.ok) {
        throw new Error("Lỗi khi tìm kiếm thuốc");
      }
      const data = await response.json();
      setFilteredMedicine(data.medicines); // Dữ liệu trả về từ API chứa mảng thuốc trong key 'medicines'
    } catch (error) {
      console.error("Lỗi khi tìm kiếm:", error);
      alert("Không thể tìm kiếm thuốc. Vui lòng thử lại.");
    }
  };

  useEffect(() => {
    loadMedicine();
  }, []);

  useEffect(() => {
    if (debounceKeyword.trim() === "") {
      setFilteredMedicine(medicine); // Nếu ô tìm kiếm rỗng, hiển thị tất cả thuốc
    } else {
      searchMedicine(debounceKeyword); // Gọi hàm tìm kiếm người dùng
    }
  }, [debounceKeyword, medicine]);

  const editMedicine = (medicine) => {
    setMedicineToEdit(medicine);
    setShowEditMedicine(true);
  };

  const deleteMedicine = async (id) => {
    const confirmDelete = window.confirm("Bạn có muốn xóa thuốc này không?");
    if (confirmDelete) {
      try {
        const response = await fetch(`${url}/Thuoc/xoathuoc.php?id=${id}`, {
          method: "DELETE",
        });

        if (response.ok) {
          const result = await response.json();
          toast.success(result.message);
          loadMedicine();
        } else {
          const errorResult = await response.json();
          alert("Có lỗi xảy ra khi xóa thuốc: " + errorResult.message);
        }
      } catch (error) {
        console.error("Lỗi khi xóa thuốc:", error);
        toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
      }
    }
  };

  // Hàm format giá tiền
  const formatPrice = (price) => {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  };
  

  return (
    <div id="Medicine" className="Medicine-content-section">
      <ToastContainer style={{ top: 70 }} />
      {/* Thanh tìm kiếm với icon */}
      <div className="Medicine-search-container">
        <i className="fas fa-search Medicine-search-icon"></i>
        <input
          type="text"
          placeholder="Tìm kiếm thuốc..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="Medicine-search-input"
        />
      </div>
      <div id="MedicineTable">
        {filteredMedicine.length > 0 ? (
          <table className="Medicine-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Tên thuốc</th>
                <th>Mô tả</th>
                <th>Giá</th>
                <th>Đơn vị</th>
                <th>Số lượng tồn</th>
                <th>Hạn sử dụng</th>
                <th>Nhà cung cấp</th>
                <th>Loại</th>
                <th>Trạng thái</th>
                <th>Ngày nhập</th>
                <th>Chức năng</th>
              </tr>
            </thead>
            <tbody>
              {/* {filteredMedicine.map((thuoc) => ( */}
              {currentItems.map((thuoc) => (
                <tr key={thuoc.id}>
                  <td>{thuoc.id}</td>
                  <td>{thuoc.tenthuoc}</td>
                  <td>{thuoc.mota}</td>
                  <td>{formatPrice(thuoc.giaban)}</td>
                  <td>{thuoc.donvitinh}</td>
                  <td>{thuoc.soluongton}</td>
                  <td>{thuoc.hansudung}</td>
                  <td>{thuoc.nhacungcap}</td>
                  <td>{thuoc.loai}</td>
                  <td>{thuoc.trangthai === "1" ? "Đang bán" : "Ngừng bán"}</td>
                  <td>{thuoc.ngaynhap}</td>
                  <td>
                    <button
                      className="Medicine-edit"
                      onClick={() => editMedicine(thuoc)}
                    >
                      Sửa
                    </button>
                    <button
                      className="Medicine-delete"
                      onClick={() => deleteMedicine(thuoc.id)}
                    >
                      Xóa
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>Không có thuốc nào</p>
        )}
      </div>
      {filteredMedicine.length > 0 && totalPages > 0 && (
        <div className="Medicine-pagination">
          <button
            className="Medicine-page-nav Medicine-page-prev"
            onClick={() => paginate(currentPage - 1)}
            disabled={currentPage === 1}
            aria-label="Trang trước"
          >
            <i className="fas fa-chevron-left"></i>
          </button>
          <span className="Medicine-page-current">{currentPage}</span>
          <button
            className="Medicine-page-nav Medicine-page-next"
            onClick={() => paginate(currentPage + 1)}
            disabled={currentPage === totalPages}
            aria-label="Trang sau"
          >
            <i className="fas fa-chevron-right"></i>
          </button>
        </div>
      )}

      <button
        className="Medicine-floating-btn"
        onClick={() => setShowAddMedicine(true)}
      >
        +
      </button>

      {showAddMedicine && (
        <AddMedicine
          closeForm={() => setShowAddMedicine(false)}
          onMedicineAdded={loadMedicine}
        />
      )}

      {showEditMedicine && (
        <EditMedicine
          medicineToEdit={medicineToEdit}
          closeForm={() => setShowEditMedicine(false)}
          onMedicineUpdated={loadMedicine}
        />
      )}
    </div>
  );
}

export default Medicine;
