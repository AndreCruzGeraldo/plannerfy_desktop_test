import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/models/empresa_model.dart';
import 'package:provider/provider.dart';

class CompanyDropdown extends StatefulWidget {
  final String? selectedEmpresa;
  final ValueChanged<String?> onEmpresaChanged;
  final bool enabled; // Adicionando o parâmetro enabled

  const CompanyDropdown({
    Key? key,
    required this.selectedEmpresa,
    required this.onEmpresaChanged,
    required this.enabled, // Adicionando o parâmetro enabled
  }) : super(key: key);

  @override
  _CompanyDropdownState createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
  late List<Empresa> _empresas = [];
  bool _isLoading = true;
  bool _dropdownSelected =
      false; // Adicionando estado para controlar se o dropdown foi selecionado

  @override
  void initState() {
    super.initState();
    fetchEmpresas();
  }

  Future<void> fetchEmpresas() async {
    final userProvider = Provider.of<UserManager>(context, listen: false);
    List<Empresa>? empresas = userProvider.user!.empresasVinculadas;
    setState(() {
      _empresas = empresas!;
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
                              onChanged: !_dropdownSelected
                                  ? widget.enabled
                                      ? (newValue) {
                                          setState(() {
                                            _dropdownSelected = true;
                                          });
                                          widget.onEmpresaChanged(newValue);
                                          final userProvider =
                                              Provider.of<UserManager>(context,
                                                  listen: false);
                                          final selectedCompany =
                                              _empresas.firstWhere((empresa) =>
                                                  empresa.empRazaoSocial ==
                                                  newValue);
                                          userProvider
                                              .setCompany(selectedCompany);
                                        }
                                      : null
                                  : null, // Desabilita o onChanged se o dropdown já foi selecionado
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
