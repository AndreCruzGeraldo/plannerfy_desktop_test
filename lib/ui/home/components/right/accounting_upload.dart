import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/accounting_manager.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/accounting_model.dart';
import 'package:plannerfy_desktop/ui/home/components/right/document_dropdown.dart';
import 'package:plannerfy_desktop/ui/home/components/right/file_drop_target.dart';
import 'package:plannerfy_desktop/ui/home/components/right/send_button.dart';
import 'package:plannerfy_desktop/ui/home/home_page.dart';
import 'package:plannerfy_desktop/services/queries/ws_accounting.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';

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
  // ignore: unused_field
  bool _filesAdded = false;

  int numero = 0;

  Offset? offset;

  @override
  void initState() {
    super.initState();
    userManager = Provider.of<UserManager>(context, listen: false);
    _loadTiposDocumentos();
  }

//-------------- REFATORAR ESSA PARTE ---- INICIO --------------------------------------
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
//-------------- REFATORAR ESSA PARTE---- FIM --------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
                    tiposDocumentos, 
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
              pickFiles: (context) => AccountingManager.pickFiles(context),
              previewFile: (file) => AccountingManager.previewFile(file),
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
      ],
    );
  }
}
