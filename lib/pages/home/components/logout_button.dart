import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Sair',
      onPressed: onPressed,
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Define o cursor para o clique
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), // Bordas arredondadas
            color: Colors.redAccent.shade700, // Cor de fundo
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 24), // Preenchimento interno
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white, // Cor do texto
              fontSize: 16, // Tamanho da fonte
              fontWeight: FontWeight.bold, // Peso da fonte
            ),
          ),
        ),
      ),
    );
  }
}
