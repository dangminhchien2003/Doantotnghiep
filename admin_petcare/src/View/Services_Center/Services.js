import React, { useEffect, useState } from "react";
import AddService from "./AddServices";
import EditService from "./EditServices";
import "./Services.css";
import "@fortawesome/fontawesome-free/css/all.min.css";
import url from "../../ipconfig";
import { toast, ToastContainer } from "react-toastify";
import useDebounce from "../../common/useDebounce";

function Services() {
  const [services, setServices] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [filteredServices, setFilteredServices] = useState([]);
  const [showAddService, setShowAddService] = useState(false);
  const [showEditService, setShowEditService] = useState(false);
  const [serviceToEdit, setServiceToEdit] = useState(null);

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
  const itemsPerPage = 4; // số dịch vụ mỗi trang

  // Tính toán các phần tử cho trang hiện tại
  const indexOfLastItem = currentPage * itemsPerPage;
  const indexOfFirstItem = indexOfLastItem - itemsPerPage;
  const currentServices = filteredServices.slice(
    indexOfFirstItem,
    indexOfLastItem
  );

  const totalPages = Math.ceil(filteredServices.length / itemsPerPage);

  // Hàm chuyển trang
  const paginate = (pageNumber) => setCurrentPage(pageNumber);

  const loadServices = async () => {
    try {
      const response = await fetch(`${url}/Dichvu/getdichvu.php`);
      if (!response.ok) {
        throw new Error("Lỗi khi tải dữ liệu");
      }
      const data = await response.json();
      setServices(data);
      setFilteredServices(data);
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu:", error);
      alert(
        "Không thể tải danh sách dịch vụ. Vui lòng kiểm tra kết nối hoặc dữ liệu."
      );
    }
  };

  // Hàm tìm kiếm dịch vụ
  const searchServices = async (searchTerm) => {
    try {
      const response = await fetch(
        `${url}/Dichvu/timkiemdichvu.php?searchTerm=${searchTerm}`
      );
      if (!response.ok) {
        throw new Error("Lỗi khi tìm kiếm người dùng");
      }
      const data = await response.json();
      setFilteredServices(data);
    } catch (error) {
      console.error("Lỗi khi tìm kiếm:", error);
      alert("Không thể tìm kiếm người dùng. Vui lòng thử lại.");
    }
  };

  useEffect(() => {
    loadServices();
  }, []);

  useEffect(() => {
    if (debounceKeyword.trim() === "") {
      setFilteredServices(services); // Nếu ô tìm kiếm rỗng, hiển thị tất cả dịch vụ
    } else {
      searchServices(debounceKeyword); // Gọi hàm tìm kiếm người dùng
    }
  }, [debounceKeyword, services]);

  const editService = (service) => {
    setServiceToEdit(service);
    setShowEditService(true);
  };

  const deleteService = async (id) => {
    const confirmDelete = window.confirm("Bạn có muốn xóa dịch vụ này không?");
    if (confirmDelete) {
      try {
        const response = await fetch(`${url}/Dichvu/xoadichvu.php?id=${id}`, {
          method: "DELETE",
        });

        if (response.ok) {
          const result = await response.json();
          toast.success(result.message);
          loadServices();
        } else {
          const errorResult = await response.json();
          alert("Có lỗi xảy ra khi xóa dịch vụ: " + errorResult.message);
        }
      } catch (error) {
        console.error("Lỗi khi xóa dịch vụ:", error);
        toast.error("Đã xảy ra lỗi. Vui lòng thử lại.");
      }
    }
  };
  // Hàm format giá tiền
  const formatPrice = (price) => {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  };

  return (
    <div id="services" className="services-content-section">
      <ToastContainer style={{ top: 70 }} />
      {/* Thanh tìm kiếm với icon */}
      <div className="services-search-container">
        <i className="fas fa-search services-search-icon"></i>
        <input
          type="text"
          placeholder="Tìm kiếm dịch vụ..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="services-search-input"
        />
      </div>
      <div id="servicesTable">
        {filteredServices.length > 0 ? (
          <table className="services-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Tên dịch vụ</th>
                <th>Mô tả</th>
                <th>Giá</th>
                <th>Thời gian thực hiện</th>
                <th>Hình ảnh</th>
                <th>Chức năng</th>
              </tr>
            </thead>
            <tbody>
              {/* {filteredServices.map((service) => ( */}
              {currentServices.map((service) => (
                <tr key={service.iddichvu}>
                  <td>{service.iddichvu}</td>
                  <td>{service.tendichvu}</td>
                  {/* <td>{service.mota}</td> */}
                  <td>
                    {expandedDescriptions[service.iddichvu]
                      ? service.mota
                      : service.mota.length > 50
                      ? service.mota.slice(0, 50) + "..."
                      : service.mota}
                    {service.mota.length > 50 && (
                      <button
                        onClick={() => toggleDescription(service.iddichvu)}
                        className="service-toggle-description-btn"
                      >
                        {expandedDescriptions[service.iddichvu]
                          ? "Thu gọn"
                          : "Xem thêm"}
                      </button>
                    )}
                  </td>

                  <td>{formatPrice(service.gia)}</td>
                  <td>{service.thoigianthuchien}</td>
                  <td>
                    <img
                      src={service.hinhanh}
                      alt="Hình ảnh"
                      style={{
                        width: "100px",
                        height: "100px",
                        objectFit: "cover",
                      }}
                    />
                  </td>
                  <td>
                    <button
                      className="services-edit"
                      onClick={() => editService(service)}
                    >
                      Sửa
                    </button>
                    <button
                      className="services-delete"
                      onClick={() => deleteService(service.iddichvu)}
                    >
                      Xóa
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <p>Không có dịch vụ nào</p>
        )}
      </div>

    {filteredServices.length > 0 && totalPages > 0 && (
        <div className="services-pagination">
          <button
            className="services-page-nav services-page-prev"
            onClick={() => paginate(currentPage - 1)}
            disabled={currentPage === 1}
            aria-label="Trang trước"
          >
            <i className="fas fa-chevron-left"></i>
          </button>
          <span className="services-page-current">{currentPage}</span>
          <button
            className="services-page-nav services-page-next"
            onClick={() => paginate(currentPage + 1)}
            disabled={currentPage === totalPages}
            aria-label="Trang sau"
          >
            <i className="fas fa-chevron-right"></i>
          </button>
        </div>
      )}

      <button
        className="services-floating-btn"
        onClick={() => setShowAddService(true)}
      >
        +
      </button>

      {showAddService && (
        <AddService
          closeForm={() => setShowAddService(false)}
          onServiceAdded={loadServices}
        />
      )}

      {showEditService && (
        <EditService
          serviceToEdit={serviceToEdit}
          closeForm={() => setShowEditService(false)}
          onServiceUpdated={loadServices}
        />
      )}
    </div>
  );
}

export default Services;
