import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/accounting_model.dart';
import 'package:plannerfy_desktop/ui/home/components/document_dropdown.dart';
import 'package:plannerfy_desktop/ui/home/components/document_tile.dart';
import 'package:plannerfy_desktop/ui/home/components/send_button.dart';
import 'package:plannerfy_desktop/ui/home/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:plannerfy_desktop/services/queries/ws_accounting.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountingUpload extends StatefulWidget {
  const AccountingUpload({Key? key}) : super(key: key);

  @override
  State<AccountingUpload> createState() => _AccountingUploadState();
}

class _AccountingUploadState extends State<AccountingUpload> {
  List<Map<String, dynamic>> tiposDocumentos = [];
  String? selectedArquivo;
  String? selectedYear;
  final List<File> _files = [];
  late UserManager userManager;
  bool isLoading = true;

  int numero = 0;

  Offset? offset;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
    _loadTiposDocumentos();
  }

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
        orElse: () => {'tipo_doc_descricao': ''}, // Retorna um valor padrão
      );
      return tipoDocumento['tipo_doc_descricao'];
    }
    return ''; // Retorna um valor padrão se tipoDocumentoExibicao for null
  }

  Future<Iterable<File>> pickFiles(BuildContext context) {
    return FilePicker.platform
        .pickFiles(
      allowMultiple: true,
      type: FileType.any,
    )
        .then((result) {
      if (result != null) {
        return result.paths.map((path) => File(path!)).toList();
      } else {
        return [];
      }
    });
  }

  void _previewFile(File file) async {
    if (file.path.toLowerCase().endsWith('.pdf')) {
      final Uri filePath = Uri.file(file.path);
      if (await canLaunchUrl(filePath)) {
        await launchUrl(filePath);
      } else {
        throw 'Não foi possível iniciar $filePath';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                DocumentDropdown(
                  selectedArquivo: selectedArquivo,
                  onArquivoChanged: (value) {
                    setState(() {
                      selectedArquivo = value;
                      if (value == 'Documentos') {
                        selectedYear = null;
                      }
                    });
                  },
                  showDateInput: selectedArquivo != null &&
                      selectedArquivo != 'Documentos',
                  onYearSelected: (String year) {
                    setState(() {
                      selectedYear = year;
                    });
                  },
                  tiposDocumentos:
                      tiposDocumentos, // Passando a lista de tipos de documentos
                ),
              const SizedBox(height: 20),
              DropTarget(
                onDragDone: (detail) async {
                  if (selectedArquivo != null) {
                    if (selectedArquivo != 'Documentos' &&
                        selectedYear == null) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                              'Por favor, selecione o ano.',
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
                      setState(() {
                        _files.addAll(
                            detail.files.map((xFile) => File(xFile.path)));
                      });
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text(
                            'Por favor, selecione um tipo de arquivo.',
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
                                      _previewFile(file);
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
                              style:
                                  TextStyle(fontSize: 20, color: Colors.grey),
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
                                _files.addAll(await pickFiles(context));
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                primary: Colors.white,
                                onPrimary: Colors.grey,
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
                        primary: Colors.red,
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
                          mapTipoDocumentoExibicaoToDescricao(selectedArquivo);
                      // ignore: unnecessary_null_comparison
                      if (tipoDocumentoDescricao == null ||
                          _files.isEmpty ||
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
                        for (File file in _files) {
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

                          await WsAccounting.uploadFile(
                              jsonData: {"contabilidade": accounting.toJson()},
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
        ),
      ],
    );
  }
}
