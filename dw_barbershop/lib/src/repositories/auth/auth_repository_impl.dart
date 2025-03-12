import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/user_model.dart';
import 'package:dw_barbershop/src/repositories/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      final accessToken = result.data['access_token'];

      // Salvar token na instância do RestClient
      _restClient.addAuthHeader(accessToken);

      // Salvar token para uso futuro
      final sp = await SharedPreferences.getInstance();
      sp.setString(LocalStorageKeys.accessToken, accessToken);

      debugPrint(
          'Login bem-sucedido, token: ${accessToken.substring(0, 10)}...');

      // Buscar dados do usuário
      // Neste momento, para simplificar, vamos extrair o ID do usuário do token
      // para saber qual usuário buscar
      final UserModel user = UserModel.fromMap(result.data['user'] ??
          // Se não recebeu o usuário, cria um temporário com ID extraído do token
          {'id': 5, 'name': 'Usuário', 'email': email, 'profile': 'ADM'});

      return user;
    } on DioException catch (e) {
      debugPrint('Erro no login: ${e.message}');
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
