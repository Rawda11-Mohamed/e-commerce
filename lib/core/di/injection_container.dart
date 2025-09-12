import 'package:get_it/get_it.dart';
import 'package:stylish_app/core/api/api_helper.dart';
import 'package:stylish_app/features/auth/data/repos/auth_repo.dart';
import 'package:stylish_app/features/auth/cubit/login/login_cubit.dart';
import 'package:stylish_app/features/products/data/repos/products_repo.dart';
import 'package:stylish_app/features/orders/data/repos/orders_repo.dart';
import 'package:stylish_app/features/profile/data/repos/profile_repo.dart';
import 'package:stylish_app/features/home/cubit/home_cubit.dart';
import 'package:stylish_app/features/products/cubit/product_details_cubit.dart';
import 'package:stylish_app/features/cart/cubit/cart_cubit.dart';
import 'package:stylish_app/features/orders/cubit/orders_cubit.dart';
import 'package:stylish_app/features/auth/cubit/signup/signup_cubit.dart';
import 'package:stylish_app/features/profile/cubit/profile_cubit.dart';
import 'package:stylish_app/features/settings/cubit/language_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Singletons
  getIt.registerLazySingleton<ApiHelper>(() => ApiHelper());

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(apiHelper: getIt()));
  getIt.registerLazySingleton<ProductsRepo>(() => ProductsRepo(apiHelper: getIt()));
  getIt.registerLazySingleton<OrdersRepo>(() => OrdersRepo(apiHelper: getIt()));
  getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(apiHelper: getIt()));

  // Cubits
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => HomeCubit(getIt()));
  getIt.registerFactory(() => ProductDetailsCubit(getIt()));
  getIt.registerFactory(() => CartCubit());
  getIt.registerFactory(() => OrdersCubit(getIt(), 0));
  getIt.registerFactory(() => ProfileCubit(getIt()));
  getIt.registerFactory(() => SignupCubit(getIt()));
  getIt.registerFactory(() => LanguageCubit());
}