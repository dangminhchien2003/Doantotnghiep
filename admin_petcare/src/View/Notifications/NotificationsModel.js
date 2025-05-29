import React, { useState, useEffect } from "react";
import {
  Popover,
  Typography,
  List,
  ListItem,
  ListItemText,
  CircularProgress,
  Box,
  DialogTitle,
  DialogContent,
} from "@mui/material";
import { InfoOutlined } from "@mui/icons-material";
import url from "../../ipconfig";

import "./NotificationsModel.css";

const NotificationsModel = ({ open, onClose, user, anchorEl }) => {
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (open && user && user.idnguoidung) {
      fetchNotifications(user.idnguoidung);
    } else if (!open) {
      setNotifications([]);
      setLoading(true);
    }
  }, [open, user]);

  const fetchNotifications = async (userId) => {
    setLoading(true);
    try {
      const response = await fetch(`${url}Thongbao/getthongbao.php?idnguoidung=${userId}`);
      if (!response.ok) {
        // Cố gắng đọc lỗi từ body nếu có
        let errorMsg = `Lỗi HTTP! Trạng thái: ${response.status}`;
        try {
            const errorData = await response.json();
            if (errorData && errorData.message) {
                errorMsg += `. Thông báo: ${errorData.message}`;
            }
        } catch (jsonError) {
            // Nếu không thể parse JSON, có thể server trả về lỗi dạng text/html
            console.error("Không thể parse lỗi API response:", jsonError);
        }
        throw new Error(errorMsg);
      }
      const result = await response.json();

      if (result && result.data && result.data.items) {
        setNotifications(result.data.items);
      } else {
        setNotifications([]);
        console.warn("Phản hồi API cho getthongbao không chứa 'data.items' như mong đợi:", result);
      }
    } catch (error) {
      console.error("Lỗi khi lấy thông báo:", error);
      setNotifications([]);
    } finally {
      setLoading(false);
    }
  };

 const markNotificationAsRead = async (notificationId) => {
  try {
    const response = await fetch(`${url}Thongbao/capnhattrangthaithongbao.php`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ idthongbao: notificationId }),
    });

    let data = {};
    try {
      data = await response.json();
    } catch (jsonParseError) {
      console.error("Không thể parse JSON từ server:", jsonParseError);
      throw new Error(`Phản hồi không hợp lệ (không phải JSON). Mã: ${response.status}`);
    }

    if (!response.ok) {
      throw new Error(`Server trả về lỗi: ${data.message || `Mã lỗi HTTP ${response.status}`}`);
    }

    if (!data.success) {
      throw new Error(`Lỗi phía server: ${data.message || "Không rõ lỗi."}`);
    }

    // ✅ Thành công, không cần xử lý thêm
  } catch (error) {
    console.error("Lỗi khi đánh dấu đã đọc:", error.message);
  }
};


  const handleNotificationClick = (notificationId) => {
    // setSelectedNotificationId(notificationId); // Bỏ comment nếu muốn highlight

    setNotifications((prevNotifications) =>
      prevNotifications.map((noti) => {
        if (noti.idthongbao === notificationId || noti.id === notificationId || noti._id === notificationId) {
          if (noti.trangthai === 0) { // Chỉ gọi API nếu thông báo chưa đọc
            markNotificationAsRead(notificationId);
            return { ...noti, trangthai: 1 }; // Cập nhật trạng thái cục bộ
          }
        }
        return noti;
      })
    );
  };

  return (
    <Popover
      open={open}
      anchorEl={anchorEl}
      onClose={onClose}
      anchorOrigin={{
        vertical: 'bottom',
        horizontal: 'right',
      }}
      transformOrigin={{
        vertical: 'top',
        horizontal: 'right',
      }}
      PaperProps={{
        className: 'notifications-model-paper',
      }}
    >
      <DialogTitle sx={{ padding: '16px 16px 8px' }}>Thông báo của bạn</DialogTitle>
      <DialogContent sx={{ padding: '0 16px 16px' }}>
        {loading ? (
          <Box className="notifications-loading-box">
            <CircularProgress size={30} />
            <Typography sx={{ marginLeft: '10px' }}>Đang tải thông báo...</Typography>
          </Box>
        ) : notifications.length > 0 ? (
          <List dense>
            {notifications.map((notification) => {
              const isUnread = notification.trangthai === 0;
              // const isSelected = (notification.idthongbao === selectedNotificationId || notification.id === selectedNotificationId || notification._id === selectedNotificationId);

              const listItemClassName = `notifications-list-item ${isUnread ? 'unread' : 'read'}`; // Bỏ ${isSelected ? 'active' : ''}

              return (
                <ListItem
                  key={notification.idthongbao || notification.id || notification._id}
                  divider
                  className={listItemClassName}
                  onClick={() => handleNotificationClick(notification.idthongbao || notification.id || notification._id)}
                >
                  <ListItemText
                    primary={
                      <Typography variant="subtitle2" className="notifications-list-item-primary">
                        {notification.tieuDe || notification.tieude || "Không có tiêu đề"}
                      </Typography>
                    }
                    secondary={
                      <Typography variant="body2" className="notifications-list-item-secondary">
                        {notification.noiDung || notification.noidung || "Không có nội dung"}
                      </Typography>
                    }
                  />
                </ListItem>
              );
            })}
          </List>
        ) : (
          <Typography className="notifications-no-data">
            <InfoOutlined color="action" />
            Không có thông báo nào.
          </Typography>
        )}
      </DialogContent>
    </Popover>
  );
};

export default NotificationsModel;