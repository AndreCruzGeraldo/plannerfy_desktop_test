import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      icon: Icons.exit_to_app, // Set the logout icon
      text: 'Sair',
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.transparent, // Set background color to transparent
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              SizedBox(width: 8), // Add some spacing between icon and text
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white, // Set text color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// class LogoutButton extends StatelessWidget {
//   final VoidCallback onPressed;

//   const LogoutButton({Key? key, required this.onPressed}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CustomButton(
//       text: 'Sair',
//       onPressed: onPressed,
//     );
//   }
// }

// class CustomButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;

//   const CustomButton({Key? key, required this.onPressed, required this.text})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click, // Define o cursor para o clique
//       child: GestureDetector(
//         onTap: onPressed,
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25), // Bordas arredondadas
//             color: Colors.redAccent.shade700, // Cor de fundo
//           ),
//           padding: const EdgeInsets.symmetric(
//               vertical: 12, horizontal: 24), // Preenchimento interno
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white, // Cor do texto
//               fontSize: 16, // Tamanho da fonte
//               fontWeight: FontWeight.bold, // Peso da fonte
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
