import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../utils/token_manager.dart';

/// HTTP client configuration using Dio with enhanced error handling
class DioClient {
  late final Dio _dio;
  final TokenManager _tokenManager;
  
  DioClient(this._tokenManager) {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
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
          try {
            // Add authorization token to requests
            final token = await _tokenManager.getAccessToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          } catch (e) {
            handler.reject(DioException(
              requestOptions: options,
              error: 'Failed to add authorization token: $e',
            ));
          }
        },
        onResponse: (response, handler) {
          // Log successful responses if needed
          handler.next(response);
        },
        onError: (error, handler) async {
          // Handle different types of errors
          if (error.response?.statusCode == 401) {
            // Token expired or invalid, clear tokens
            await _tokenManager.clearTokens();
            
            // You can also trigger a refresh token attempt here
            // or emit an event to force user to login again
          }
          
          // Transform error into more user-friendly message
          final transformedError = _transformError(error);
          handler.next(transformedError);
        },
      ),
    );
  }
  
  /// Transform DioException into more user-friendly error
  DioException _transformError(DioException error) {
    String message;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Request timeout. Please check your connection and try again.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            message = 'Invalid request. Please check your input.';
            break;
          case 401:
            message = 'Authentication failed. Please login again.';
            break;
          case 403:
            message = 'Access denied. You don\'t have permission.';
            break;
          case 404:
            message = 'Service not found. Please try again later.';
            break;
          case 500:
            message = 'Server error. Please try again later.';
            break;
          default:
            message = 'Request failed. Please try again.';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          message = 'No internet connection. Please check your network.';
        } else {
          message = 'An unexpected error occurred. Please try again.';
        }
        break;
      default:
        message = 'Network error. Please try again.';
    }
    
    return DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      type: error.type,
      error: message,
    );
  }
  
  /// GET request method
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Unexpected error: $e',
      );
    }
  }
  
  /// POST request method with form data
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(
        path, 
        data: FormData.fromMap(data ?? {}),
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Unexpected error: $e',
      );
    }
  }
  
  /// POST request method with JSON data
  Future<Response> postJson(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'Unexpected error: $e',
      );
    }
  }
}