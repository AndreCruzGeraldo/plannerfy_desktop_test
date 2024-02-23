import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plannerfy_desktop/services/ws_controller.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:plannerfy_desktop/models/commentary_model.dart';

class WsDocuments {
  Future<List<CommentaryModel>> getDocuments(String cnpj) async {
    String cnpj = '45391108000190';
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
    print("Esta rodando");
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://54.94.0.212:4321/documento/uploadFile'));

    request.fields.addAll({
      'json': jsonEncode(jsonData),
    });

    var file = File(filePath);
    if (!file.existsSync()) {
      print('File not found: ${file.path}');
      return;
    }

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error uploading file: $e");
    }
  }
}
