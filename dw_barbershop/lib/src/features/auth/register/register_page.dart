import 'package:dw_barbershop/src/core/ui/helpers/loader.dart'; // Importando o helper do loader
import 'package:dw_barbershop/src/features/auth/register/register_controller.dart';
import 'package:dw_barbershop/src/features/auth/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  void dispose() {
    _nameEC.dispose();
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = ref.watch(registerControllerProvider);

    ref.listen(registerControllerProvider, (_, state) {
      switch (state) {
        case RegisterState(status: RegisterStateStatus.initial):
          break;
        case RegisterState(status: RegisterStateStatus.loading):
          context.showLoader(); // Usando o loader
          break;
        case RegisterState(status: RegisterStateStatus.success):
          context.hideLoader(); // Usando o loader
          Navigator.of(context).pushNamed('/auth/register/barbershop');
        case RegisterState(
            status: RegisterStateStatus.error,
            :final errorMessage?
          ):
          context.hideLoader(); // Usando o loader
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameEC,
                  validator: Validatorless.required('Nome obrigatório'),
                  decoration: const InputDecoration(label: Text('Nome')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('E-mail obrigatório'),
                    Validatorless.email('E-mail inválido')
                  ]),
                  decoration: const InputDecoration(label: Text('E-mail')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordEC,
                  validator: Validatorless.multiple([
                    Validatorless.required('Senha obrigatória'),
                    Validatorless.min(
                        6, 'Senha deve ter no mínimo 6 caracteres')
                  ]),
                  obscureText: true,
                  decoration: const InputDecoration(label: Text('Senha')),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  validator: Validatorless.multiple([
                    Validatorless.required('Confirme a senha'),
                    Validatorless.compare(_passwordEC, 'Senhas não conferem')
                  ]),
                  obscureText: true,
                  decoration:
                      const InputDecoration(label: Text('Confirmar senha')),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () {
                    switch (registerController.status) {
                      case RegisterStateStatus.loading:
                        break;
                      default:
                        final valid =
                            _formKey.currentState?.validate() ?? false;
                        if (valid) {
                          ref
                              .read(registerControllerProvider.notifier)
                              .register(
                                name: _nameEC.text,
                                email: _emailEC.text,
                                password: _passwordEC.text,
                              );
                        }
                    }
                  },
                  child: Text(
                    registerController.status == RegisterStateStatus.loading
                        ? 'Carregando'
                        : 'CADASTRAR',
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
