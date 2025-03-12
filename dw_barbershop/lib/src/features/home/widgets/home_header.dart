import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.watch(userServiceProvider);

    return FutureBuilder<UserModel>(
      future: userService.getLoggedUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = snapshot.data!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem vindo(a),',
                    style: TextStyle(
                      color: ColorsConstants.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _logout(ref, context);
                },
                child: const CircleAvatar(
                  backgroundColor: ColorsConstants.brown,
                  child: Icon(Icons.logout, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    await ref.read(userServiceProvider).logout();
    // Verificação de montagem para evitar uso de BuildContext após async gap
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/login',
        (route) => false,
      );
    }
  }
}
