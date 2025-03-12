import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final scheduleControllerProvider =
    StateNotifierProvider<ScheduleController, ScheduleState>((ref) {
  return ScheduleController(ref);
});

class ScheduleController extends StateNotifier<ScheduleState> {
  final Ref _ref;

  ScheduleController(this._ref) : super(ScheduleState.initial());

  Future<void> scheduleClient({
    required int barbershopId,
    required String clientName,
    required DateTime date,
    required int time,
  }) async {
    try {
      state = state.copyWith(status: ScheduleStateStatus.loading);

      final scheduleService = _ref.read(scheduleServiceProvider);
      final userService = _ref.read(userServiceProvider);

      final user = await userService.getLoggedUser();

      await scheduleService.scheduleClient(
        (
          barbershopId: barbershopId,
          date: date,
          time: time,
          userId: user.id,
          clientName: clientName,
        ),
      );

      state = state.copyWith(status: ScheduleStateStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: ScheduleStateStatus.error,
        errorMessage: 'Erro ao agendar cliente',
      );
    }
  }
}
