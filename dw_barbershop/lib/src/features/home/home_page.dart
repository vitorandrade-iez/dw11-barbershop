import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/loader.dart';
import 'package:dw_barbershop/src/features/home/home_controller.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_calendar.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_header.dart';
import 'package:dw_barbershop/src/features/home/widgets/home_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Data selecionada para visualização
  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    debugPrint('HomePage iniciada');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSchedules();
    });
  }

  // Carrega agendamentos para a data selecionada
  Future<void> _loadSchedules() async {
    debugPrint(
        'Carregando dados da HomePage para ${dateFormat.format(selectedDate)}');
    ref.read(homeControllerProvider.notifier).loadData(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Build da HomePage');
    final homeController = ref.watch(homeControllerProvider);

    // Adicionar listener para quando o estado mudar para exibir o loader
    ref.listen(homeControllerProvider, (_, next) {
      if (next is AsyncLoading) {
        context.showLoader();
      } else {
        context.hideLoader();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HomeHeader(),
          // Calendário com data selecionada
          HomeCalendar(
            selectedDate: selectedDate,
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
                _loadSchedules(); // Recarrega agendamentos para nova data
              });
            },
          ),
          // Banner mostrando a data atual
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey[200],
            width: double.infinity,
            child: Text(
              'Agendamentos para ${dateFormat.format(selectedDate)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Lista de agendamentos
          Expanded(
            child: homeController.when(
              loading: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Erro ao carregar dados: ${error.toString()}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSchedules,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                );
              },
              data: (homeState) {
                final schedules = homeState.schedules;

                if (schedules.isEmpty) {
                  return const Center(
                    child: Text('Nenhum agendamento para esta data'),
                  );
                }

                return ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return HomeSchedule(schedule: schedule);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navegar para a tela de agendamento e aguardar o resultado (data)
          final scheduledDate = await Navigator.pushNamed(context, '/schedule');

          // Se retornou com uma data, atualizar a visualização para essa data
          if (scheduledDate is DateTime) {
            setState(() {
              selectedDate = scheduledDate;
              _loadSchedules();
            });
          }
        },
        backgroundColor: ColorsConstants.brown,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
