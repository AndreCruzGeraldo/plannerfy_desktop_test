import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/services/ws_controller.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:plannerfy_desktop/model/commentary_model.dart';
import 'package:provider/provider.dart';

class WsDocuments {
  Future<List<CommentaryModel>> getDocuments(context, String cnpj) async {
    UserManager userProvider = Provider.of<UserManager>(context, listen: false);
    String cnpj = userProvider.chosenCompany!.empCnpj;
    List<CommentaryModel> documentsList = [];
    try {
      MapSD response = await WsController.wsGet(
        query: "/solicitacao/getDocumentos",
        body: jsonEncode({"cnpj": cnpj}),
      );

      if (response.containsKey('error') ||
          response.containsKey('connection') ||
          response.isEmpty) {
        return [];
      }

      List<dynamic> documentData = response["comentarios"] ?? [];

      documentsList =
          documentData.map((data) => CommentaryModel.fromJson(data)).toList();

      return documentsList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Object> getFileComentario(MapSD json) async {
    MapSD object = json;
    try {
      final response = await WsController.wsGetFile(
          query: "/comentario/getFile", body: jsonEncode(object));
      return response;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<void> uploadFile({
    required Map<String, dynamic> jsonData,
    required String filePath,
  }) async {
    try {
      var file = File(filePath);
      if (!file.existsSync()) {
        print('File not found: ${file.path}');
        return;
      }

      // Obtenha os bytes do arquivo
      Uint8List fileBytes = await file.readAsBytes();

      // Chame o método wsPostFile do WsController
      var response = await WsController.wsPostFile(
        query: '/documento/uploadFile',
        formData: jsonData,
        fileBytes: fileBytes,
      );

      // Log da resposta completa
      print('Response: $response');

      // Verifique o status da resposta
      if (response.containsKey('statusCode') && response['statusCode'] == 200) {
        print('Upload successful');
      } else if (response.containsKey('status') && response['status'] == 'ok') {
        print('Upload successful: ${response['message']}');
      } else {
        print('Upload failed with status code: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
