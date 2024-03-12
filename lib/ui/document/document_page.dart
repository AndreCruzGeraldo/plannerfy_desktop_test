import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/document_manager.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import '../common/file_drop_target.dart';
import '../common/send_button.dart';
import '../home/components/company_dropdown.dart';

class DocumentPage extends StatefulWidget {
  final String? selectedEmpresa;
  const DocumentPage({Key? key, this.selectedEmpresa}) : super(key: key);

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  String? selectedEmpresa;
  bool empresaSelecionada = false;
  late DocumentManager documentProvider;

  @override
  void initState() {
    documentProvider = Provider.of<DocumentManager>(context, listen: false);
    super.initState();
    selectedEmpresa = widget.selectedEmpresa;
    empresaSelecionada = selectedEmpresa != null;
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
                      const SizedBox(height: 20),
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                      const FileDropTarget(),
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  _uploadDocuments(BuildContext context) async {
    if (documentProvider.files.isNotEmpty) {
      print("Chegou na função");
      for (File file in documentProvider.files) {
        DocumentManager.uploadDocument(
          context: context,
          filePath: file.path.toString(),
        );
      }
      documentProvider.files = [];
      Navigator.pop(context);
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
