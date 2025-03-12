import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/models/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleModel>> findScheduleByDate(DateTime date);
  Future<void> createSchedule(ScheduleModel schedule);
  Future<void> cancelSchedule(int scheduleId);
}

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
      final response = await _restClient.get('/schedules', queryParameters: {
        'date': date.toIso8601String(),
      });

      return response.data
          .map<ScheduleModel>((data) => ScheduleModel.fromMap(data))
          .toList();
    } on DioException {
      throw RepositoryException(message: 'Erro ao buscar agendamentos');
    }
  }
}
