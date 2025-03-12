import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/loader.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_controller.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:validatorless/validatorless.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  final formKey = GlobalKey<FormState>();
  final clientEC = TextEditingController();
  final dateEC = TextEditingController();
  final hourEC = TextEditingController();

  // Para armazenar a data selecionada
  DateTime? _selectedDate;
  int _selectedHour = 0;

  @override
  void dispose() {
    clientEC.dispose();
    dateEC.dispose();
    hourEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleController = ref.watch(scheduleControllerProvider);

    ref.listen(scheduleControllerProvider, (_, state) {
      switch (state.status) {
        case ScheduleStateStatus.initial:
          break;
        case ScheduleStateStatus.loading:
          context.showLoader();
          break;
        case ScheduleStateStatus.success:
          context.hideLoader();
          // Retornar a data selecionada para a tela anterior
          Navigator.of(context).pop(_selectedDate);
          break;
        case ScheduleStateStatus.error:
          context.hideLoader();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao agendar cliente'),
              backgroundColor: ColorsConstants.red,
            ),
          );
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Cliente'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: clientEC,
                    decoration: const InputDecoration(
                      label: Text('Cliente'),
                    ),
                    validator: Validatorless.required('Cliente é obrigatório'),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: dateEC,
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text('Data'),
                      hintText: 'Selecione uma data',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: Validatorless.required('Data é obrigatória'),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );

                      if (date != null) {
                        _selectedDate = date;
                        dateEC.text = DateFormat('dd/MM/yyyy').format(date);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: hourEC,
                    readOnly: true,
                    decoration: const InputDecoration(
                      label: Text('Hora'),
                      hintText: 'Selecione um horário',
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    validator: Validatorless.required('Hora é obrigatória'),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (time != null) {
                        _selectedHour = time.hour;
                        hourEC.text =
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                    ),
                    onPressed: () {
                      final valid = formKey.currentState?.validate() ?? false;

                      if (valid) {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecione uma data válida'),
                              backgroundColor: ColorsConstants.red,
                            ),
                          );
                          return;
                        }

                        ref
                            .read(scheduleControllerProvider.notifier)
                            .scheduleClient(
                              clientName: clientEC.text,
                              date: _selectedDate!,
                              time: _selectedHour,
                              // Por padrão, usamos o ID 2 da barbearia no banco de dados
                              barbershopId: 2,
                            );
                      }
                    },
                    child: const Text('AGENDAR'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
