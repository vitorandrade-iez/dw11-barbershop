import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/barbershop_model.dart';

abstract class BarbershopRepository {
  Future<BarbershopModel> getById(int id);
  Future<List<BarbershopModel>> getAll();
  Future<BarbershopModel> save(BarbershopModel barbershop);
}

class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient _restClient;

  BarbershopRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<List<BarbershopModel>> getAll() async {
    try {
      final response = await _restClient.get('/barbershop');
      return response.data
          .map<BarbershopModel>((data) => BarbershopModel.fromMap(data))
          .toList();
    } on DioException {
      throw RepositoryException(message: 'Erro ao buscar barbearias');
    }
  }

  @override
  Future<BarbershopModel> getById(int id) async {
    try {
      final response = await _restClient.get('/barbershop/$id');
      return BarbershopModel.fromMap(response.data);
    } on DioException {
      throw RepositoryException(message: 'Erro ao buscar barbearia');
    }
  }

  @override
  Future<BarbershopModel> save(BarbershopModel barbershop) async {
    try {
      final response =
          await _restClient.post('/barbershop', data: barbershop.toMap());
      return BarbershopModel.fromMap(response.data);
    } on DioException {
      throw RepositoryException(message: 'Erro ao salvar barbearia');
    }
  }
}
