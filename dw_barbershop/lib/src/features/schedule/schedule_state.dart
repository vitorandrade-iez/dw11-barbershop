enum ScheduleStateStatus {
  initial,
  loading,
  success,
  error,
}

class ScheduleState {
  final ScheduleStateStatus status;
  final String? errorMessage;

  ScheduleState({
    required this.status,
    this.errorMessage,
  });

  ScheduleState.initial() : this(status: ScheduleStateStatus.initial);

  ScheduleState copyWith({
    ScheduleStateStatus? status,
    String? errorMessage,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
