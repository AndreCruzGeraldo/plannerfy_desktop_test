import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'document_tile.dart';

class FileDropTarget extends StatefulWidget {
  final Function(List<File>) onFilesDropped;
  final Function(bool) onFilesAdded;
  final Future<Iterable<File>> Function(BuildContext) pickFiles;
  final void Function(File) previewFile;

  const FileDropTarget({
    Key? key,
    required this.onFilesDropped,
    required this.onFilesAdded,
    required this.pickFiles,
    required this.previewFile,
  }) : super(key: key);
  @override
  _FileDropTargetState createState() => _FileDropTargetState();
}

class _FileDropTargetState extends State<FileDropTarget> {
  final List<File> _files = [];
  bool _isDraggingOver = false;
  bool _filesAdded = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _files.addAll(detail.files.map((xFile) => File(xFile.path)));
          widget.onFilesDropped(_files);
          _filesAdded = true;
          widget.onFilesAdded(_filesAdded);
        });
      },
      // Other drag callbacks
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
                        return GestureDetector(
                          onTap: () {
                            widget.previewFile(file);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: FutureBuilder<int>(
                              future: file.length(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final fileSize = snapshot.data ?? 0;
                                  return DocumentTile(
                                    documentName: file.path.split('/').last,
                                    fileSize: fileSize,
                                    onDelete: () {
                                      setState(() {
                                        _files.removeAt(index);
                                        if (_files.isEmpty) {
                                          _filesAdded = false;
                                          widget.onFilesAdded(_filesAdded);
                                        }
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
                if (_files.isEmpty &&
                    !_isDraggingOver) // Esta condição esconde o texto enquanto o usuário estiver arrastando um arquivo
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
                    onPressed: () async {
                      _files.addAll(await widget.pickFiles(context));
                      setState(() {
                        _filesAdded = true;
                        widget.onFilesAdded(_filesAdded);
                      });
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
}
