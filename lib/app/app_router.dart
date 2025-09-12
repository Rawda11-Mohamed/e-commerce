import 'package:flutter/material.dart';

// Auth Screens
import 'package:stylish_app/features/auth/presentation/screens/get_started_screen.dart';
import 'package:stylish_app/features/auth/presentation/screens/login_screen.dart';
import 'package:stylish_app/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:stylish_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:stylish_app/features/auth/presentation/screens/splash_screen.dart';

// Cart Screens
import 'package:stylish_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:stylish_app/features/cart/presentation/screens/checkout_screen.dart';

// Main Layout
import 'package:stylish_app/features/main_layout/presentation/main_layout_screen.dart';

// Orders Screens
import 'package:stylish_app/features/orders/presentation/screens/my_orders_screen.dart';
import 'package:stylish_app/features/orders/presentation/screens/order_details_screen.dart';
import 'package:stylish_app/features/orders/data/models/order_model.dart';

// Products Screens
import 'package:stylish_app/features/products/presentation/screens/my_favorites_screen.dart';
import 'package:stylish_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:stylish_app/features/products/presentation/screens/search_screen.dart';

// Profile Screens
import 'package:stylish_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:stylish_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:stylish_app/features/profile/presentation/screens/settings_screen.dart';

class AppRouter {
  // ================== Route Constants ==================
  static const String splashRoute = '/splash';
  static const String onboardingRoute = '/onboarding';
  static const String getStartedRoute = '/getStarted';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String mainLayoutRoute = '/mainLayout';
  static const String productDetailsRoute = '/productDetails';
  static const String searchRoute = '/search';
  static const String cartRoute = '/cart';
  static const String checkoutRoute = '/checkout';
  static const String myOrdersRoute = '/myOrders';
  static const String orderDetailsRoute = '/orderDetails';
  static const String myFavoritesRoute = '/myFavorites';
  static const String editProfileRoute = '/editProfile';
  static const String settingsRoute = '/settings';
  static const String profileRoute = '/profile';

  // ================== Route Generator ==================
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // ---------------- Auth ----------------
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case getStartedRoute:
        return MaterialPageRoute(builder: (_) => const GetStartedScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signupRoute:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

    // ---------------- Main Layout ----------------
      case mainLayoutRoute:
        return MaterialPageRoute(builder: (_) => const MainLayoutScreen());

    // ---------------- Products ----------------
      case productDetailsRoute:
        final productId = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(productId: productId),
        );
      case searchRoute:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case myFavoritesRoute:
        return MaterialPageRoute(builder: (_) => const MyFavoritesScreen());

    // ---------------- Cart ----------------
      case cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkoutRoute:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

    // ---------------- Orders ----------------
      case myOrdersRoute:
        return MaterialPageRoute(builder: (_) => const MyOrdersScreen());
      case orderDetailsRoute:
        final args = settings.arguments;
        if (args is OrderModel) {
          return MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(order: args),
          );
        }
        final orderId = args is int ? args : null;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(orderId: orderId),
        );

    // ---------------- Profile ----------------
      case editProfileRoute:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

    // ---------------- Default ----------------
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}