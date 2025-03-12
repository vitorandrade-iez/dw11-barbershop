import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});

class HomeController extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    debugPrint('HomeController build');
    final userService = ref.read(userServiceProvider);
    try {
      final user = await userService.getLoggedUser();
      debugPrint(
          'Usuário obtido: ${user.name}, id: ${user.id}, profile: ${user.profile.value}');

      return HomeState(
        status: HomeStateStatus.initial,
        schedules: const [],
        user: user,
      );
    } catch (e, s) {
      debugPrint('Erro ao obter usuário: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<void> loadData([DateTime? date]) async {
    final selectedDate = date ?? DateTime.now();
    debugPrint(
        'HomeController loadData para ${selectedDate.toIso8601String()}');
    state = const AsyncValue.loading();

    try {
      final scheduleService = ref.read(scheduleServiceProvider);
      debugPrint('Buscando agendamentos para a data selecionada');
      final schedules = await scheduleService.getSchedulesByDate(selectedDate);
      debugPrint('Agendamentos encontrados: ${schedules.length}');

      final userService = ref.read(userServiceProvider);
      final user = await userService.getLoggedUser();
      debugPrint('Usuário carregado: ${user.name}');

      state = AsyncValue.data(HomeState(
        status: HomeStateStatus.loaded,
        schedules: schedules,
        user: user,
      ));
    } catch (e, s) {
      debugPrint('Erro no loadData: $e');
      debugPrintStack(stackTrace: s);
      state = AsyncValue.error(e, s);
    }
  }

  // Adicionar método para cancelar agendamento
  Future<void> cancelSchedule(int scheduleId) async {
    try {
      // Mostrar um estado de carregamento
      state = AsyncValue.data(state.value!.copyWith(
        status: HomeStateStatus.loading,
      ));

      // Obter o repositório e cancelar o agendamento
      final scheduleRepository = ref.read(scheduleRepositoryProvider);
      await scheduleRepository.cancelSchedule(scheduleId);

      // Recarregar os dados após o cancelamento
      loadData(state.value!.schedules.isNotEmpty
          ? state.value!.schedules.first.date
          : DateTime.now());
    } catch (e, s) {
      debugPrint('Erro ao cancelar agendamento: $e');
      debugPrintStack(stackTrace: s);

      // Mostrar erro
      state = AsyncValue.error(e, s);
    }
  }
}
