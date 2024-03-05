import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/document_manager.dart';
import 'package:plannerfy_desktop/ui/home/components/file_drop_target.dart';
import 'package:plannerfy_desktop/ui/home/components/send_button.dart';
import 'package:plannerfy_desktop/ui/home/home_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadContent extends StatefulWidget {
  const UploadContent({Key? key}) : super(key: key);

  @override
  State<UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  final List<File> _files = [];
  bool _filesAdded = false;

  @override
  void initState() {
    super.initState();
  }

  Future<Iterable<File>> pickFiles(BuildContext context) {
    return FilePicker.platform
        .pickFiles(
      allowMultiple: true,
      type: FileType.any,
    )
        .then((result) {
      final files = result?.files.map((file) => File(file.path ?? ''));
      setState(() {
        _files.addAll(files ?? []);
        _filesAdded = _files.isNotEmpty;
      });
      return files ?? [];
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
                pickFiles: pickFiles,
                previewFile: _previewFile,
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
        ),
      ],
    );
  }
}
