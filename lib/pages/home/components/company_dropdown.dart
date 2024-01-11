import 'package:flutter/material.dart';

class CompanyDropdown extends StatelessWidget {
  final String? selectedEmpresa;
  final ValueChanged<String?> onEmpresaChanged;

  const CompanyDropdown({
    Key? key,
    required this.selectedEmpresa,
    required this.onEmpresaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? selectedCompany; // Variable to store the selected company

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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
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
                        value: selectedEmpresa,
                        items: const [
                          'Estrelar Ltda',
                          'MegaTech Solutions Inc',
                          'Global Foods Group',
                          'InnovateWare Co',
                          'Visionary Motors Corporation',
                          'Evergreen Investments LLC',
                          'Quantum Innovations Ltd',
                          'Pacific Crest Enterprises',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Center(
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onEmpresaChanged,
                        hint: selectedEmpresa != null
                            ? null
                            : const Center(
                                child: Text(
                                  'Selecione Empresa',
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
        ],
      ),
    );
  }
}
