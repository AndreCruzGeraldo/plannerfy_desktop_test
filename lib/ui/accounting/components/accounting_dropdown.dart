import 'package:flutter/material.dart';

class AccountingDropdown extends StatelessWidget {
  final String? selectedArquivo;
  final ValueChanged<String?> onArquivoChanged;
  final Function(String) onYearSelected;
  final List<Map<String, dynamic>>
      tiposDocumentos; // Definindo o parâmetro tiposDocumentos

  static int currentYear = DateTime.now().year;
  static List<String> yearsList = [
    '$currentYear',
    '${currentYear - 1}',
    '${currentYear - 2}',
    '${currentYear - 3}',
  ];

  const AccountingDropdown({
    Key? key,
    required this.selectedArquivo,
    required this.onArquivoChanged,
    required this.onYearSelected,
    required this.tiposDocumentos, // Adicionando o parâmetro tiposDocumentos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedYear;

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
                  value: selectedArquivo,
                  items: tiposDocumentos.map((tipoPlataforma) {
                    final String? platformDisplay =
                        tipoPlataforma['tipo_doc_exibicao'] as String?;
                    return DropdownMenuItem<String>(
                      value: platformDisplay ?? '',
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Center(child: Text(platformDisplay ?? '')),
                      ),
                    );
                  }).toList(),
                  onChanged: onArquivoChanged,
                  hint: selectedArquivo != null
                      ? null
                      : const Center(
                          child: Text('Tipo de Arquivo',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black)),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
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
                child: DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Ano',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 10,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  value: selectedYear,
                  onChanged: (newValue) {
                    onYearSelected(newValue ?? '');
                    selectedYear = newValue;
                  },
                  items: yearsList.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Center(
                        child: Text(
                          year,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
