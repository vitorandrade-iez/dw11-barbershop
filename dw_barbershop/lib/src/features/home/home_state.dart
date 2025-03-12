import 'package:dw_barbershop/src/models/schedule_model.dart';
import 'package:dw_barbershop/src/models/user_model.dart';

enum HomeStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class HomeState {
  final HomeStateStatus status;
  final List<ScheduleModel> schedules;
  final UserModel user;

  HomeState({
    required this.status,
    required this.schedules,
    required this.user,
  });

  HomeState copyWith({
    HomeStateStatus? status,
    List<ScheduleModel>? schedules,
    UserModel? user,
  }) {
    return HomeState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      user: user ?? this.user,
    );
  }
}
