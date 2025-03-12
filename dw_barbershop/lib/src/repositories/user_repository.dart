import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(int id);
  Future<List<UserModel>> getEmployees(int barbershopId);
  Future<void> registerAdminAsEmployee(int userId, int barbershopId);
}

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;

  UserRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<List<UserModel>> getEmployees(int barbershopId) async {
    try {
      final response = await _restClient.get('/users', queryParameters: {
        'barbershop_id': barbershopId,
      });

      return response.data
          .map<UserModel>((userData) => UserModel.fromMap(userData))
          .toList();
    } on DioException {
      throw RepositoryException(message: 'Erro ao buscar colaboradores');
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await _restClient.get('/users/$id');
      return UserModel.fromMap(response.data);
    } on DioException {
      throw RepositoryException(message: 'Erro ao buscar usuário');
    }
  }

  @override
  Future<void> registerAdminAsEmployee(int userId, int barbershopId) async {
    try {
      await _restClient.put('/users/$userId', data: {
        'barbershop_id': barbershopId,
      });
    } on DioException {
      throw RepositoryException(
        message: 'Erro ao registrar usuário como colaborador',
      );
    }
  }
}
