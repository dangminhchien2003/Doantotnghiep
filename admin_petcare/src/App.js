import React from "react";
import {
  BrowserRouter as Router,
  Route,
  Routes,
  Navigate,
} from "react-router-dom";
import Sidebar from "./components/Sidebar/Sidebar";
import Dashboard from "./View/Dashboard/Dashboard";
import Services from "./View/Services_Center/Services";
import Users from "./View/Users/Users";
import Bookings from "./View/Booking/Bookings";
import Center from "./View/Center/Center";
import Login from "./View/Login/Login";
import Profile from "./View/Profile/Profile";
import Medicine from "./View/Medicine/Medicine";
import Blog from "./View/Blog/Blog";
import TopBar from "./components/Topbar/Topbar";
import Payment from "./View/Payment/Payment";
import DashboardIcon from "@mui/icons-material/Dashboard";
import PersonIcon from "@mui/icons-material/Person";
import RoomServiceIcon from "@mui/icons-material/RoomService";
import MapsHomeWorkIcon from "@mui/icons-material/MapsHomeWork";
import LocalPharmacyIcon from "@mui/icons-material/LocalPharmacy";
import ArticleIcon from "@mui/icons-material/Article";
import EventNoteIcon from "@mui/icons-material/EventNote";
import PaymentIcon from "@mui/icons-material/Payment";
// import LogoutIcon from "@mui/icons-material/Logout";
import BusinessCenterIcon from "@mui/icons-material/BusinessCenter";

import { Box } from "@mui/material";
import "./App.css";


function App() {
  const items = [
    {
      title: "Quản lý tổng quan",
      text: "Tổng quan",
      icon: <DashboardIcon />,
      link: "/dashboard",
    },
    {
      title: "Quản lý người dùng",
      text: "Người dùng",
      icon: <PersonIcon />,
      link: "/users",
    },
    {
      title: "Quản lý dịch vụ",
      text: "Dịch vụ",
      icon: <RoomServiceIcon />,
      link: "/services",
    },
    {
      title: "Quản lý trung tâm",
      text: "Trung tâm",
      icon: <MapsHomeWorkIcon />,
      link: "/center",
    },
    {
      title: "Quản lý thuốc",
      text: "Thuốc",
      icon: <LocalPharmacyIcon />,
      link: "/medicine",
    },
    {
      title: "Quản lý Blog",
      text: "Blog",
      icon: <ArticleIcon />,
      link: "/blog",
    },
    {
      title: "Quản lý lịch hẹn",
      text: "Lịch hẹn",
      icon: <EventNoteIcon />,
      link: "/bookings",
    },
    
    {
      title: "Quản lý thanh toán",
      text: "Thanh toán",
      icon: <PaymentIcon />,
      link: "/payment",
    },
    {
      title: "Thông tin tài khoản",
      text: "Thông tin tài khoản",
      icon: <PaymentIcon />,
      link: "/profile",
    },
    
  ];
  // Tạo một mảng Sidebar mà không có mục "Thông tin tài khoản"
//   const fixedItem = items.find((item) => item.title === "Quản lý trung tâm");
//   const sidebarItems = items.filter((item) => item.title !== "Quản lý trung tâm" && item.title !== "Thông tin tài khoản");
// <Sidebar items={sidebarItems} fixedItem={fixedItem} />

  

return (
  <Router>
    <div className="App">
      <Routes>
        <Route path="/" element={<Navigate to="/login" />} />
        <Route path="/login" element={<Login />} />
        <Route
          path="*"
          element={
            <div className="AppGlass" style={{ display: "flex", flexDirection: "row" }}>
              <TopBar items={items} />
              <div style={{ display: "flex", flex: 1 }}>
                {/* Tạo các items cần thiết ở đây */}
                {
                  (() => {
                    const fixedItem = items.find((item) => item.title === "Quản lý trung tâm");
                    const sidebarItems = items.filter(
                      (item) => item.title !== "Quản lý trung tâm" && item.title !== "Thông tin tài khoản"
                    );
                    return (
                      <>
                        <Sidebar items={sidebarItems} fixedItem={fixedItem} />
                        <Box sx={{ flexGrow: 1, padding: "20px" }}>
                          <Routes>
                            <Route path="/dashboard" element={<Dashboard />} />
                            <Route path="/services" element={<Services />} />
                            <Route path="/users" element={<Users />} />
                            <Route path="/bookings" element={<Bookings />} />
                            <Route path="/center" element={<Center />} />
                            <Route path="/medicine" element={<Medicine />} />
                            <Route path="/blog" element={<Blog />} />
                            <Route path="/profile" element={<Profile />} />
                            <Route path="/payment" element={<Payment />} />
                          </Routes>
                        </Box>
                      </>
                    );
                  })()
                }
              </div>
            </div>
          }
        />
      </Routes>
    </div>
  </Router>
);

}

export default App;
