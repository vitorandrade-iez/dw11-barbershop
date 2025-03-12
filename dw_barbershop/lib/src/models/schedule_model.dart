import 'dart:convert';

class ScheduleModel {
  final int id;
  final int barbershopId;
  final int userId;
  final String clientName;
  final DateTime date;
  final int time;

  ScheduleModel({
    required this.id,
    required this.barbershopId,
    required this.userId,
    required this.clientName,
    required this.date,
    required this.time,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id']?.toInt() ?? 0,
      barbershopId: map['barbershop_id']?.toInt() ?? 0,
      userId: map['user_id']?.toInt() ?? 0,
      clientName: map['client_name'] ?? '',
      date: DateTime.parse(map['date']),
      time: map['time']?.toInt() ?? 0,
    );
  }

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barbershop_id': barbershopId,
      'user_id': userId,
      'client_name': clientName,
      'date': date.toIso8601String(),
      'time': time,
    };
  }

  String toJson() => jsonEncode(toMap());
}
