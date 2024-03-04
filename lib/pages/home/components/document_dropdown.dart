import 'package:flutter/material.dart';

class DocumentDropdown extends StatelessWidget {
  final String? selectedArquivo;
  final ValueChanged<String?> onArquivoChanged;
  final bool showDateInput;
  final Function(String) onYearSelected;
  final List<Map<String, dynamic>>
      tiposDocumentos; // Definindo o parâmetro tiposDocumentos

  static int currentYear = DateTime.now().year;
  static List<String> yearsList = [
    '$currentYear',
    '${currentYear - 1}',
    '${currentYear - 2}'
  ];

  const DocumentDropdown({
    Key? key,
    required this.selectedArquivo,
    required this.onArquivoChanged,
    required this.showDateInput,
    required this.onYearSelected,
    required this.tiposDocumentos, // Adicionando o parâmetro tiposDocumentos
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedYear; // Variável para armazenar o ano selecionado

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Container(
            height: 50,
            width: 350,
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
                      iconSize: 30.0,
                      alignment: Alignment.centerLeft,
                      value: selectedArquivo,
                      items: [
                        ...tiposDocumentos.map((tipoDocumento) =>
                            tipoDocumento['tipo_doc_exibicao'] as String),
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Center(child: Text(value)),
                          ),
                        );
                      }).toList(),
                      onChanged: onArquivoChanged,
                      hint: selectedArquivo != null
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (showDateInput)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 30,
                  ),
                  decoration: const InputDecoration(labelText: 'Ano'),
                  value: selectedYear,
                  onChanged: (newValue) {
                    onYearSelected(newValue ?? '');
                    selectedYear = newValue;
                  },
                  items: yearsList.map((year) {
                    return DropdownMenuItem<String>(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
