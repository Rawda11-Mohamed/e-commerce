abstract class EndPoints {
  //auth endpoints
  static const String ecoBaseUrl ='https://nti-ecommerce-api-production-9b13.up.railway.app/api/';
  static const String login = 'login';
  static const String register = 'register';
  static const String getUserData = 'get_user_data';
  static const String getMenu = 'categories';
  static const String refreshToken = 'refresh_token';


  // Orders Endpoints
  static const String placeOrder = 'place_order';
  static const String cancelOrder = 'orders/cancel/1';
  static const String completeOrder = 'orders/complete/3';
  static const String getOrders = 'orders';

  // Products Endpoints
  static const String newProduct = 'new_product';
  static const String addToFavorite = 'add_to_favorite';
  static const String editProduct = 'product/3';
  static const String deleteProduct = 'product/3';
  static const String getProducts = 'products';
  static const String searchProducts = 'products/search';
  static const String bestSellerProducts = 'best_seller_products';
  static const String topRatedProducts = 'top_rated_products';

  // Profile endpoints
  static const String updateProfile = 'update_profile';

  // Favorites endpoints
  static const String addToFavorites = 'add_to_favorite';
  //categories endpoints
static const String getCategories = 'categories';
static const String newCategory = 'new_category';
static const String editCategory = 'category/2';
static const String deleteCategory = 'category/1';
//sliders endpoints
static const String getSliders = 'sliders';
static const String newSlider = 'new_slider';
static const String editSlider = 'slider/2';
static const String deleteSlider = 'slider/1';
}
