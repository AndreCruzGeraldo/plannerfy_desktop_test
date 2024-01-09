import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown2.dart';

class DocumentSelection extends StatelessWidget {
  final String? selectedEmpresa;
  final String? selectedArquivo;
  final ValueChanged<String?> onArquivoChanged;
  final bool showDateInput;
  final Function(String, String) onDateSelected;

  const DocumentSelection({
    Key? key,
    required this.selectedEmpresa,
    required this.selectedArquivo,
    required this.onArquivoChanged,
    required this.showDateInput,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedMonth; // Variável para armazenar o mês selecionado
    String? selectedYear; // Variável para armazenar o ano selecionado

    final List<String> yearsList = [
      '${DateTime.now().year}',
      '${DateTime.now().year - 1}',
      '${DateTime.now().year - 2}',
    ];

    return Column(
      children: [
        if (selectedEmpresa != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: CustomDropdown2(
              items: const [
                'Documentos',
                'Contrato social',
                'DRE Contabil',
                'Balanço',
                'Balancete',
              ],
              onChanged: onArquivoChanged,
              hintText: selectedArquivo ?? 'Tipo de Arquivo',
            ),
          ),
        const SizedBox(height: 20),
        if (showDateInput)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Ano'),
                    value: selectedYear, // Defina o valor do ano selecionado
                    onChanged: (newValue) {
                      onDateSelected(selectedMonth ?? '', newValue ?? '');
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
              ),
            ],
          ),
        Visibility(
          visible: selectedEmpresa == null,
          child: Column(
            children: const [
              Icon(
                Icons.construction,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                'Favor selecionar Empresa',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
