import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/repositories/auth/auth_repository.dart';
import 'package:dw_barbershop/src/repositories/auth/auth_repository_impl.dart';
import 'package:dw_barbershop/src/repositories/barbershop/barbershop_repository.dart';
import 'package:dw_barbershop/src/repositories/barbershop/barbershop_repository_impl.dart';
import 'package:dw_barbershop/src/repositories/schedule/schedule_repository.dart';
import 'package:dw_barbershop/src/repositories/schedule/schedule_repository_impl.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository_impl.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service_impl.dart';
import 'package:dw_barbershop/src/services/user/user_service.dart';
import 'package:dw_barbershop/src/services/user/user_service_impl.dart';
import 'package:dw_barbershop/src/services/schedule/schedule_service.dart';
import 'package:dw_barbershop/src/services/schedule/schedule_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Client REST
final restClientProvider = Provider<RestClient>((ref) {
  return RestClient();
});

// Shared Preferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Needs to be overridden in main.dart');
});

// Repositories
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final restClient = ref.read(restClientProvider);
  return AuthRepositoryImpl(restClient: restClient);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final restClient = ref.read(restClientProvider);
  return UserRepositoryImpl(restClient: restClient);
});

final barbershopRepositoryProvider = Provider<BarbershopRepository>((ref) {
  final restClient = ref.read(restClientProvider);
  return BarbershopRepositoryImpl(restClient: restClient);
});

final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  final restClient = ref.read(restClientProvider);
  return ScheduleRepositoryImpl(restClient: restClient);
});

// Services
final userServiceProvider = Provider<UserService>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  final sp = ref.read(sharedPreferencesProvider);
  return UserServiceImpl(
    userRepository: userRepository,
    sharedPreferences: sp,
  );
});

final scheduleServiceProvider = Provider<ScheduleService>((ref) {
  final scheduleRepository = ref.read(scheduleRepositoryProvider);
  final userService = ref.read(userServiceProvider);
  return ScheduleServiceImpl(
    userService: userService,
    scheduleRepository: scheduleRepository,
  );
});

final userLoginServiceProvider = Provider<UserLoginService>((ref) {
  final userService = ref.read(userServiceProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return UserLoginServiceImpl(
    userService: userService,
    authRepository: authRepository,
  );
});
