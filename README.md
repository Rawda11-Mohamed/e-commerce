# Fashion E-Commerce App

A modern fashion e-commerce mobile application built with Flutter and Dart.

The application provides a complete shopping experience, allowing users to browse fashion products, manage their accounts, add products to favorites and cart, control product quantities, complete the checkout process, and manage their orders.

The project also integrates with a backend to handle authentication, product data, favorites, cart operations, checkout, and order management.

## Project Overview

The Fashion E-Commerce App is designed to provide users with a smooth and convenient online shopping experience focused on fashion products.

The application combines a modern Flutter user interface with Cubit state management, authentication, backend integration, and complete shopping functionality.

The main shopping flow is:

```text
Authentication
      ↓
Home
      ↓
Products
      ↓
Product Details
      ↓
Favorites / Cart
      ↓
Quantity Management
      ↓
Checkout
      ↓
Order
      ↓
Order Management
```

## Features

### 🔐 Authentication

The application provides user authentication functionality, allowing users to securely access their accounts.

Authentication includes:

* User registration
* User login
* User logout
* Authentication state handling
* Backend authentication integration

### 🛍️ Product Browsing

Users can browse available fashion products through an organized and visually appealing interface.

Products are displayed with relevant information such as:

* Product image
* Product name
* Product price
* Product details

Product data is retrieved through the backend integration.

### 📦 Product Details

Users can select a product to view its detailed information before adding it to their favorites or shopping cart.

The product details screen provides a focused view of the selected fashion item and its available information.

### ❤️ Favorites

Users can save products they are interested in for quick access later.

The favorites functionality allows users to:

* Add products to favorites
* Remove products from favorites
* View favorite products
* Manage their favorite items

Favorites are integrated with the backend so that user-specific favorite data can be maintained.

### 🛒 Shopping Cart

The application provides a complete shopping cart experience.

Users can:

* Add products to the cart
* Remove products from the cart
* View selected products
* View product prices
* View the cart total
* Continue to checkout

### 🔢 Product Quantity Management

Users can control the quantity of each product in the shopping cart.

They can:

* Increase product quantity
* Decrease product quantity
* Remove products from the cart
* Update the total price based on quantity

The cart dynamically reflects quantity changes and recalculates the order total.

### 💳 Checkout

The application provides a complete checkout flow that allows users to review their selected products and complete their orders.

The checkout process includes:

* Reviewing cart items
* Reviewing product quantities
* Calculating the total amount
* Confirming the order
* Creating the order through the backend

### 📋 Order Management

After completing checkout, users can manage and review their orders.

The order management functionality allows users to:

* Create orders
* View previous orders
* View order information
* View order details


### 🔗 Backend Integration

The Flutter application is integrated with a backend service to handle application data and e-commerce operations.

The Flutter application communicates with the backend through API requests and handles the returned data using appropriate application states.

## State Management

The application uses **Cubit** from the Flutter BLoC package for state management.

Cubit is used to separate business logic from the UI and manage the state of different application features.

The application uses Cubit for different parts of the e-commerce flow, such as:

* Authentication
* Products
* Favorites
* Cart
* Checkout
* Orders

This approach keeps the application organized and makes the code easier to maintain and extend.

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

The UI listens to Cubit state changes and rebuilds the required widgets when the state changes.

## Application Architecture

The application follows a structured architecture that separates the presentation layer, business logic, and data handling.

A simplified architecture can be represented as:

```text
┌──────────────────────────┐
│      Flutter UI          │
│    Screens & Widgets     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│          Cubit           │
│ State & Business Logic   │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│       Data Layer         │
│    API / Services        │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│         Backend          │
│ Users / Products / Orders│
└──────────────────────────┘
```

This separation helps keep business logic outside the UI and makes individual features easier to maintain and extend.

## Technologies Used

### Frontend

* Flutter
* Dart
* Material Design

### State Management

* Flutter BLoC
* Cubit

### Backend Integration

* REST API
* HTTP communication
* JSON data handling

### Development Tools

* Android Studio
* Visual Studio Code
* Git
* GitHub

## Flutter Concepts Applied

The project applies several important Flutter concepts, including:

* Stateless Widgets
* Stateful Widgets
* Custom Widgets
* Widget composition
* Rows and Columns
* Containers
* ListView
* GridView
* Screen navigation
* Forms and validation
* User interaction
* Asset management
* Theme and styling
* Responsive UI
* Cubit state management
* API integration
* JSON parsing
* Asynchronous programming
* Separation of UI and business logic



## Application Flow

### 1. Authentication

The user starts by creating an account or logging into an existing account.

```text
Register / Login
       ↓
Authentication
       ↓
     Home
```

### 2. Product Discovery

After authentication, users can browse the available fashion products.

```text
Home
 ↓
Products
 ↓
Product Details
```

### 3. Favorites

Users can save products they are interested in.

```text
Product
   ↓
Add to Favorites
   ↓
Favorites
```

### 4. Cart

Users can add products to their shopping cart and manage quantities.

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

After reviewing the cart, users can proceed to checkout.

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

After placing an order, users can access their order information.

```text
Checkout
   ↓
Create Order
   ↓
Order History
   ↓
Order Details
```

## Screenshots

The following screenshots demonstrate the application's interface and different parts of the fashion shopping experience.

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


## Installation & Setup

### Prerequisites

Make sure you have the following installed:

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
```

Navigate to the project:

```bash
cd shop
```

### Install Dependencies

Run:

```bash
flutter pub get
```

### Run the Application

Connect an Android device or start an emulator, then run:

```bash
flutter run
```

## Backend Configuration

The application requires a backend API for features such as authentication, products, favorites, cart operations, checkout, and order management.

Make sure the backend server is running and that the application's API configuration points to the correct backend URL.



## Error & State Handling

Cubit is used to manage different application states, including:

* Initial state
* Loading state
* Success state
* Error state

A typical API operation can follow this flow:

```text
Initial
   ↓
Loading
   ↓
Success
```

or:

```text
Initial
   ↓
Loading
   ↓
Error
```

This allows the application to provide appropriate feedback while backend operations are being performed.

## User Experience

The application focuses on providing a smooth and convenient fashion shopping experience.

The main UX principles include:

* Clean product presentation
* Simple navigation
* Easy access to favorites
* Convenient cart management
* Clear quantity controls
* Straightforward checkout
* Easy access to previous orders
* Responsive and modern UI

## Future Improvements

Although the application already includes the core e-commerce workflow, it can be extended with additional features such as:

* Advanced product filtering
* Product sorting
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

