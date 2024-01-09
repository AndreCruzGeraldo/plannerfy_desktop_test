import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown2.dart';

class DocumentSelection extends StatelessWidget {
  final String? selectedEmpresa;
  final String? selectedArquivo;
  final ValueChanged<String?> onArquivoChanged;

  const DocumentSelection({
    Key? key,
    required this.selectedEmpresa,
    required this.selectedArquivo,
    required this.onArquivoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
