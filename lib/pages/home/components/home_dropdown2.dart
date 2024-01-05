import 'package:flutter/material.dart';

class CustomDropdown2 extends StatelessWidget {
  final List<String> items;
  final String? hintText;
  final Function(String?) onChanged;

  const CustomDropdown2({
    Key? key,
    required this.items,
    required this.onChanged,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                iconSize: 36.0, // Ajuste o tamanho da seta conforme necessário
                alignment: Alignment.centerLeft, // Alinhar o botão à esquerda
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Center(child: Text(value)),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                hint: hintText != null
                    ? Center(
                        child: Text(
                          hintText!,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
