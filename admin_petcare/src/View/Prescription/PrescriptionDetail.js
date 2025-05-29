import React, { useEffect, useState, useCallback } from "react"; // Import useCallback
import "./PrescriptionDetail.css";
import url from "../../ipconfig";
import { toast } from "react-toastify";

const PrescriptionDetail = ({
  bookingId,
  isEditable,
  onClose,
  onSaveSuccess,
}) => {
  const [prescription, setPrescription] = useState(null);
  const [message, setMessage] = useState("");
  const [isEditing, setIsEditing] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [isLoadingMedicines, setIsLoadingMedicines] = useState(false);

  const [editedGhiChu, setEditedGhiChu] = useState("");
  const [editedChitiet, setEditedChitiet] = useState([]);

  const [availableMedicines, setAvailableMedicines] = useState([]);

  //fomat giá
  const formatCurrency = useCallback((value) => {
    const numberValue = parseFloat(value);
    if (isNaN(numberValue)) {
      return "";
    }
    return new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      minimumFractionDigits: numberValue % 1 === 0 ? 0 : 2,
      maximumFractionDigits: 2,
    }).format(numberValue);
  }, []);

  // Định nghĩa hàm fetchPrescription
  const fetchPrescription = useCallback(async () => {
    if (!bookingId) {
      setPrescription(null);
      setMessage("");
      setIsEditing(false);
      setEditedGhiChu("");
      setEditedChitiet([]);
      setIsLoading(false);
      return;
    }

    setIsLoading(true);
    setPrescription(null);
    setMessage("");
    setIsEditing(false); // Đảm bảo chế độ chỉnh sửa tắt khi tải
    setEditedGhiChu("");
    setEditedChitiet([]);

    try {
      const response = await fetch(
        `${url}/Donthuoc/getdonthuoc.php?idlichhen=${bookingId}`
      );
      const data = await response.json();

      if (data.status === "success" && data.data) {
        setPrescription(data.data);
        setEditedGhiChu(data.data.ghichu || "");
        setEditedChitiet(data.data.chitiet || []);
        setIsEditing(false); // Luôn hiển thị chế độ xem nếu tải thành công
      } else {
        // Nếu không thành công hoặc không có dữ liệu, không có đơn thuốc
        setMessage(data.message || "Không tìm thấy đơn thuốc cho lịch hẹn này.");
        setPrescription(null); // Đảm bảo prescription là null
        setIsEditing(false); // Không thể chỉnh sửa/tạo mới nếu không tìm thấy
        setEditedGhiChu(""); // Xóa trạng thái chỉnh sửa trước đó
        setEditedChitiet([]); // Xóa trạng thái chỉnh sửa trước đó
      }
    } catch (error) {
      console.error("Lỗi khi tải đơn thuốc:", error);
      setMessage("Lỗi kết nối API khi tải đơn thuốc.");
      setPrescription(null);
      setIsEditing(false);
      setEditedGhiChu("");
      setEditedChitiet([]);
    } finally {
      setIsLoading(false);
    }
  }, [bookingId]); // Chỉ phụ thuộc vào bookingId

  // useEffect gọi hàm fetchPrescription khi hàm này thay đổi (bookingId thay đổi)
  useEffect(() => {
    fetchPrescription();
  }, [fetchPrescription]);

  // Định nghĩa hàm fetch danh sách thuốc
  const fetchMedicines = useCallback(async () => {
    // Chỉ tải danh sách thuốc nếu có thể chỉnh sửa
    if (!isEditable) {
        setAvailableMedicines([]);
        return;
    }

    setIsLoadingMedicines(true);
    try {
      const response = await fetch(`${url}/Thuoc/getthuocbytrangthai.php`);
      const data = await response.json();
      if (data.status === "success") {
        setAvailableMedicines(data.data || []);
      } else {
        console.error("Lỗi khi tải danh sách thuốc:", data.message);
        setAvailableMedicines([]);
        toast.error("Không thể tải danh sách thuốc.");
      }
    } catch (error) {
      console.error("Lỗi API khi tải danh sách thuốc:", error);
      setAvailableMedicines([]);
      toast.error("Lỗi kết nối khi tải danh sách thuốc.");
    } finally {
      setIsLoadingMedicines(false);
    }

  }, [isEditable]); // Phụ thuộc vào isEditable

  // useEffect để fetch danh sách thuốc khi component mount hoặc isEditing thay đổi
  useEffect(() => {
     // Tải danh sách thuốc chỉ khi ở chế độ chỉnh sửa
     if (isEditing) {
         fetchMedicines();
     } else {
        setAvailableMedicines([]); // Xóa danh sách thuốc nếu không ở chế độ chỉnh sửa
     }
  }, [isEditing, fetchMedicines]); // Phụ thuộc vào isEditing và fetchMedicines


  const handleGhiChuChange = (e) => {
    setEditedGhiChu(e.target.value);
  };

  // Hàm xử lý thay đổi cho chi tiết thuốc
  const handleMedicineDetailChange = (index, field, value) => {
    const newChitiet = [...editedChitiet];
    const itemToUpdate = { ...newChitiet[index] };

    if (field === "tenthuoc") {
      const selectedMedicine = availableMedicines.find(
        (med) => med.tenthuoc === value
      );

      itemToUpdate.tenthuoc = value; // Luôn cập nhật tên đã chọn

      if (selectedMedicine) {
        // Nếu tìm thấy thuốc, cập nhật giá bán và đơn vị tính
        itemToUpdate.giaban = selectedMedicine.giaban;
        itemToUpdate.donvitinh = selectedMedicine.donvitinh || "";
      } else {
        // Nếu chọn "-- Chọn thuốc --" hoặc không tìm thấy
        itemToUpdate.giaban = "";
        itemToUpdate.donvitinh = "";
      }
    } else {
      // Xử lý các trường khác (soluong, lieudung)
      itemToUpdate[field] =
        field === "soluong"
          ? parseFloat(value) || (value === "" ? "" : 0)
          : value;
    }

    newChitiet[index] = itemToUpdate;
    setEditedChitiet(newChitiet);
  };

  const handleAddMedicine = () => {
      // Kiểm tra nếu danh sách thuốc đã tải xong trước khi cho phép thêm
      if (!availableMedicines || availableMedicines.length === 0) {
           toast.warn("Không thể thêm thuốc vì danh sách thuốc chưa được tải hoặc rỗng.");
           return;
      }
    const newItem = {
      tenthuoc: "", // Bắt đầu trống, người dùng phải chọn từ dropdown
      lieudung: "",
      soluong: "",
      donvitinh: "", // Sẽ được điền từ thuốc được chọn
      giaban: "", // Sẽ được điền từ thuốc được chọn
    };
    setEditedChitiet([...editedChitiet, newItem]);
  };

  const handleRemoveMedicine = (index) => {
    const newChitiet = editedChitiet.filter((_, i) => i !== index);
    setEditedChitiet(newChitiet);
  };

  const handleEditClick = () => {
    // Chỉ cho phép chỉnh sửa nếu đối tượng đơn thuốc tồn tại
    if (prescription) {
      setIsEditing(true);
      // Tải dữ liệu đơn thuốc hiện tại vào state chỉnh sửa
      setEditedGhiChu(prescription.ghichu || "");
      setEditedChitiet(prescription.chitiet || []);
      // Tải danh sách thuốc khi vào chế độ chỉnh sửa
      fetchMedicines();
    } else {
        toast.error("Không có đơn thuốc để sửa.");
    }
  };

  const handleCancelEdit = () => {
    setIsEditing(false);
    // Đặt lại state chỉnh sửa về dữ liệu đơn thuốc gốc
    if (prescription) {
      setEditedGhiChu(prescription.ghichu || "");
      setEditedChitiet(prescription.chitiet || []);
    } else {
       // Nếu hủy nhưng không có đơn gốc (không nên xảy ra), xóa các trường
       setEditedGhiChu("");
       setEditedChitiet([]);
    }
     // Xóa state danh sách thuốc khi thoát chế độ chỉnh sửa
     setAvailableMedicines([]);
  };

  const handleSaveClick = async () => {
    // Phải có đơn thuốc mới lưu được (cập nhật)
    if (!prescription || !prescription.iddonthuoc) {
        toast.error("Không tìm thấy thông tin đơn thuốc để lưu.");
        return;
    }

    // Kiểm tra xác thực cơ bản
    if (
      !editedGhiChu.trim() &&
      (!editedChitiet ||
        editedChitiet.length === 0 ||
        editedChitiet.every((item) =>
          Object.values(item).every(
            (val) => val === "" || val === null || val === 0
          )
        ))
    ) {
      toast.warn("Vui lòng nhập ghi chú hoặc thêm chi tiết thuốc.");
      return;
    }

    // Xác thực từng mục thuốc
    const isValidChitiet = editedChitiet.every(
      (item) =>
        item.tenthuoc &&
        item.tenthuoc.trim() !== "" &&
        item.lieudung &&
        item.lieudung.trim() !== "" &&
        item.donvitinh &&
        item.donvitinh.trim() !== "" &&
        !isNaN(parseFloat(item.soluong)) &&
        parseFloat(item.soluong) > 0 &&
        item.giaban !== "" &&
        item.giaban !== null && // Kiểm tra cả null
        !isNaN(parseFloat(item.giaban)) &&
        parseFloat(item.giaban) >= 0
    );

    if (!isValidChitiet) {
      toast.warn(
        "Vui lòng kiểm tra lại thông tin chi tiết thuốc. Đảm bảo tất cả các trường (Tên thuốc, Liều dùng, Số lượng, Đơn vị tính, Giá bán) được điền đầy đủ và hợp lệ (Số lượng > 0, Giá bán >= 0). Tên thuốc phải được chọn từ danh sách."
      );
      return;
    }

    // Luôn sử dụng endpoint cập nhật
    const apiEndpoint = `${url}Donthuoc/updatedonthuoc.php`;

    const payload = {
      iddonthuoc: prescription.iddonthuoc, // Bao gồm idonthuoc để cập nhật
      idlichhen: bookingId,
      ghichu: editedGhiChu,
      chitiet: editedChitiet.map((item) => ({
        // Đảm bảo gửi đúng các trường, khớp với mong đợi của API
        // Giả sử API mong đợi: tenthuoc, lieudung, soluong, donvitinh, giaban
        tenthuoc: item.tenthuoc,
        lieudung: item.lieudung,
        soluong: parseFloat(item.soluong) || 0,
        donvitinh: item.donvitinh,
        giaban: parseFloat(item.giaban) || 0,
         // Nếu API của bạn cần id chi tiết cho các dòng đã tồn tại:
         // idchitiet: item.idchitiet || undefined, // Bao gồm nếu nó tồn tại
      })),
    };

    try {
      setIsLoading(true);
      const response = await fetch(apiEndpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      const result = await response.json();

      if (result.status === "success") {
        toast.success("Cập nhật đơn thuốc thành công!");
        setIsEditing(false);
        fetchPrescription(); // Tải lại dữ liệu đơn thuốc
        onSaveSuccess(); // Thông báo cho component cha
      } else {
        toast.error(
          result.message || "Lỗi khi cập nhật đơn thuốc."
        );
      }
    } catch (error) {
      console.error(`Lỗi API cập nhật đơn thuốc:`, error);
      toast.error(
        "Không thể kết nối đến server để cập nhật đơn thuốc."
      );
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="modal-overlay">
      <div className="modal-content prescription-detail-modal">
        <h3>Đơn thuốc cho lịch hẹn #{bookingId}</h3>

        {(isLoading || isLoadingMedicines) && <p>Đang xử lý...</p>}

        {/* Hiển thị thông báo nếu không tìm thấy đơn thuốc hoặc lỗi API */}
        {!isLoading && !isLoadingMedicines && message && !prescription && (
             <p className="info-message">{message}</p>
        )}

        {/* Chỉ hiển thị chi tiết đơn thuốc nếu đối tượng prescription tồn tại */}
        {prescription && (
          <div>
            {!isEditing && (
              <p>
                <strong>Ngày lập:</strong> {prescription.ngaylap}
              </p>
            )}

            <div>
              <strong>Ghi chú:</strong>{" "}
              {isEditing ? (
                <textarea
                  value={editedGhiChu}
                  onChange={handleGhiChuChange}
                  className="edit-textarea"
                  rows="3"
                />
              ) : (
                <span>{prescription.ghichu || "Không có ghi chú"}</span>
              )}
            </div>

            <h4>Chi tiết thuốc:</h4>
            {isEditing ? (
              isLoadingMedicines ? (
                <p>Đang tải danh sách thuốc...</p>
              ) : editedChitiet && editedChitiet.length > 0 ? (
                <table className="medicine-table edit-mode">
                  <thead>
                    <tr>
                      <th>Tên thuốc</th>
                      <th>Liều dùng</th>
                      <th>Số lượng</th>
                      <th>Đơn vị tính</th>
                      <th>Giá bán</th>
                      <th>Xóa</th>
                    </tr>
                  </thead>
                  <tbody>
                    {editedChitiet.map((medicine, index) => (
                      <tr key={index}>
                        <td>
                          <select
                            className="medicine-input"
                            value={medicine.tenthuoc}
                            onChange={(e) =>
                              handleMedicineDetailChange(
                                index,
                                "tenthuoc",
                                e.target.value
                              )
                            }
                            disabled={isLoadingMedicines}
                          >
                            <option value="">-- Chọn thuốc --</option>
                            {availableMedicines.map((med, medIndex) => (
                              <option key={medIndex} value={med.tenthuoc}>
                                {med.tenthuoc}
                              </option>
                            ))}
                          </select>
                        </td>
                        <td>
                          <input
                            type="text"
                            className="medicine-input"
                            value={medicine.lieudung}
                            onChange={(e) =>
                              handleMedicineDetailChange(
                                index,
                                "lieudung",
                                e.target.value
                              )
                            }
                          />
                        </td>
                        <td>
                          <input
                            type="number"
                            className="medicine-input number-input"
                            value={medicine.soluong}
                            onChange={(e) =>
                              handleMedicineDetailChange(
                                index,
                                "soluong",
                                e.target.value
                              )
                            }
                            min="0"
                          />
                        </td>
                        <td>
                           {/* Đơn vị tính chỉ đọc vì lấy từ thuốc được chọn */}
                           <input
                             type="text"
                             className="medicine-input"
                             value={medicine.donvitinh}
                             readOnly={true}
                             disabled // Thêm disabled cho rõ ràng
                           />
                         </td>
                         <td>
                           {/* Giá bán chỉ đọc vì lấy từ thuốc được chọn */}
                           <input
                             type="text"
                             className="medicine-input"
                              // Hiển thị số thô hoặc rỗng, không định dạng tiền tệ ở đây
                             value={medicine.giaban !== "" && medicine.giaban !== null ? parseFloat(medicine.giaban).toLocaleString('vi-VN', { minimumFractionDigits: 0, maximumFractionDigits: 2 }) : ''}
                             readOnly={true}
                             disabled // Thêm disabled cho rõ ràng
                           />
                         </td>
                        <td>
                          <button
                            className="remove-item-button"
                            onClick={() => handleRemoveMedicine(index)}
                          >
                            Xóa
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              ) : (
                <p>Chưa có chi tiết thuốc. Nhấn "Thêm thuốc" để thêm.</p>
              )
            ) : ( // Chế độ xem
              prescription.chitiet && prescription.chitiet.length > 0 ? (
                <table className="medicine-table">
                  <thead>
                    <tr>
                      <th>Tên thuốc</th>
                      <th>Liều dùng</th>
                      <th>Số lượng</th>
                      <th>Đơn vị tính</th>
                      <th>Giá bán</th>
                    </tr>
                  </thead>
                  <tbody>
                    {prescription.chitiet.map((medicine, index) => (
                      <tr key={index}>
                        <td>{medicine.tenthuoc}</td>
                        <td>{medicine.lieudung}</td>
                        <td>{medicine.soluong}</td>
                        <td>{medicine.donvitinh}</td>
                        <td>{formatCurrency(medicine.giaban)}</td> 
                      </tr>
                    ))}
                  </tbody>
                </table>
              ) : (
                <p>Không có chi tiết thuốc.</p>
              )
            )}

            {/* Nút thêm thuốc chỉ ở chế độ chỉnh sửa VÀ khi danh sách thuốc đã tải */}
            {isEditing && !isLoadingMedicines && availableMedicines.length > 0 && (
              <button className="add-item-button" onClick={handleAddMedicine}>
                + Thêm thuốc
              </button>
            )}
          </div>
        )}

        <div className="modal-actions">
          {/* Nút "Sửa đơn" chỉ hiển thị nếu có thể chỉnh sửa, không ở chế độ chỉnh sửa, có đơn thuốc và không đang tải */}
          {isEditable && !isEditing && prescription && !isLoading && !isLoadingMedicines && (
            <button className="edit-button" onClick={handleEditClick}>
              Sửa đơn
            </button>
          )}

          {/* Nút Lưu và Hủy chỉ hiển thị khi đang ở chế độ chỉnh sửa */}
          {isEditing && !isLoading && !isLoadingMedicines && (
            <>
              <button className="save-button" onClick={handleSaveClick}>
                Lưu đơn
              </button>
              <button className="cancel-button" onClick={handleCancelEdit}>
                Hủy
              </button>
            </>
          )}

          {/* Nút Đóng luôn có sẵn */}
          <button onClick={onClose}>Đóng</button>
        </div>
      </div>
    </div>
  );
};

export default PrescriptionDetail;