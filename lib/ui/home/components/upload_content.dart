import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/document_manager.dart';
import 'package:plannerfy_desktop/ui/home/components/file_drop_target.dart';
import 'package:plannerfy_desktop/ui/home/components/send_button.dart';
import 'package:plannerfy_desktop/ui/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class UploadContent extends StatefulWidget {
  const UploadContent({Key? key}) : super(key: key);

  @override
  State<UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  final List<File> _files = [];
  bool _filesAdded = false;
  late DocumentManager documentManager;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
              pickFiles: (context) => DocumentManager.pickFiles(context),
              previewFile: (file) => DocumentManager.previewFile(file),
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
                    if (!_filesAdded) {
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
                    } else {
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
