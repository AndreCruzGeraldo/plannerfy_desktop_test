import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/spreadsheet_manager.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/spreadsheet_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_spreadsheet.dart';
import 'package:plannerfy_desktop/ui/home/components/document_tile.dart';
import 'package:plannerfy_desktop/ui/home/components/excel_dropdown.dart';
import 'package:plannerfy_desktop/ui/home/components/send_button.dart';
import 'package:plannerfy_desktop/ui/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';

class ExcelContent extends StatefulWidget {
  const ExcelContent({Key? key}) : super(key: key);

  @override
  State<ExcelContent> createState() => _ExcelContentState();
}

class _ExcelContentState extends State<ExcelContent> {
  List<Map<String, dynamic>> tiposDocumentos = [];
  List<Map<String, dynamic>> tiposPlataformas = [];
  String? plataforma;
  String? tipoArquivo;
  late UserManager userManager;
  bool isLoading = true;

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
        orElse: () => {'tipo_doc_descricao': ''}, // Retorna um valor padrão
      );
      return tipoDocumento['tipo_doc_descricao'];
    }
    return ''; // Retorna um valor padrão se tipoDocumentoExibicao for null
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
                  child: ExcelDropdown(
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
            DropTarget(
              onDragDone: (detail) async {
                if (plataforma != null && tipoArquivo != null) {
                  setState(() {
                    _files
                        .addAll(detail.files.map((xFile) => File(xFile.path)));
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                          'Por favor, selecione um tipo de arquivo e Plataforma',
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
                }
              },
              onDragUpdated: (detail) {
                setState(() {
                  offset = detail.localPosition;
                });
              },
              onDragEntered: (detail) {
                setState(() {
                  offset = detail.localPosition;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  offset = null;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: DottedBorder(
                  dashPattern: const [8, 6],
                  radius: const Radius.circular(8),
                  borderType: BorderType.RRect,
                  color: Colors.grey,
                  strokeWidth: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        if (_files.isEmpty)
                          const SizedBox(
                            height: 20,
                          ),
                        if (_files.isNotEmpty)
                          SizedBox(
                            height: 250,
                            child: ListView.separated(
                              itemCount: _files.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(color: Colors.grey),
                              itemBuilder: (context, index) {
                                final file = _files[index];
                                return GestureDetector(
                                  onTap: () {
                                    // _previewFile(file);
                                    SpreadsheetManager.previewFile(file);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: FutureBuilder<int>(
                                      future: file.length(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final fileSize = snapshot.data ?? 0;
                                          return DocumentTile(
                                            documentName: file.path
                                                .split('/')
                                                .last, // Display file name
                                            fileSize: fileSize,
                                            onDelete: () {
                                              setState(() {
                                                _files.removeAt(index);
                                              });
                                            },
                                          );
                                        } else {
                                          return const CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const Center(
                          child: Text(
                            "Arraste e solte os arquivos aqui",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                        const Text(
                          "ou",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () async {
                              _files.addAll(await SpreadsheetManager.pickFiles(
                                      context) //pickFiles(context)
                                  );
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'lib/assets/images/up_log.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(width: 10.0),
                                  const Text(
                                    'Selecionar Arquivo',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
