import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/document_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';

class SpreadsheetManager extends ChangeNotifier {
  List<File> files = [];
  
  static Future<void> uploadSpreadsheet({
    required BuildContext context,
    required String filePath,
  }) async {
    UserManager userManager = Provider.of<UserManager>(context, listen: false);

    String fileName = filePath.split('\\').last;

    MapSD jsonData = DocumentModel(
            docCnpj: userManager.chosenCompany!.empCnpj,
            docId: 0,
            docNome: fileName,
            docDescricao: fileName,
            docPath: fileName,
            docUsuario: userManager.user!.email,
            docDataCadastro: DateTime.now().toString(),
            docStatus: "A")
        .toJson();

    await WsDocuments.uploadFile(jsonData: jsonData, filePath: filePath);
  }

  static Future<Iterable<File>> pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return [];
    }
  }
}
