import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Navega diretamente para a tela de login sem animações
    _redirectToLogin();
  }

  Future<void> _redirectToLogin() async {
    // Pequeno delay apenas para garantir que a inicialização está completa
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navegar para a tela de login
    debugPrint('🚀 Navegando diretamente para a tela de login');
    Navigator.of(context).pushReplacementNamed('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    // Splash simplificado que vai aparecer brevemente
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Image(
          image: AssetImage('assets/images/imgLogo.png'),
          width: 100,
          height: 120,
        ),
      ),
    );
  }
}
