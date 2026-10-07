# 🛍️ Fashion E-Commerce App

A modern fashion e-commerce mobile application built with **Flutter and Dart**, designed to provide a smooth and convenient shopping experience.

The application allows users to browse fashion products, view product details, manage favorites and shopping cart items, control product quantities, complete the checkout process, and manage their orders.

## ✨ Features

### 🔐 Authentication

* User registration
* User login
* User logout
* Authentication state handling
* Backend authentication integration

### 🛍️ Product Browsing

* Browse available fashion products
* Display product images, names, prices, and details
* View detailed product information
* Backend API integration for product data

### ❤️ Favorites

* Add products to favorites
* Remove products from favorites
* View favorite products
* Manage user-specific favorite items

### 🛒 Shopping Cart

* Add products to cart
* Remove products from cart
* View selected products
* Display product prices
* Calculate cart total

### 🔢 Quantity Management

* Increase product quantity
* Decrease product quantity
* Remove products from cart
* Dynamically update the total price

### 💳 Checkout

* Review cart items
* Review product quantities
* Calculate the total amount
* Confirm orders
* Create orders through the backend

### 📋 Order Management

* Create orders
* View previous orders
* View order information
* View order details

### 🔗 Backend Integration

The application communicates with a backend API to handle:

* Authentication
* Product data
* Favorites
* Cart operations
* Checkout
* Orders

---

## 🧠 State Management

The application uses **Cubit** from the Flutter BLoC package for state management.

Cubit is used to separate business logic from the UI and manage the state of different application features.

Main areas handled using Cubit include:

* Authentication
* Products
* Favorites
* Cart
* Checkout
* Orders

### Cubit Flow

```text
User Interaction
       ↓
     Cubit
       ↓
 Business Logic
       ↓
 API / Backend
       ↓
 State Changes
       ↓
      UI
```

This approach keeps the application organized and makes the business logic easier to maintain and extend.

---

## 🏗️ Application Architecture

The application follows a structured architecture that separates the UI, business logic, and data handling.

```text
┌──────────────────────────┐
│       Flutter UI         │
│    Screens & Widgets     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│          Cubit           │
│   State & Business Logic │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│       Data Layer         │
│      API / Services      │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│         Backend          │
│ Users / Products / Orders│
└──────────────────────────┘
```

---

## 🛠️ Technologies & Packages

### Core

* **Flutter**
* **Dart**
* **Material Design**

### State Management

* **Flutter BLoC / Cubit**

### Networking

* **Dio**

### Dependency Injection

* **GetIt**

### Functional Programming

* **Dartz**

### Local Storage

* **SharedPreferences**

### UI & Responsive Design

* **Flutter ScreenUtil**
* **Google Fonts**
* **Flutter SVG**
* **Carousel Slider**
* **Smooth Page Indicator**
* **Cached Network Image**

### Image Handling

* **Image Picker**

The main dependencies can be found in the project's `pubspec.yaml`.

---

## 📱 Application Flow

### 1. Authentication

```text
Register / Login
       ↓
 Authentication
       ↓
      Home
```

### 2. Product Discovery

```text
Home
  ↓
Products
  ↓
Product Details
```

### 3. Favorites

```text
Product
   ↓
Add to Favorites
   ↓
Favorites
```

### 4. Shopping Cart

```text
Product
   ↓
Add to Cart
   ↓
Cart
   ↓
Change Quantity
```

### 5. Checkout

```text
Cart
 ↓
Review Items
 ↓
Checkout
 ↓
Confirm Order
```

### 6. Order Management

```text
Checkout
   ↓
Create Order
   ↓
Order History
   ↓
Order Details
```

---

## 📸 Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/3ecc277f-57d8-472a-a5a2-488fa5d41894" width="23%" />
  <img src="https://github.com/user-attachments/assets/5be39471-269c-4c55-ac18-922f2ec6f689" width="23%" />
  <img src="https://github.com/user-attachments/assets/c4c829be-2402-4ef3-a14e-381f51f046ee" width="23%" />
  <img src="https://github.com/user-attachments/assets/4d6b96a0-7b8a-4dc9-944a-967426b2663c" width="23%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/e9ea82c7-a9e8-4db6-8f4c-d16f66d17a72" width="23%" />
  <img src="https://github.com/user-attachments/assets/e63c124b-ae0b-40be-8ca3-9eb0382c022c" width="23%" />
  <img src="https://github.com/user-attachments/assets/8ddadc70-6ed4-465c-aac8-15b5db6b402f" width="23%" />
  <img src="https://github.com/user-attachments/assets/82f94502-8f37-4d7c-8b08-84576599d609" width="23%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/3467a570-c5e0-4325-ad29-99e3364d52f6" width="23%" />
  <img src="https://github.com/user-attachments/assets/0e57dbb7-eb52-410a-9268-e7334e2792be" width="23%" />
</p>

---

## 🎨 UI & UX

The application focuses on providing a clean and modern shopping experience through:

* Clean product presentation
* Simple navigation
* Responsive layouts
* Easy access to favorites
* Convenient cart management
* Clear quantity controls
* Straightforward checkout flow
* Consistent typography and styling
* Reusable Flutter widgets

---

## ⚠️ Error & State Handling

Cubit is used to handle different application states, including:

* Initial
* Loading
* Success
* Error

Typical API operation:

```text
Initial
   ↓
Loading
   ↓
Success
```

Or when an operation fails:

```text
Initial
   ↓
Loading
   ↓
Error
```

This allows the UI to respond appropriately to API operations and display suitable feedback to the user.

---

## 📂 Project Structure

The project is organized into Flutter application layers and feature-related components.

```text
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   ├── network/
│   └── ...
│
├── features/
│   ├── authentication/
│   ├── products/
│   ├── favorites/
│   ├── cart/
│   ├── checkout/
│   └── orders/
│
├── widgets/
│
└── main.dart
```

> The exact folder organization may evolve as the application is extended.

---

## 📦 Installation & Setup

### Prerequisites

Make sure you have:

* Flutter SDK
* Dart SDK
* Android Studio or Visual Studio Code
* Android Emulator or a physical Android device
* Git

Check your Flutter installation:

```bash
flutter doctor
```

### Clone the Repository

```bash
git clone <repository-url>
cd e-commerce
```

### Install Dependencies

```bash
flutter pub get
```

### Run the Application

```bash
flutter run
```

---

## 🔧 Backend Configuration

The application communicates with a backend API for the main e-commerce operations.

Before running the complete application:

1. Make sure the backend server is running.
2. Configure the API base URL used by the Flutter application.
3. Make sure the mobile application can reach the backend server.
4. Run the Flutter application.

---

## 🚀 Future Improvements

Possible future enhancements include:

* Advanced product search
* Product filtering and sorting
* Product reviews and ratings
* Multiple payment methods
* Online payment gateway
* Push notifications
* Order status notifications
* Delivery tracking
* Discount codes
* Promotional offers
* Multiple delivery addresses
* Sales analytics

---

## 👩‍💻 Author

**Rawda Mohamed**

Computer Science Graduate | Flutter Developer

---

## ⭐ Project Highlights

This project demonstrates practical experience with:

* Flutter application development
* Cubit state management
* REST API integration
* Backend communication
* Dependency injection
* Local storage
* Responsive UI design
* Reusable widgets
* E-commerce application flow
* Asynchronous programming
* Error and state handling
* Git & GitHub

```


ده في رأيي أنسب من الـ README القديم: شكله Professional، فيه الـ screenshots، ومش محمّل بتفاصيل زيادة مالهاش لازمة.
```
