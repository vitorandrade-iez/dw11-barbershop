import 'dart:convert';

enum UserProfileEnum {
  admin('ADM'),
  employee('EMPLOYEE');

  final String value;
  const UserProfileEnum(this.value);

  static UserProfileEnum parse(String value) {
    return UserProfileEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UserProfileEnum.employee,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final UserProfileEnum profile;
  final List<String>? workDays;
  final List<int>? workHours;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.profile,
    this.workDays,
    this.workHours,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'],
      profile: UserProfileEnum.parse(map['profile']),
      workDays: map['work_days']?.cast<String>(),
      workHours: map['work_hours']?.cast<int>(),
    );
  }

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'profile': profile.value,
      'work_days': workDays,
      'work_hours': workHours,
    };
  }

  String toJson() => jsonEncode(toMap());
}
