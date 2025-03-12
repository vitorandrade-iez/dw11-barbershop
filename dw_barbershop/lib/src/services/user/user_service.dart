import 'package:dw_barbershop/src/models/user_model.dart';

abstract class UserService {
  Future<UserModel> getLoggedUser();
  Future<void> logout();
  Future<void> saveUser(UserModel user);
}
