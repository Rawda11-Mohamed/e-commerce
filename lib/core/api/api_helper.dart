import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_response.dart';
import 'end_points.dart';

class ApiHelper {
  // singleton
  static final ApiHelper _instance = ApiHelper._init();
  factory ApiHelper() {
    _instance.initDio();
    return _instance;
  }
  ApiHelper._init();

  Dio dio = Dio(BaseOptions(
    baseUrl: EndPoints.ecoBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  void initDio() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("--- Headers : ${options.headers.toString()}");
        print("--- endpoint : ${options.path.toString()}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print("--- Response : ${response.data.toString()}");
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print("--- Error : ${error.response?.data.toString()}");

        String? message;
        if (error.response?.data is Map) {
          message = error.response?.data?['message']?.toString();
        }
        if (message != null && message.contains('expired')) {
          // refresh token
          try {
            ApiResponse apiResponse = await _instance.postRequest(
              endPoint: EndPoints.refreshToken,
              sendRefreshToken: true,
              isProtected: true,
            );
            if (apiResponse.status) {
              var sharedPref = await SharedPreferences.getInstance();
              // must update token
              await sharedPref.setString(
                  'access_token', apiResponse.data['access_token']);

              // Retry original request
              final options = error.requestOptions;
              if (options.data is FormData) {
                final oldFormData = options.data as FormData;
                final Map<String, dynamic> formMap = {};
                for (var entry in oldFormData.fields) {
                  formMap[entry.key] = entry.value;
                }
                for (var file in oldFormData.files) {
                  formMap[file.key] = file.value;
                }
                options.data = FormData.fromMap(formMap);
              }
              options.headers['Authorization'] =
              'Bearer ${sharedPref.getString('access_token') ?? ''}';
              final response = await dio.fetch(options);
              return handler.resolve(response);
            } else {
              // must logout
              SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
              sharedPreferences.remove('access_token');
              sharedPreferences.remove('refresh_token');
              return handler.next(error);
            }
          } catch (e) {
            SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
            sharedPreferences.remove('access_token');
            sharedPreferences.remove('refresh_token');
            return handler.next(error);
          }
        }

        return handler.next(error);
      },
    ));
  }

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref
          .getString(sendRefreshToken ? 'refresh_token' : 'access_token');
    }
    return ApiResponse.fromResponse(await dio.post(
      endPoint,
      data: isFormData ? FormData.fromMap(data ?? {}) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
      }),
    ));
  }

  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = true,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref
          .getString(sendRefreshToken ? 'refresh_token' : 'access_token');
    }
    return ApiResponse.fromResponse(await dio.get(
      endPoint,
      queryParameters: queryParameters,
      //data: isFormData ? FormData.fromMap(data ?? {}) : data,
      options: Options(headers: {
        if (isProtected) 'Authorization': 'Bearer $token',
      }),
    ));
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isProtected = false,
    bool sendRefreshToken = false,
  }) async {
    var token;
    if (isProtected) {
      var sharedPref = await SharedPreferences.getInstance();
      token = sharedPref
          .getString(sendRefreshToken ? 'refresh_token' : 'access_token');
    }
    try {
      Response response = await dio.put(
        endPoint,
        data: data,
        options: Options(headers: {
          if (isProtected) 'Authorization': 'Bearer $token',
        }),
      );
      return ApiResponse.fromResponse(response);
    } catch (error) {
      return ApiResponse.fromError(error);
    }
  }
}
