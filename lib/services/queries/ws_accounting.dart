import 'dart:io';
import 'dart:typed_data';

import 'package:plannerfy_desktop/services/ws_controller.dart';

class WsAccounting {
  Future<void> getTiposDocumentos() async {
    try {
      final response =
          await WsController.wsGet(query: '/contabilidade/getTiposDocumentos');

      // Verificando se a resposta foi bem-sucedida
      if (response.containsKey('error')) {
        print('Error: ${response['error']}');
      } else {
        final tiposDocumentos = response['tiposDocumentos'];
        print('Tipos de Documentos: $tiposDocumentos');
      }
    } catch (e) {
      print('Error: $e');
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
        query: '/contabilidade/uploadFile',
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
