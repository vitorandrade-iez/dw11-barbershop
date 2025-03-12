import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/register/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Substituindo a geração de código por um StateNotifierProvider padrão
// part 'register_controller.g.dart';

final registerControllerProvider =
    StateNotifierProvider<RegisterController, RegisterState>((ref) {
  return RegisterController(ref);
});

class RegisterController extends StateNotifier<RegisterState> {
  final Ref _ref;

  RegisterController(this._ref) : super(RegisterState.initial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(status: RegisterStateStatus.loading);

      final userLoginService = _ref.read(userLoginServiceProvider);
      await userLoginService.register(name, email, password);

      state = state.copyWith(status: RegisterStateStatus.success);
    } on AuthException catch (e) {
      state = state.copyWith(
        status: RegisterStateStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: RegisterStateStatus.error,
        errorMessage: 'Erro ao registrar usuário',
      );
    }
  }
}
