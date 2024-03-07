import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/company_model.dart';
import 'package:provider/provider.dart';

class CompanyDropdown extends StatefulWidget {
  final String? selectedEmpresa;
  final ValueChanged<String?> onEmpresaChanged;
  final bool enabled;

  const CompanyDropdown({
    Key? key,
    required this.selectedEmpresa,
    required this.onEmpresaChanged,
    required this.enabled,
  }) : super(key: key);

  @override
  _CompanyDropdownState createState() => _CompanyDropdownState();
}

class _CompanyDropdownState extends State<CompanyDropdown> {
  late List<Company> _empresas = [];
  bool _isLoading = true;
  bool _dropdownSelected = false;

  @override
  void initState() {
    super.initState();
    fetchEmpresas();
  }

  Future<void> fetchEmpresas() async {
    final userProvider = Provider.of<UserManager>(context, listen: false);
    List<Company>? empresas = userProvider.user!.empresasVinculadas;
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
                              onChanged: widget.enabled && !_dropdownSelected
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
                                      userProvider.setCompany(selectedCompany);
                                      // Reset _dropdownSelected to allow future selections
                                      Future.delayed(Duration.zero, () {
                                        setState(() {
                                          _dropdownSelected = false;
                                        });
                                      });
                                    }
                                  : null,
                              hint: widget.selectedEmpresa != null
                                  ? null
                                  : const Center(
                                      child: Text(
                                        'Selecione Empresa',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                              disabledHint: const Center(
                                child: Text(
                                  'Dropdown desativado',
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
