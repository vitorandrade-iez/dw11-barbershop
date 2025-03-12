import 'package:dw_barbershop/src/models/schedule_model.dart';
import 'package:dw_barbershop/src/repositories/schedule/schedule_repository.dart';
import 'package:dw_barbershop/src/services/user/user_service.dart';
import 'package:dw_barbershop/src/services/schedule/schedule_service.dart';

class ScheduleServiceImpl implements ScheduleService {
  final UserService _userService;
  final ScheduleRepository _scheduleRepository;

  ScheduleServiceImpl({
    required UserService userService,
    required ScheduleRepository scheduleRepository,
  })  : _userService = userService,
        _scheduleRepository = scheduleRepository;

  @override
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date) async {
    // Apenas verificamos o usuário sem armazenar em variável
    await _userService.getLoggedUser();
    return await _scheduleRepository.findScheduleByDate(date);
  }

  @override
  Future<void> scheduleClient(
      ({
        int barbershopId,
        DateTime date,
        int time,
        int userId,
        String clientName
      }) scheduleData) async {
    // Apenas verificamos o usuário sem armazenar em variável
    await _userService.getLoggedUser();

    final schedule = ScheduleModel(
      id: 0,
      barbershopId: scheduleData.barbershopId,
      userId: scheduleData.userId,
      clientName: scheduleData.clientName,
      date: scheduleData.date,
      time: scheduleData.time,
    );

    await _scheduleRepository.createSchedule(schedule);
  }
}
