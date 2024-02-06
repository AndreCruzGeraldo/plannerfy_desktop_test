import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plannerfy_desktop/services/ws_controller.dart';

class WsDocuments {
  static Future<void> uploadFile({
    required Map<String, dynamic> jsonData,
    required String filePath,
  }) async {
    var url = WsController.toUriS('/documento/uploadFile');
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['json'] = jsonEncode(jsonData);

    var file = File(filePath);
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var response = await request.send();
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
