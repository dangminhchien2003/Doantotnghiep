import React from "react";
import logoPet from "../../assets/images/petlogo.avif";
import {
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Drawer,
} from "@mui/material";
import "./Sidebar.css";

import { Link, useLocation } from "react-router-dom";

const Sidebar = ({ items, fixedItem }) => {
  const location = useLocation();

  return (
    <Drawer classes={{ paper: "sidebar-container" }} variant="permanent">
      <div className="sidebar-header">
        <div className="sidebar-logo-container">
          <img src={logoPet} alt="Petcare Logo" className="sidebar-logo" />
          <h2 className="sidebar-title">Quản trị hệ thống</h2>
        </div>
      </div>

      <div className="sidebar-content">
        <List className="sidebar-list">
          {items.map((item, index) => (
            <ListItem
              button
              component={Link}
              to={item.link}
              key={index}
              className={`sidebar-item ${location.pathname === item.link ? "active" : ""}`}
            >
              <ListItemIcon className={`sidebar-icon ${location.pathname === item.link ? "active" : ""}`}>
                {item.icon}
              </ListItemIcon>
              <ListItemText primary={item.text} />
            </ListItem>
          ))}
        </List>

        {/* Item cố định ở dưới */}
        {fixedItem && (
          <div className="sidebar-fixed-item">
            <ListItem
              button
              component={Link}
              to={fixedItem.link}
              className={`sidebar-item ${location.pathname === fixedItem.link ? "active" : ""}`}
            >
              <ListItemIcon className={`sidebar-icon ${location.pathname === fixedItem.link ? "active" : ""}`}>
                {fixedItem.icon}
              </ListItemIcon>
              <ListItemText primary={fixedItem.text} />
            </ListItem>
          </div>
        )}
      </div>
    </Drawer>
  );
};


export default Sidebar;
