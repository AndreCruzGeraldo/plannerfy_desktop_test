import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/ui/accounting/accounting_page.dart';
import 'package:plannerfy_desktop/ui/attachment/attachment_page.dart';
import 'package:plannerfy_desktop/ui/home/components/card_button.dart';
import 'package:plannerfy_desktop/ui/spreadsheet/spreadsheet_page.dart';
import 'package:plannerfy_desktop/ui/document/document_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import '../login/login_page.dart';
import 'components/company_dropdown.dart';
import 'components/logout_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserManager userManager;
  String? selectedEmpresa;
  String? selectedArquivo;
  String? selectedYear;

  bool empresaSelecionada = false;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (context, userManager, _) {
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
                              // Desativar o DropdownButton se uma empresa foi selecionada
                              enabled: !empresaSelecionada,
                              onEmpresaChanged: (empresa) {
                                setState(() {
                                  selectedEmpresa = empresa;
                                  empresaSelecionada = true;
                                  // userManager.chosenCompany!.empCnpj = empresa;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      LogoutButton(
                        onPressed: () {
                          Navigator.pushReplacement(
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
                            ? const Column(
                                children: [
                                  Image(
                                    image: AssetImage(
                                        'lib/assets/images/alert.png'),
                                    height: 120,
                                    width: 120,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Favor selecionar Empresa',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardButton(
                                        titulo: "Arquivos de Solicitações",
                                        icone: Icons.file_copy,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AttachmentPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 30),
                                      CardButton(
                                        titulo: "Upload de Documentos",
                                        icone: Icons.file_upload,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DocumentPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CardButton(
                                        titulo: "Upload de Contabilidade",
                                        icone: Icons.account_balance,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AccountingPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 30),
                                      CardButton(
                                        titulo: "Upload de Planilhas",
                                        icone: Icons.insert_drive_file_outlined,
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SpreadsheetPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
