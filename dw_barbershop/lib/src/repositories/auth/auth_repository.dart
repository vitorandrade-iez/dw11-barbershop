import 'package:dw_barbershop/src/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> register(String name, String email, String password);
}
