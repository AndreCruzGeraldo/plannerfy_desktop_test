import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class LoginButton extends StatelessWidget {
  final String texto;
  final Function login;

  const LoginButton({Key? key, required this.texto, required this.login})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          60,
        ),
        primary: markPrimaryColor,
      ),
      child: Text(
        texto,
        style: const TextStyle(
            fontSize: 18, color: Colors.white, fontFamily: primaryFont),
      ),
    );
  }
}
