import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final IconData prefixIcon;
  final IconData suffixIcon;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.prefixIcon,
    required this.suffixIcon,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: width(context) * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
        child: TextFormField(
          obscureText: isPasswordVisible,
          focusNode: widget.focusNode,
          controller: widget.controller,
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: markPrimaryColor,
            ),
            labelText: widget.labelText,
            labelStyle: const TextStyle(
                fontSize: 20, color: markPrimaryColor, fontFamily: primaryFont),
            alignLabelWithHint: false,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: markPrimaryColor,
              ),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
