import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/schedule_model.dart';
import 'package:dw_barbershop/src/repositories/schedule/schedule_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final RestClient _restClient;

  ScheduleRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  Future<void> cancelSchedule(int scheduleId) async {
    try {
      await _restClient.delete('/schedules/$scheduleId');
    } on DioException {
      throw RepositoryException(message: 'Erro ao cancelar agendamento');
    }
  }

  @override
  Future<void> createSchedule(ScheduleModel schedule) async {
    try {
      await _restClient.post('/schedules', data: schedule.toMap());
    } on DioException {
      throw RepositoryException(message: 'Erro ao criar agendamento');
    }
  }

  @override
  Future<List<ScheduleModel>> findScheduleByDate(DateTime date) async {
    try {
      // Formatar a data para consulta usando apenas a parte da data, sem a hora
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      debugPrint('Buscando agendamentos para data: $formattedDate');

      final response = await _restClient.get('/schedules', queryParameters: {
        'date': formattedDate,
      });

      // Log para verificar o que está vindo
      debugPrint('Resposta de agendamentos: ${response.data}');

      if (response.data is! List) {
        return [];
      }

      final schedules = response.data
          .map<ScheduleModel>((data) => ScheduleModel.fromMap(data))
          .toList();

      debugPrint('Encontrados ${schedules.length} agendamentos');
      return schedules;
    } on DioException catch (e) {
      debugPrint('Erro ao buscar agendamentos: $e');
      throw RepositoryException(message: 'Erro ao buscar agendamentos');
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      return [];
    }
  }
}
