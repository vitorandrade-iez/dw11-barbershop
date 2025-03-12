import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:flutter/material.dart';

class BarbershopLogo extends StatelessWidget {
  const BarbershopLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageConstants.imageLogo,
          width: 120,
          height: 120,
        ),
        const SizedBox(height: 12),
        const Text(
          TextConstants.appName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorsConstants.brown,
            fontFamily: FontConstants.fontFamily,
          ),
        ),
      ],
    );
  }
}
