import 'package:dw_barbershop/src/core/rest_client/rest_client.dart';
import 'package:dw_barbershop/src/core/rest_client/rest_client_test.dart';
import 'package:dw_barbershop/src/core/ui/theme/app_theme.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/auth/register/register_page.dart';
import 'package:dw_barbershop/src/features/home/home_page.dart';
import 'package:dw_barbershop/src/features/schedule/schedule_page.dart';
import 'package:dw_barbershop/src/features/splash/splash_page.dart';
import 'package:flutter/material.dart';

class BarbershopApp extends StatefulWidget {
  const BarbershopApp({super.key});

  @override
  State<BarbershopApp> createState() => _BarbershopAppState();
}

class _BarbershopAppState extends State<BarbershopApp> {
  @override
  void initState() {
    super.initState();
    // Teste de conexão com o servidor
    _testServerConnection();
  }

  Future<void> _testServerConnection() async {
    // Atraso para garantir que a UI esteja renderizada
    await Future.delayed(const Duration(seconds: 2));

    final restClient = RestClient();
    final tester = RestClientTest(restClient);

    final isConnected = await tester.testConnection();

    // Status da conexão com o servidor
    debugPrint(isConnected
        ? '✅ Conexão com o servidor REST estabelecida com sucesso.'
        : '❌ Não foi possível conectar ao servidor REST.\n⚠️ Verifique se o servidor Json Rest Server está em execução na porta 8080.');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DW Barbershop',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const SplashPage(),
        '/auth/login': (_) => const LoginPage(),
        '/auth/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/schedule': (_) => const SchedulePage(), // Nova rota de agendamento
      },
    );
  }
}
