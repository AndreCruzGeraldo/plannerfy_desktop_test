import 'package:flutter/material.dart';

class ExcelDropdown extends StatelessWidget {
  final String? selectedArquivo1;
  final String? selectedArquivo2;
  final void Function(String?) onArquivoChanged1;
  final void Function(String?) onArquivoChanged2;
  final bool showDateInput;

  static int currentYear = DateTime.now().year;

  const ExcelDropdown({
    Key? key,
    required this.selectedArquivo1,
    required this.selectedArquivo2,
    required this.onArquivoChanged1,
    required this.onArquivoChanged2,
    this.showDateInput = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 30.0,
                  alignment: Alignment.centerLeft,
                  value: selectedArquivo1,
                  items: const [
                    // 'Conta Azul',
                    'Nibo',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Center(child: Text(value)),
                      ),
                    );
                  }).toList(),
                  onChanged: onArquivoChanged1,
                  hint: selectedArquivo1 != null
                      ? null
                      : const Center(
                          child: Text(
                            'Plataformas',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 30.0,
                  alignment: Alignment.centerLeft,
                  value: selectedArquivo2,
                  items: const [
                    'Cadastro',
                    'Contas a Pagar',
                    'Extrato',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Center(child: Text(value)),
                      ),
                    );
                  }).toList(),
                  onChanged: onArquivoChanged2,
                  hint: selectedArquivo2 != null
                      ? null
                      : const Center(
                          child: Text(
                            'Tipo de Arquivo',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
