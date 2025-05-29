import React, { useState, useEffect } from "react";
import {
  AppBar,
  Toolbar,
  Typography,
  IconButton,
  Menu,
  MenuItem,
} from "@mui/material";
import {
  AccountCircle,
  Notifications,
  Menu as MenuIcon,
  ExitToApp,
  AccountBox,
} from "@mui/icons-material"; // Thêm icon mới
import { useLocation, useNavigate } from "react-router-dom";
import "./Topbar.css";
import NotificationsModel from "../../View/Notifications/NotificationsModel";

const TopBar = ({ items }) => {
  const location = useLocation();
  const navigate = useNavigate();
  const [user, setUser] = useState(null);
  const [anchorEl, setAnchorEl] = useState(null);
  const [openNotificationsModal, setOpenNotificationsModal] = useState(false);
  const [notificationsAnchorEl, setNotificationsAnchorEl] = useState(null);

  useEffect(() => {
    // Lấy thông tin người dùng từ localStorage
    const storedUser = JSON.parse(localStorage.getItem("user"));
    setUser(storedUser);
  }, []);

  if (!user) {
    return <p>Đang tải...</p>;
  }

  console.log(JSON.parse(localStorage.getItem("user")));

  // Tìm `title` dựa trên đường dẫn hiện tại
  const currentItem = items.find((item) => item.link === location.pathname);
  const title = currentItem ? currentItem.title : "Tiêu đề ứng dụng";

  // Mở Menu khi nhấn vào biểu tượng AccountCircle
  const handleMenuClick = (event) => {
    setAnchorEl(event.currentTarget);
  };

  // Đóng Menu
  const handleMenuClose = () => {
    setAnchorEl(null);
  };

  // Đăng xuất
  const handleLogout = () => {
    // Xóa thông tin người dùng trong localStorage và chuyển hướng về trang login
    localStorage.removeItem("user");
    window.location.href = "/login"; // Hoặc sử dụng `history.push("/login")` nếu sử dụng React Router.
  };

  // Chuyển hướng đến trang thông tin tài khoản
  const handleGoToAccountInfo = () => {
    navigate("/profile"); // Đường dẫn trang thông tin tài khoản
    handleMenuClose(); // Đóng menu sau khi chuyển trang
  };

  // Mở modal thông báo (chỉ cần đổi state)
  const handleOpenNotificationsModal = (event) => {
     setNotificationsAnchorEl(event.currentTarget);
    setOpenNotificationsModal(true);
  };

  // Đóng modal thông báo (chỉ cần đổi state)
  const handleCloseNotificationsModal = () => {
    setOpenNotificationsModal(false);
     setNotificationsAnchorEl(null); 
  };

  return (
    <AppBar position="fixed" className="topbar">
      <Toolbar className="topbar-toolbar">
        {/* Icon Menu */}
        <IconButton edge="start" aria-label="menu" className="menu-icon">
          <MenuIcon />
        </IconButton>

        {/* Tiêu đề */}
        <Typography variant="h6" component="div" className="topbar-title">
          {title}
        </Typography>

        {/* Các icon bên phải */}
        <div className="topbar-actions">
          <span className="user-name">{user.tennguoidung}</span>

          {/* Biểu tượng người dùng, khi nhấn vào sẽ mở menu */}
          <IconButton
            edge="end"
            className="icon"
            onClick={handleMenuClick}
            aria-controls="menu-appbar"
            aria-haspopup="true"
          >
            <AccountCircle />
          </IconButton>

          {/* Biểu tượng thông báo */}
          <IconButton
            edge="end"
            className="icon"
            onClick={handleOpenNotificationsModal} // Chỉ cần gọi hàm mở modal
          >
            <Notifications />
          </IconButton>
        </div>
      </Toolbar>

      {/* Menu hiển thị thông tin tài khoản và đăng xuất */}
      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleMenuClose}
        anchorOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
        transformOrigin={{
          vertical: "top",
          horizontal: "right",
        }}
      >
        {/* Menu Item: Thông tin tài khoản */}
        <MenuItem onClick={handleGoToAccountInfo}>
          <AccountBox style={{ marginRight: "10px" }} />
          Thông tin tài khoản
        </MenuItem>

        {/* Menu Item: Đăng xuất */}
        <MenuItem onClick={handleLogout}>
          <ExitToApp style={{ marginRight: "10px" }} />
          Đăng xuất
        </MenuItem>
      </Menu>
      <NotificationsModel
        open={openNotificationsModal}
        onClose={handleCloseNotificationsModal} // Truyền hàm đóng modal vào prop 'onClose'
        user={user} // Truyền thông tin người dùng vào prop 'user'
         anchorEl={notificationsAnchorEl}
      />
    </AppBar>
  );
};

export default TopBar;
