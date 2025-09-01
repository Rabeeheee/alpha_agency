import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/token_manager.dart';

/// HTTP client configuration using Dio
class DioClient {
  late final Dio _dio;
  final TokenManager _tokenManager;
  
  DioClient(this._tokenManager) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  /// Configure request and response interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token to requests
          final token = await _tokenManager.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          // Handle token expiration and refresh
          if (error.response?.statusCode == 401) {
            // Token expired, trigger refresh
            _tokenManager.clearTokens();
          }
          handler.next(error);
        },
      ),
    );
  }
  
  /// GET request method
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
  
  /// POST request method with form data
  Future<Response> post(String path, {Map<String, dynamic>? data}) {
    return _dio.post(
      path, 
      data: FormData.fromMap(data ?? {}),
      options: Options(contentType: 'multipart/form-data'),
    );
  }
  
  /// POST request method with JSON data
  Future<Response> postJson(String path, {Map<String, dynamic>? data}) {
    return _dio.post(path, data: data);
  }
}