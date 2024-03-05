import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/document_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:provider/provider.dart';

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
}
