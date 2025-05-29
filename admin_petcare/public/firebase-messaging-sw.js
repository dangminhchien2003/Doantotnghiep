// Import Firebase SDKs
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

// Replace with your project's Firebase credentials
const firebaseConfig = {
  apiKey: "AIzaSyDOScqX0dCS4nqsF1wMHBYXBQU7JI3uShg",
  authDomain: "bookingpetcare.firebaseapp.com",
  projectId: "bookingpetcare",
  storageBucket: "bookingpetcare.firebasestorage.app",
  messagingSenderId: "591804418697",
  appId: "1:591804418697:web:6ce921d74b6850b5e21458",
  measurementId: "G-5X6E0F39NW"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/admin_petcare/src/assets/images/logopet.jpg', 
    data: payload.data
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});