import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const HomeCalendar(
      {super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsConstants.brown.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione uma data:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildWeekDays(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekDays() {
    final dateFormat = DateFormat('dd');
    final dayFormat = DateFormat('E');
    final today = DateTime.now();
    final widgets = <Widget>[];

    // Mostra 14 dias a partir de hoje
    for (int i = -3; i < 11; i++) {
      final date = DateTime.now().add(Duration(days: i));
      final isSelected = DateUtils.isSameDay(date, selectedDate);
      final isToday = DateUtils.isSameDay(date, today);

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => onDateChanged(date),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? ColorsConstants.brown : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isToday ? ColorsConstants.brown : Colors.grey[300]!,
                  width: isToday ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    dayFormat.format(date)[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(date),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
