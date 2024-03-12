import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/document_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:provider/provider.dart';

class DocumentManager extends ChangeNotifier {
  List<File> files = [];

  static Future<void> uploadDocument({
    required BuildContext context,
    required String filePath,
  }) async {
    UserManager userManager = Provider.of<UserManager>(context, listen: false);

    String fileName = filePath.split('\\').last;

    DocumentModel document = DocumentModel(
      docCnpj: userManager.chosenCompany!.empCnpj,
      docId: 0,
      docNome: fileName,
      docDescricao: fileName,
      docPath: fileName,
      docUsuario: userManager.user!.email,
      docDataCadastro: DateTime.now().toString(),
      docStatus: "A",
    );

    await WsDocuments.uploadFile(
      jsonData: {"documento": document.toJson()},
      filePath: filePath,
    );
    print({"documento": document.toJson()});
  }

  static Future<List<File>> pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );
    print(result?.files.length);
    final files = result?.files.map((file) => File(file.path ?? '')).toList();
    return files ?? [];
  }

  static Future<void> previewFile(File file) async {
    try {
      final filePath = file.path;
      final process = await Process.start(filePath, [], runInShell: true);
      await process.exitCode;
    } catch (e) {
      print('Failed to open file: $e');
      throw e;
    }
  }
}
