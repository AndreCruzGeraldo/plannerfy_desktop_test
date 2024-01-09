import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown.dart';

class CompanySelection extends StatelessWidget {
  final String? selectedEmpresa;
  final ValueChanged<String?> onEmpresaChanged;

  const CompanySelection({
    Key? key,
    required this.selectedEmpresa,
    required this.onEmpresaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'lib/assets/images/Logo2.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: CustomDropdown(
              items: const [
                'Estrelar Ltda',
                'MegaTech Solutions Inc',
                'Global Foods Group',
                'InnovateWare Co',
                'Visionary Motors Corporation',
                'Evergreen Investments LLC',
                'Quantum Innovations Ltd',
                'Pacific Crest Enterprises',
              ],
              onChanged: onEmpresaChanged,
              hintText: selectedEmpresa ?? 'Selecione Empresa',
            ),
          ),
        ],
      ),
    );
  }
}
