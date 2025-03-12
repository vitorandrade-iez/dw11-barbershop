import 'package:dw_barbershop/src/models/schedule_model.dart';

abstract class ScheduleService {
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date);
  Future<void> scheduleClient(
      ({
        int barbershopId,
        DateTime date,
        int time,
        int userId,
        String clientName
      }) scheduleData);
}
