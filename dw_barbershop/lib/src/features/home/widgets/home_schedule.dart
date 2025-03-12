import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/features/home/home_controller.dart';
import 'package:dw_barbershop/src/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeSchedule extends ConsumerWidget {
  final ScheduleModel schedule;

  const HomeSchedule({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorsConstants.grey.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Horário em destaque
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorsConstants.brown,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${schedule.time}:00',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Status do agendamento
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorsConstants.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: ColorsConstants.brown),
                    SizedBox(width: 4),
                    Text(
                      'Confirmado',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorsConstants.brown,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Informações do cliente
          Row(
            children: [
              const Icon(Icons.person, color: ColorsConstants.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cliente: ${schedule.clientName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Data formatada
          Row(
            children: [
              const Icon(Icons.calendar_month, color: ColorsConstants.grey),
              const SizedBox(width: 8),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(schedule.date)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorsConstants.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Botões de ação
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botão para adicionar ao Google Calendar
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Integração com Google Calendar em desenvolvimento'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                icon: const Icon(Icons.add_to_drive, size: 18),
                label: const Text('Google'),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              const SizedBox(width: 8),
              // Botão de cancelamento com funcionalidade implementada
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Cancelar Agendamento'),
                        content: Text(
                            'Deseja cancelar o agendamento de ${schedule.clientName}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Não'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              // Chamar a função de cancelamento
                              ref
                                  .read(homeControllerProvider.notifier)
                                  .cancelSchedule(schedule.id);
                            },
                            child: const Text('Sim'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.cancel,
                    color: ColorsConstants.red, size: 18),
                label: const Text('Cancelar',
                    style: TextStyle(color: ColorsConstants.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
