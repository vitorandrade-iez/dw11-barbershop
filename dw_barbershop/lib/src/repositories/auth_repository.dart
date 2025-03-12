import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final RestClient _restClient;

  AuthRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final result = await _restClient.post('/auth', data: {
        'email': email,
        'password': password,
      });

      return UserModel.fromMap(result.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw AuthException(message: 'Credenciais inválidas');
      }
      throw AuthException(message: 'Erro ao realizar login');
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await _restClient.post('/users', data: {
        'name': name,
        'email': email,
        'password': password,
        'profile': 'EMPLOYEE',
      });
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthException(message: 'Email já utilizado, escolha outro');
      }
      throw AuthException(message: 'Erro ao registrar usuário');
    }
  }
}
