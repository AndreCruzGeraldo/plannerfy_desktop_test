import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/models/empresa_model.dart';
import 'package:provider/provider.dart';

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
  // late UserManager userManager;

  @override
  void initState() {
    // userManager = Provider.of<UserManager>(context, listen: false);
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
