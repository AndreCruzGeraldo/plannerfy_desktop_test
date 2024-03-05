import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/document_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentManager {
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
  }

  static Future<Iterable<File>> pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    final files = result?.files.map((file) => File(file.path ?? ''));
    return files ?? [];
  }

  static Future<void> previewFile(File file) async {
    if (file.path.toLowerCase().endsWith('.pdf')) {
      final Uri filePath = Uri.file(file.path);
      if (await canLaunchUrl(filePath)) {
        await launchUrl(filePath);
      } else {
        throw 'Não foi possível iniciar $filePath';
      }
    }
  }
}
