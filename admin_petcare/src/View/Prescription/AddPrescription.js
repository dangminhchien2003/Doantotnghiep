import React, { useState, useEffect } from "react";
import "./AddPrescription.css";
import url from "../../ipconfig";

const AddPrescription = ({ bookingId, onClose, onSuccess }) => {
  const [medicinesList, setMedicinesList] = useState([]);
  const [medicines, setMedicines] = useState([
    { medicineId: "", dosage: "", quantity: "" },
  ]);
  const [notes, setNotes] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  useEffect(() => {
    const fetchMedicines = async () => {
      try {
        const response = await fetch(`${url}/Thuoc/getthuocbytrangthai.php`);
        const data = await response.json();
        if (data.status === "success") {
          setMedicinesList(data.data);
        } else {
          setMessage("Lỗi lấy danh sách thuốc: " + data.message);
        }
      } catch (error) {
        console.error("Lỗi kết nối API", error);
        setMessage("Lỗi kết nối API");
      }
    };

    fetchMedicines();
  }, []);

  const addMedicine = () => {
    setMedicines([...medicines, { medicineId: "", dosage: "", quantity: "" }]);
  };

  const handleChangeMedicine = (index, field, value) => {
    const updated = [...medicines];
    updated[index][field] = value;
    setMedicines(updated);
  };

  const removeMedicine = (index) => {
    const updated = medicines.filter((_, i) => i !== index);
    setMedicines(updated);
  };

  const handleSubmit = async () => {
    if (
      medicines.some((med) => !med.medicineId || !med.dosage || !med.quantity)
    ) {
      setMessage("Vui lòng nhập đầy đủ thông tin thuốc.");
      return;
    }

    setLoading(true);
    setMessage("");

    // const currentDate = new Date().toISOString().split("T")[0];
    const now = new Date();
    const year = now.getFullYear();
    const month = ("0" + (now.getMonth() + 1)).slice(-2); // Tháng bắt đầu từ 0, cộng 1 và thêm số 0 đằng trước nếu cần
    const day = ("0" + now.getDate()).slice(-2); // Thêm số 0 đằng trước nếu cần
    const hours = ("0" + now.getHours()).slice(-2); // Thêm số 0 đằng trước nếu cần
    const minutes = ("0" + now.getMinutes()).slice(-2); // Thêm số 0 đằng trước nếu cần
    const seconds = ("0" + now.getSeconds()).slice(-2); // Thêm số 0 đằng trước nếu cần

    const formattedDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

    try {
      const response = await fetch(`${url}Donthuoc/themdonthuoc.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          idlichhen: bookingId,
          ngaylap: formattedDateTime,
          ghichu: notes,
          chitiet: medicines.map((med) => ({
            idthuoc: med.medicineId,
            soluong: med.quantity,
            lieudung: med.dosage,
          })),
        }),
      });

      const data = await response.json();

      if (data.status === "success") {
        setMessage("Thêm đơn thuốc thành công!");
        onSuccess();
        onClose();
      } else {
        setMessage("Lỗi: " + data.message);
      }
    } catch (error) {
      setMessage("Lỗi kết nối API");
      console.error("API Error:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay">
      <div className="prescription-modal-content">
        <h3>Thêm đơn thuốc cho lịch hẹn #{bookingId}</h3>

        <div className="prescription-list">
          {medicines.map((medicine, index) => (
            <div key={index} className="prescription-item">
              <select
                value={medicine.medicineId}
                onChange={(e) =>
                  handleChangeMedicine(index, "medicineId", e.target.value)
                }
              >
                <option value="">Chọn thuốc</option>
                {medicinesList.length > 0 ? (
                  medicinesList.map((med) => (
                    <option key={med.id} value={med.id}>
                      {med.tenthuoc} - {med.donvitinh} - {med.giaban} VND
                    </option>
                  ))
                ) : (
                  <option disabled>Không có thuốc</option>
                )}
              </select>

              <div className="prescription-subrow">
                <div className="prescription-inputs">
                  <input
                    type="text"
                    placeholder="Số lượng"
                    value={medicine.quantity}
                    onChange={(e) =>
                      handleChangeMedicine(index, "quantity", e.target.value)
                    }
                  />
                  <input
                    type="text"
                    placeholder="Liều dùng"
                    value={medicine.dosage}
                    onChange={(e) =>
                      handleChangeMedicine(index, "dosage", e.target.value)
                    }
                  />
                </div>
                {index > 0 && (
                  <div className="delete-container">
                    <button
                      className="delete-button"
                      onClick={() => removeMedicine(index)}
                    >
                      Xóa thuốc
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        <button
          className="prescription-addmedicine-button"
          onClick={addMedicine}
        >
          Thêm thuốc
        </button>

        <textarea className="addpre-ghichu"
          placeholder="Ghi chú"
          value={notes}
          onChange={(e) => setNotes(e.target.value)}
        ></textarea>

        {message && <p className="message">{message}</p>}

        <div className="modal-actions">
          <button onClick={handleSubmit} disabled={loading}>
            {loading ? "Đang lưu..." : "Lưu đơn"}
          </button>
          <button onClick={onClose}>Đóng</button>
        </div>
      </div>
    </div>
  );
};

export default AddPrescription;
