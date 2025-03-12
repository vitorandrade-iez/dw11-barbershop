import 'package:dw_barbershop/src/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUserById(int id);
  Future<List<UserModel>> getEmployees(int barbershopId);
  Future<void> registerAdminAsEmployee(int userId, int barbershopId);
}
