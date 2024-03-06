import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/spreadsheet_manager.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/spreadsheet_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_spreadsheet.dart';
import 'package:plannerfy_desktop/ui_antiga/home/components/right/file_drop_target.dart';
import 'package:plannerfy_desktop/ui_antiga/home/components/right/spreadsheet_dropdown.dart';
import 'package:plannerfy_desktop/ui_antiga/home/components/right/send_button.dart';
import 'package:plannerfy_desktop/ui_antiga/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';

class SpreadsheetUpload extends StatefulWidget {
  const SpreadsheetUpload({Key? key}) : super(key: key);

  @override
  State<SpreadsheetUpload> createState() => _SpreadsheetUploadState();
}

class _SpreadsheetUploadState extends State<SpreadsheetUpload> {
  List<Map<String, dynamic>> tiposDocumentos = [];
  List<Map<String, dynamic>> tiposPlataformas = [];
  String? plataforma;
  String? tipoArquivo;
  late UserManager userManager;
  bool isLoading = true;
  // ignore: unused_field
  bool _filesAdded = false;

  final List<File> _files = [];

  Offset? offset;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
    _loadTiposDocumentosPlanilha();
    _loadTiposPlataformasPlanilha();
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
        orElse: () => {'plat_descricao': ''}, // Retorna um valor padrão
      );
      return tipoPlataforma['plat_descricao'];
    }
    return ''; // Retorna um valor padrão se tipoPlataformaExibicao for null
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            FileDropTarget(
              onFilesDropped: (files) {
                setState(() {
                  _files.addAll(files);
                  _filesAdded = _files.isNotEmpty;
                });
              },
              onFilesAdded: (added) {
                setState(() {
                  _filesAdded = added;
                });
              },
              pickFiles: (context) => SpreadsheetManager.pickFiles(context),
              previewFile: (file) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      minimumSize: const Size(250, 60),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: primaryFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SendButton(
                  texto: "Enviar",
                  function: () async {
                    final tipoDocumentoDescricao =
                        mapTipoDocumentoExibicaoToDescricao(tipoArquivo);
                    final tipoPlataformaDescricao =
                        mapTipoPlataformaExibicaoToDescricao(plataforma);
                    // ignore: unnecessary_null_comparison
                    if (tipoDocumentoDescricao == null ||
                        _files.isEmpty ||
                        (tipoArquivo != 'Documentos' &&
                            // ignore: unnecessary_null_comparison
                            _files.isEmpty == null)) {
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
                      for (File file in _files) {
                        String filePath = file.path.toString();
                        String fileName = filePath.split('\\').last;

                        SpreadsheetModel spreadsheet = SpreadsheetModel(
                          syncCnpj: userManager.chosenCompany!.empCnpj,
                          syncId: 0,
                          syncPlataforma: tipoPlataformaDescricao,
                          syncTipoArquivo: tipoDocumentoDescricao,
                          syncPath: fileName,
                          syncUsuario: userManager.user!.email,
                          syncDataCadastro: DateTime.now().toString(),
                          syncStatus: "A",
                        );

                        await WsSpreadsheet.uploadFile(
                            jsonData: {"arquivo": spreadsheet.toJson()},
                            filePath: filePath);
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
