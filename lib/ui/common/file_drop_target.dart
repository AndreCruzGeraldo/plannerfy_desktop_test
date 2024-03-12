import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/accounting_manager.dart';
import 'package:plannerfy_desktop/manager/document_manager.dart';
import 'package:plannerfy_desktop/manager/spreadsheet_manager.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';

import 'document_tile.dart';

class FileDropTarget extends StatefulWidget {
  final TipoArquivo tipo;
  const FileDropTarget({Key? key, required this.tipo}) : super(key: key);
  @override
  _FileDropTargetState createState() => _FileDropTargetState();
}

class _FileDropTargetState extends State<FileDropTarget> {
  late DocumentManager documentProvider;
  late AccountingManager accountingProvider;
  late SpreadsheetManager spreadsheatProvider;
  final List<File> _files = [];

  @override
  void initState() {
    documentProvider = Provider.of<DocumentManager>(context, listen: false);
    accountingProvider = Provider.of<AccountingManager>(context, listen: false);
    spreadsheatProvider =
        Provider.of<SpreadsheetManager>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      onDragDone: (detail) async {
        if (detail.files.isNotEmpty) {
          final newFiles = detail.files.map((file) => File(file.path)).toList();
          documentProvider.files.addAll(newFiles);
          setState(() {
            _files.addAll(newFiles);
          });
        }
      },
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                    height: 200,
                    child: ListView.separated(
                      itemCount: _files.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        final fileSize = file.lengthSync();
                        return DocumentTile(
                          documentName: file.path.split('/').last,
                          fileSize: fileSize,
                          onDelete: () {
                            _onDelete(index);
                          },
                          onTap: () {
                            DocumentManager.previewFile(file);
                          },
                        );
                      },
                    ),
                  ),
                // if (_files.isEmpty &&
                //     !_isDraggingOver)
                const Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Arraste e solte os arquivos aqui",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                    Text(
                      "ou",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    onPressed: () async {
                      List<File> pickedFiles =
                          await DocumentManager.pickFiles(context);
                      switch (widget.tipo) {
                        case TipoArquivo.CONTABILIDADE:
                          if (pickedFiles.isNotEmpty) {
                            accountingProvider.files.addAll(pickedFiles);
                            setState(() {
                              _files.addAll(pickedFiles);
                            });
                          }
                          break;
                        case TipoArquivo.DOCUMENTO:
                          if (pickedFiles.isNotEmpty) {
                            documentProvider.files.addAll(pickedFiles);
                            setState(() {
                              _files.addAll(pickedFiles);
                            });
                          }
                          break;
                        case TipoArquivo.PLANILHA:
                          if (pickedFiles.isNotEmpty) {
                            spreadsheatProvider.files.addAll(pickedFiles);
                            setState(() {
                              _files.addAll(pickedFiles);
                            });
                          }
                          break;
                      }
                    },
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDelete(int index) {
    setState(() {
      _files.removeAt(index);
      documentProvider.files.removeAt(index);
    });
  }
}
