import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/document_dropdown.dart';
import 'package:plannerfy_desktop/pages/home/components/document_tile.dart';
import 'package:plannerfy_desktop/pages/home/components/send_button.dart';
import 'package:plannerfy_desktop/pages/home/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cross_file/cross_file.dart';

class UploadContent extends StatefulWidget {
  const UploadContent({Key? key}) : super(key: key);

  @override
  State<UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  String? selectedEmpresa;
  String? selectedArquivo;
  String? selectedYear;

  int numero = 0;

  final List<XFile> _list = [];

  Offset? offset;

  // Abre explorador de arquivos e permite escolher um arquivo
  Future<void> _openFilePicker() async {
    if (selectedArquivo != null) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _list.addAll(result.files.map((file) => XFile(file.path!)));
        });
      }
    }
  }

  // Abre arquivos de pdf no computador
  void _previewFile(XFile file) async {
    if (file.path.toLowerCase().endsWith('.pdf')) {
      // Use Uri.file to create a URI from the file path
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
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            showDateInput:
                selectedArquivo != null && selectedArquivo != 'Documentos',
            onYearSelected: (String year) {
              setState(() {
                selectedYear = year;
              });
            },
          ),
          const SizedBox(height: 20),
          DropTarget(
            onDragDone: (detail) async {
              if (selectedArquivo != null) {
                setState(() {
                  _list.addAll(detail.files);
                });
              } else {
                // Caso arquivo seja null
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(
                        'Por favor, selecione um tipo de arquivo',
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
                      if (_list.isEmpty)
                        const SizedBox(
                          height: 20,
                        ),
                      if (_list.isNotEmpty)
                        SizedBox(
                          height: 250,
                          child: ListView.separated(
                            itemCount: _list.length,
                            separatorBuilder: (context, index) =>
                                const Divider(color: Colors.grey),
                            itemBuilder: (context, index) {
                              final file = _list[index];
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
                                          documentName: file.name,
                                          fileSize: fileSize,
                                          onDelete: () {
                                            setState(() {
                                              _list.removeAt(index);
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
                        width: 200,
                        child: ElevatedButton(
                          onPressed: _openFilePicker,
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
                            children: const [
                              Icon(Icons.upload),
                              SizedBox(width: 10.0),
                              Text(
                                'Selecionar Arquivo',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SendButton(
            texto: "Enviar",
            login: () {
              if (selectedArquivo == null ||
                  _list.isEmpty ||
                  (selectedArquivo != 'Documentos' && selectedYear == null)) {
                // Verifica o ano se não for um documento
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Atenção!'),
                      content: const Text(
                          'Por favor, selecione o tipo de arquivo, ano e adicione arquivos.'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
