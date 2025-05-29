import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getMessaging, getToken, onMessage } from "firebase/messaging"; 

const firebaseConfig = {
  apiKey: "AIzaSyDOScqX0dCS4nqsF1wMHBYXBQU7JI3uShg",
  authDomain: "bookingpetcare.firebaseapp.com",
  projectId: "bookingpetcare",
  storageBucket: "bookingpetcare.firebasestorage.app",
  messagingSenderId: "591804418697",
  appId: "1:591804418697:web:6ce921d74b6850b5e21458",
  measurementId: "G-5X6E0F39NW",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const messaging = getMessaging(app);

export { app, analytics, messaging, getToken, onMessage };
