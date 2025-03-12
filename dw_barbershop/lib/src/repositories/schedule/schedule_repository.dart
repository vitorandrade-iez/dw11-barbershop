import 'package:dw_barbershop/src/models/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleModel>> findScheduleByDate(DateTime date);
  Future<void> createSchedule(ScheduleModel schedule);
  Future<void> cancelSchedule(int scheduleId);
}
