import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/models/user_model.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/services/user/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final SharedPreferences _sharedPreferences;

  UserServiceImpl({
    required UserRepository userRepository,
    required SharedPreferences sharedPreferences,
  })  : _userRepository = userRepository,
        _sharedPreferences = sharedPreferences;

  @override
  Future<UserModel> getLoggedUser() async {
    final userId = _sharedPreferences.getInt(LocalStorageKeys.userId);

    if (userId == null) {
      throw AuthException(message: 'Usuário não encontrado');
    }

    debugPrint('Buscando usuário com ID: $userId');
    return await _userRepository.getUserById(userId);
  }

  @override
  Future<void> logout() async {
    await _sharedPreferences.clear();
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await _sharedPreferences.setInt(LocalStorageKeys.userId, user.id);
    debugPrint(
        'Usuário salvo com ID: ${user.id} e perfil: ${user.profile.value}');
  }
}
