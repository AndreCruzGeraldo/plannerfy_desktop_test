import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/document_manager.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import '../common/file_drop_target.dart';
import '../common/send_button.dart';
import '../home/components/company_dropdown.dart';
import '../home/home_page.dart';

class DocumentPage extends StatefulWidget {
  const DocumentPage({Key? key}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  final List<File> _files = [];
  bool _filesAdded = false;
  String? selectedEmpresa;
  bool empresaSelecionada = false;

  @override
  void initState() {
    super.initState();
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
          title: const Text('Home > Documentos'),
          backgroundColor: markPrimaryColor,
        ),
        body: Row(children: [
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
                        pickFiles: (context) =>
                            DocumentManager.pickFiles(context),
                        previewFile: (file) =>
                            DocumentManager.previewFile(file),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SendButton(
                            texto: "Enviar",
                            function: () => _uploadDocuments(context),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              )))
        ]));
  }

  _uploadDocuments(BuildContext context) async {
    if (_filesAdded) {
      for (File file in _files) {
        DocumentManager.uploadDocument(
          context: context,
          filePath: file.path.toString(),
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Atenção!'),
            content: const Text(
              'Por favor, adicione arquivos para enviar.',
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
  }
}
