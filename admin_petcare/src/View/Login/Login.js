import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./Login.css";
import petcareImage from "../../assets/images/petlogo.avif"; 
import url from "../../ipconfig";
import { toast } from "react-toastify";

const AdminLogin = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    
    // Kiểm tra ngoại lệ
    if (!email.includes("@") || !email.includes(".")) {
      setError("Email không hợp lệ. Vui lòng nhập email đúng định dạng.");
      return;
    }
  
    if (password.length < 6) {
      setError("Mật khẩu phải có ít nhất 6 ký tự.");
      return;
    }
  
    try {
      const response = await fetch(`${url}/Dangnhap/admin_dangnhap.php`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: new URLSearchParams({
          email: email,
          matkhau: password,
        }),
      });
  
      const data = await response.json();
  
      if (data && data.success) {
        // Lưu thông tin người dùng vào localStorage
        localStorage.setItem("user", JSON.stringify({
          idnguoidung: data.user.idnguoidung,
          tennguoidung: data.user.tennguoidung,
          email: data.user.email,
          sodienthoai: data.user.sodienthoai,
          diachi: data.user.diachi,
          vaitro: data.user.vaitro, // Lưu vai trò để dùng trong dashboard
        }));

        toast.success(data.message);

        // Điều hướng đến Dashboard
        navigate("/dashboard", { state: { toastMessage: data.message } });
      } else {
        setError(data.message || "Sai thông tin email hoặc mật khẩu. Vui lòng thử lại.");
      }
    } catch (error) {
      console.error("Lỗi đăng nhập:", error);
      setError("Đã xảy ra lỗi trong quá trình đăng nhập, vui lòng thử lại sau.");
    }
  };
  

  return (
    <div className="login-page">
      <div className="image-container">
        <img src={petcareImage} alt="Petcare System" className="petcare-image" />
      </div>
      
      <div className="login-container">
        <h2>PetMart Login</h2>
        {error && <p className="error-message">{error}</p>}
        <form onSubmit={handleLogin}>
          <div className="login-container-div">
            <label className="label">Email</label>
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>
          <div className="login-container-div">
            <label className="label">Password</label>
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          <button className="button-login" type="submit">Đăng Nhập</button>
        </form>
      </div>
    </div>
  );
};

export default AdminLogin;
