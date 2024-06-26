import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/accounting_manager.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/accounting_model.dart';
import 'package:plannerfy_desktop/ui/accounting/components/accounting_dropdown.dart';
import 'package:plannerfy_desktop/services/queries/ws_accounting.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import '../common/file_drop_target.dart';
import '../common/send_button.dart';
import '../home/components/company_dropdown.dart';

class AccountingPage extends StatefulWidget {
  final String? selectedEmpresa;
  const AccountingPage({Key? key, this.selectedEmpresa}) : super(key: key);

  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> {
  List<Map<String, dynamic>> tiposDocumentos = [];
  String? selectedArquivo;
  String? selectedYear;
  late UserManager userManager;
  late AccountingManager accountingManager;
  bool isLoading = true;
  String? selectedEmpresa;

  bool empresaSelecionada = false;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
    accountingManager = Provider.of<AccountingManager>(context, listen: false);
    _loadTiposDocumentos();
    selectedEmpresa = widget.selectedEmpresa;
    empresaSelecionada = selectedEmpresa != null;
  }

//-------------- REFATORAR ESSA PARTE --- INICIO --------------------------------------
  Future<void> _loadTiposDocumentos() async {
    try {
      MapSD response = await WsAccounting.getTiposDocumentos();
      if (response.containsKey('error')) {
        print('Error: ${response['error']}');
      } else {
        final tiposDocumentoList = response['tipos_documento'];
        if (tiposDocumentoList != null && tiposDocumentoList is List) {
          setState(() {
            tiposDocumentos = tiposDocumentoList.cast<MapSD>();
            isLoading = false;
          });
        } else {
          print('Error: tipos_documento is null or not a List');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String mapTipoDocumentoExibicaoToDescricao(String? tipoDocumentoExibicao) {
    if (tipoDocumentoExibicao != null) {
      final tipoDocumento = tiposDocumentos.firstWhere(
        (element) => element['tipo_doc_exibicao'] == tipoDocumentoExibicao,
        orElse: () => {'tipo_doc_descricao': ''},
      );
      return tipoDocumento['tipo_doc_descricao'];
    }
    return '';
  }

  void myFunction(String? parameter) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            accountingManager.files.clear();
            Navigator.pop(context);
          },
        ),
        title: const Text('Home > Contabilidade'),
        backgroundColor: markPrimaryColor,
      ),
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
                          enabled: false,
                          onEmpresaChanged: (empresa) {
                            setState(() {
                              selectedEmpresa = empresa;
                              empresaSelecionada = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 125),
                ],
              ),
            ),
          ),
          // Lado direito do app
          Expanded(
            flex: 6,
            child: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isLoading)
                        const CircularProgressIndicator()
                      else
                        AccountingDropdown(
                          selectedArquivo: selectedArquivo,
                          onArquivoChanged: (value) {
                            setState(() {
                              selectedArquivo = value;
                              if (value == 'Documentos') {
                                selectedYear = null;
                              }
                            });
                          },
                          // showDateInput: selectedArquivo != null &&
                          //     selectedArquivo != 'Documentos',
                          onYearSelected: (String year) {
                            setState(() {
                              selectedYear = year;
                            });
                          },
                          tiposDocumentos: tiposDocumentos,
                        ),
                      const SizedBox(height: 20),
                      const FileDropTarget(
                        tipo: TipoArquivo.CONTABILIDADE,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SendButton(
                            texto: "Enviar",
                            function: () async {
                              final tipoDocumentoDescricao =
                                  mapTipoDocumentoExibicaoToDescricao(
                                      selectedArquivo);
                              // ignore: unnecessary_null_comparison
                              if (tipoDocumentoDescricao == null ||
                                  accountingManager.files.isEmpty ||
                                  (selectedArquivo != 'Documentos' &&
                                      selectedYear == null)) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Atenção!'),
                                      content: const Text(
                                        'Por favor, selecione o tipo de arquivo, ano e adicione arquivos.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                for (File file in accountingManager.files) {
                                  String filePath = file.path.toString();
                                  String fileName = filePath.split('\\').last;

                                  AccountingModel accounting = AccountingModel(
                                    cnpj: userManager.chosenCompany!.empCnpj,
                                    id: 0,
                                    ano: int.parse(selectedYear!),
                                    tipoArquivo: tipoDocumentoDescricao,
                                    nome: fileName,
                                    descricao: fileName,
                                    path: fileName,
                                    usuario: userManager.user!.email,
                                    dataCadastro: DateTime.now().toString(),
                                    status: "A",
                                  );

                                  await WsAccounting.uploadFile(jsonData: {
                                    "contabilidade": accounting.toJson()
                                  }, filePath: filePath)
                                      .then((_) {
                                    // Se chegou aqui, o envio foi bem-sucedido
                                    _showSnackbar(
                                        context, 'Arquivo enviado com sucesso.',
                                        success: true);
                                  }).catchError((error) {
                                    // Se chegou aqui, ocorreu um erro durante o envio
                                    _showSnackbar(context,
                                        'Falha ao enviar arquivo $fileName: $error',
                                        success: false);
                                  });
                                }
                                accountingManager.files.clear();
                                Navigator.pop(context);
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message,
      {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }
}
