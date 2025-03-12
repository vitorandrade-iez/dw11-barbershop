enum RegisterStateStatus {
  initial,
  loading,
  success,
  error,
}

class RegisterState {
  final RegisterStateStatus status;
  final String? errorMessage;

  RegisterState({required this.status, this.errorMessage});

  RegisterState.initial() : this(status: RegisterStateStatus.initial);

  RegisterState copyWith({
    RegisterStateStatus? status,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
