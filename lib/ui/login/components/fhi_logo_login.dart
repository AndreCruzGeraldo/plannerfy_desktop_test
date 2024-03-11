import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

// ignore: use_key_in_widget_constructors
class FhiLogoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'lib/assets/images/fhi.png',
          height: 30,
          width: 30,
        ),
        const SizedBox(
          width: 10,
        ),
        const Text(
          'Desenvolvido por FHI',
          style: TextStyle(
            color: markPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
