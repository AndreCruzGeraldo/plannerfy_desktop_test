import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/card_button.dart';
import 'package:plannerfy_desktop/pages/home/components/company_dropdown.dart';
import 'package:plannerfy_desktop/pages/home/components/logout_button.dart';
import 'package:plannerfy_desktop/pages/home/components/arquivo_content.dart';
import 'package:plannerfy_desktop/pages/home/components/upload_content.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateToPage(Widget page) {
    setState(() {
      _selectedContent = page;
    });
  }

  String? selectedEmpresa;
  String? selectedArquivo;
  String? selectedYear;

  // Conteúdo selecionado para ser exibido no lado direito
  Widget? _selectedContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Lado esquerdo do app
          Expanded(
            flex: 4,
            child: Container(
              color: markPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CompanyDropdown(
                          selectedEmpresa: selectedEmpresa,
                          onEmpresaChanged: (value) {
                            setState(() {
                              selectedEmpresa = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  LogoutButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // Lado direito do app
          Expanded(
            flex: 6,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    selectedEmpresa == null
                        ? Column(
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
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Visibility(
                                visible: _selectedContent == null,
                                child: CardButton(
                                  titulo: "Arquivos de Solicitações",
                                  icone: Icons.file_copy,
                                  navegacao: () {
                                    _navigateToPage(
                                      const SolicitacoesContent(),
                                    );
                                  },
                                ),
                              ),
                              Visibility(
                                visible: _selectedContent == null,
                                child: CardButton(
                                  titulo: "Upload de Arquivos",
                                  icone: Icons.file_upload,
                                  navegacao: () {
                                    _navigateToPage(
                                      const UploadContent(),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                    // Exibir o conteúdo selecionado
                    _selectedContent ?? Container(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
