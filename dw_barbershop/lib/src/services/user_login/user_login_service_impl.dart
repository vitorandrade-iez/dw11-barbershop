import 'package:dw_barbershop/src/models/user_model.dart';
import 'package:dw_barbershop/src/repositories/auth/auth_repository.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service.dart';
import 'package:dw_barbershop/src/services/user/user_service.dart';

class UserLoginServiceImpl implements UserLoginService {
  final AuthRepository _authRepository;
  final UserService _userService;

  UserLoginServiceImpl({
    required AuthRepository authRepository,
    required UserService userService,
  })  : _authRepository = authRepository,
        _userService = userService;

  @override
  Future<UserModel> login(String email, String password) async {
    final userModel = await _authRepository.login(email, password);
    await _userService.saveUser(userModel);
    return userModel;
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    await _authRepository.register(name, email, password);
    final userModel = await _authRepository.login(email, password);
    await _userService.saveUser(userModel);
    return userModel;
  }
}
