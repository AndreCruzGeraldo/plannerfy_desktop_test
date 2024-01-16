import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class SendButton extends StatelessWidget {
  final String texto;
  final Function login;

  const SendButton({Key? key, required this.texto, required this.login})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        login();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        minimumSize: const Size(250, 60),
        primary: markPrimaryColor,
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
