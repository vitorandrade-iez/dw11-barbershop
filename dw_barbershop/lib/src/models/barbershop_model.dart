import 'dart:convert';

class BarbershopModel {
  final int id;
  final String name;
  final String email;
  final List<String> openingDays;
  final List<int> openingHours;

  BarbershopModel({
    required this.id,
    required this.name,
    required this.email,
    required this.openingDays,
    required this.openingHours,
  });

  factory BarbershopModel.fromMap(Map<String, dynamic> map) {
    return BarbershopModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      openingDays: List<String>.from(map['opening_days']),
      openingHours: List<int>.from(map['opening_hours']),
    );
  }

  factory BarbershopModel.fromJson(String source) =>
      BarbershopModel.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'opening_days': openingDays,
      'opening_hours': openingHours,
    };
  }

  String toJson() => jsonEncode(toMap());
}
