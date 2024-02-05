import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/models/empresa_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_company.dart';

class CompanyDropdown extends StatefulWidget {
  final String? selectedEmpresa;
  final ValueChanged<String?> onEmpresaChanged;

  const CompanyDropdown({
    Key? key,
    required this.selectedEmpresa,
    required this.onEmpresaChanged,
  }) : super(key: key);

  @override
  _CompanyDropdownState createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
  late List<Empresa> _empresas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmpresas();
  }

  Future<void> fetchEmpresas() async {
    List<Empresa> empresas = await WsCompany().getCompany();
    setState(() {
      _empresas = empresas;
      _isLoading = false;
    });
  }

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
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              iconSize: 30.0,
                              alignment: Alignment.centerLeft,
                              value: widget.selectedEmpresa,
                              items: _empresas.map((empresa) {
                                return DropdownMenuItem<String>(
                                  value: empresa.empRazaoSocial,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Center(
                                      child: Text(
                                        empresa.empRazaoSocial,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: widget.onEmpresaChanged,
                              hint: widget.selectedEmpresa != null
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
