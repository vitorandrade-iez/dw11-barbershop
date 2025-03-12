import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Temporariamente removendo a geração de código
// part 'login_controller.g.dart';

// Convertendo para um StateNotifier comum em vez do @riverpod
final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});

class LoginController extends StateNotifier<LoginState> {
  final Ref _ref;

  LoginController(this._ref) : super(LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(status: LoginStateStatus.loading);

      final userLoginService = _ref.read(userLoginServiceProvider);
      await userLoginService.login(email, password);

      state = state.copyWith(status: LoginStateStatus.success);
    } on AuthException catch (e) {
      state = state.copyWith(
        status: LoginStateStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: LoginStateStatus.error,
        errorMessage: 'Erro ao realizar login',
      );
    }
  }
}
