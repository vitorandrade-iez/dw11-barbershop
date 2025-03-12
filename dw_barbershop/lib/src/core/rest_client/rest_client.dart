import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client_config.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestClient {
  late final Dio _dio;
  String? _accessToken;

  RestClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: RestClientConfig.baseUrl,
        connectTimeout: RestClientConfig.connectTimeout,
        receiveTimeout: RestClientConfig.receiveTimeout,
        // Permitir que códigos de status 404 não lancem exceções durante o teste de conexão
        validateStatus: (status) => status! < 500,
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );

    // Restaurar token automaticamente ao inicializar
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final token = sp.getString(LocalStorageKeys.accessToken);
      if (token != null) {
        addAuthHeader(token);
      }
    } catch (e) {
      debugPrint('Erro ao inicializar autenticação: $e');
    }
  }

  void addAuthHeader(String token) {
    _accessToken = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    debugPrint(
        'Token adicionado aos headers: Bearer ${token.substring(0, 10)}...');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      debugPrint('Erro na requisição GET: ${e.message}');
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      debugPrint('Erro na requisição POST: ${e.message}');
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      debugPrint('Erro na requisição PUT: ${e.message}');
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      debugPrint('Erro na requisição DELETE: ${e.message}');
      rethrow;
    }
  }
}
