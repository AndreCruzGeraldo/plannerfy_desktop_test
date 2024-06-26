import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/spreadsheet_manager.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/spreadsheet_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_spreadsheet.dart';
import 'package:plannerfy_desktop/ui/spreadsheet/components/spreadsheet_dropdown.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import '../common/file_drop_target.dart';
import '../common/send_button.dart';
import '../home/components/company_dropdown.dart';

class SpreadsheetPage extends StatefulWidget {
  final String? selectedEmpresa;
  const SpreadsheetPage({Key? key, this.selectedEmpresa}) : super(key: key);

  @override
  State<SpreadsheetPage> createState() => _SpreadsheetPageState();
}

class _SpreadsheetPageState extends State<SpreadsheetPage> {
  List<Map<String, dynamic>> tiposDocumentos = [];
  List<Map<String, dynamic>> tiposPlataformas = [];
  String? plataforma;
  String? tipoArquivo;
  late UserManager userManager;
  late SpreadsheetManager spreadsheetManager;
  bool isLoading = true;
  String? selectedEmpresa;
  bool empresaSelecionada = false;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
    spreadsheetManager =
        Provider.of<SpreadsheetManager>(context, listen: false);
    _loadTiposDocumentosPlanilha();
    _loadTiposPlataformasPlanilha();
    selectedEmpresa = widget.selectedEmpresa;
    empresaSelecionada = selectedEmpresa != null;
  }

  Future<void> _loadTiposDocumentosPlanilha() async {
    try {
      MapSD response = await WsSpreadsheet.getTiposDocumentosPlanilha();
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

  Future<void> _loadTiposPlataformasPlanilha() async {
    try {
      MapSD response = await WsSpreadsheet.getTiposPlataformasPlanilha();
      if (response.containsKey('error')) {
        print('Error: ${response['error']}');
      } else {
        final tiposPlataformaList = response['plataformas'];
        if (tiposPlataformaList != null && tiposPlataformaList is List) {
          setState(() {
            tiposPlataformas = tiposPlataformaList.cast<MapSD>();
            isLoading = false;
          });
        } else {
          print('Error: tipos_plataformas is null or not a List');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String mapTipoPlataformaExibicaoToDescricao(String? tipoPlataformaExibicao) {
    if (tipoPlataformaExibicao != null) {
      final tipoPlataforma = tiposPlataformas.firstWhere(
        (element) => element['plat_exibicao'] == tipoPlataformaExibicao,
        orElse: () => {'plat_descricao': ''},
      );
      return tipoPlataforma['plat_descricao'];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Home > Planilhas'),
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
                          enabled: false,
                          selectedEmpresa: selectedEmpresa,
                          // enabled: !empresaSelecionada,
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
                      Row(
                        children: [
                          Expanded(
                            child: SpreadsheetDropdown(
                              plataforma: plataforma,
                              onPlataformaChanged: (value) {
                                setState(() {
                                  plataforma = value;
                                });
                              },
                              tipoArquivo: tipoArquivo,
                              onTipoArquivoChanged: (value) {
                                setState(() {
                                  tipoArquivo = value;
                                });
                              },
                              tiposDocumentos: tiposDocumentos,
                              tiposPlataformas: tiposPlataformas,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const FileDropTarget(
                        tipo: TipoArquivo.PLANILHA,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SendButton(
                            texto: "Enviar",
                            function: () async {
                              final tipoDocumentoDescricao =
                                  mapTipoDocumentoExibicaoToDescricao(
                                      tipoArquivo);
                              final tipoPlataformaDescricao =
                                  mapTipoPlataformaExibicaoToDescricao(
                                      plataforma);
                              // ignore: unnecessary_null_comparison
                              if (tipoDocumentoDescricao == null ||
                                  spreadsheetManager.files.isEmpty ||
                                  (tipoArquivo != 'Documentos' &&
                                      spreadsheetManager.files.isEmpty)) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Atenção!'),
                                      content: const Text(
                                        'Por favor, selecione o tipo de arquivo, plataforma e adicione arquivos.',
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
                                for (File file in spreadsheetManager.files) {
                                  String filePath = file.path.toString();
                                  String fileName = filePath.split('\\').last;

                                  SpreadsheetModel spreadsheet =
                                      SpreadsheetModel(
                                    syncCnpj:
                                        userManager.chosenCompany!.empCnpj,
                                    syncId: 0,
                                    syncPlataforma: tipoPlataformaDescricao,
                                    syncTipoArquivo: tipoDocumentoDescricao,
                                    syncPath: fileName,
                                    syncUsuario: userManager.user!.email,
                                    syncDataCadastro: DateTime.now().toString(),
                                    syncStatus: "A",
                                  );

                                  await WsSpreadsheet.uploadFile(jsonData: {
                                    "arquivo": spreadsheet.toJson()
                                  }, filePath: filePath)
                                      .then((_) {
                                    _showSnackbar(
                                        context, 'Arquivo enviado com sucesso.',
                                        success: true);
                                  }).catchError((error) {
                                    _showSnackbar(context,
                                        'Falha ao enviar arquivo $fileName: $error',
                                        success: false);
                                  });
                                }
                                spreadsheetManager.files.clear();
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
