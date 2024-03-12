import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class UserField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final FocusNode nextFocusNode;
  final IconData prefixIcon;

  const UserField(
      {Key? key,
      required this.controller,
      required this.focusNode,
      required this.nextFocusNode,
      required this.labelText,
      required this.prefixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 6,
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 20, color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                prefixIcon: Icon(
                  prefixIcon,
                  color: markPrimaryColor,
                ),
                labelText: labelText,
                labelStyle:
                    const TextStyle(fontSize: 18, color: markPrimaryColor),
                alignLabelWithHint: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
