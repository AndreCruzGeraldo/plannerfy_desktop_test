import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class CardButton extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final VoidCallback onPressed;

  const CardButton({
    Key? key,
    required this.titulo,
    required this.icone,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      child: InkWell(
        onTap: onPressed, // Definindo o onPressed do InkWell
        child: Container(
          width: 230,
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Icon(icone, size: 42, color: markPrimaryColor),
              ),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: primaryFont,
                  fontWeight: FontWeight.bold,
                  color: markPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
