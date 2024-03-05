import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/ui/home/components/document_tile.dart';

class FileDropTarget extends StatefulWidget {
  final Function(List<File>) onFilesDropped;
  final Future<Iterable<File>> Function(BuildContext) pickFiles;
  final void Function(File) previewFile;

  FileDropTarget({
    required this.onFilesDropped,
    required this.pickFiles,
    required this.previewFile,
  });

  @override
  _FileDropTargetState createState() => _FileDropTargetState();
}

class _FileDropTargetState extends State<FileDropTarget> {
  final List<File> _files = [];

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _files.addAll(detail.files.map((xFile) => File(xFile.path)));
          widget.onFilesDropped(_files);
        });
      },
      onDragUpdated: (detail) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localOffset = renderBox.globalToLocal(detail.globalPosition);
        
        });
      },
      onDragEntered: (detail) {
        setState(() {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localOffset = renderBox.globalToLocal(detail.globalPosition);
          
        });
      },
      onDragExited: (detail) {
        setState(() {
          // Handle drag exit if needed
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
                      _files.addAll(await widget.pickFiles(context));
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
