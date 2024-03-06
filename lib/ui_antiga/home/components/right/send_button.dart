import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class SendButton extends StatelessWidget {
  final String texto;
  final Function function;

  const SendButton({Key? key, required this.texto, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        minimumSize: const Size(250, 60),
        backgroundColor: markPrimaryColor,
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: primaryFont,
        ),
      ),
    );
  }
}
