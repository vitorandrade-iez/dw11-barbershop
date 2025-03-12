import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/loader.dart';
import 'package:dw_barbershop/src/core/ui/widgets/barbershop_logo.dart';
import 'package:dw_barbershop/src/features/auth/login/login_controller.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (_, state) {
      switch (state.status) {
        case LoginStateStatus.initial:
          break;
        case LoginStateStatus.loading:
          context.showLoader(); // Usando a extensão
          break;
        case LoginStateStatus.success:
          context.hideLoader(); // Usando a extensão
          Navigator.of(context).pushReplacementNamed('/home');
          break;
        case LoginStateStatus.error:
          context.hideLoader(); // Usando a extensão
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao realizar login'),
              backgroundColor: ColorsConstants.red,
            ),
          );
          break;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConstants.backgroundChair),
              opacity: 0.2,
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const BarbershopLogo(),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              label: Text('Email'),
                              hintText: 'Digite o seu email',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle:
                                  TextStyle(color: ColorsConstants.white),
                              hintStyle:
                                  TextStyle(color: ColorsConstants.white),
                            ),
                            validator: Validatorless.multiple([
                              Validatorless.required('Email obrigatório'),
                              Validatorless.email('Email inválido'),
                            ]),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Digite a sua senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle:
                                  TextStyle(color: ColorsConstants.white),
                              hintStyle:
                                  TextStyle(color: ColorsConstants.white),
                            ),
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatória'),
                              Validatorless.min(6,
                                  'Senha deve conter pelo menos 6 caracteres'),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/auth/register');
                              },
                              child: const Text(
                                'Criar conta',
                                style: TextStyle(
                                  color: ColorsConstants.brown,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            onPressed: () {
                              switch (loginController.status) {
                                case LoginStateStatus.loading:
                                  break;
                                default:
                                  final valid =
                                      _formKey.currentState?.validate() ??
                                          false;
                                  if (valid) {
                                    ref
                                        .read(loginControllerProvider.notifier)
                                        .login(_emailController.text,
                                            _passwordController.text);
                                  }
                              }
                            },
                            child: const Text('ACESSAR'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
