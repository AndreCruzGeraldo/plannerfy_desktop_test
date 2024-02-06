import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class WsDocuments {
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




// class WsDocuments {
//   static Future<void> uploadFile() async {
//     print("Esta rodando");
//     var request = http.MultipartRequest(
//         'POST', Uri.parse('http://54.94.0.212:4321/documento/uploadFile'));

//     request.fields.addAll({
//       'json': jsonEncode({
//         "documento": {
//           "doc_cnpj": "45391108000190",
//           "doc_id": 12,
//           "doc_nome": "TesteFinal",
//           "doc_descricao": "Tomare que funfe",
//           "doc_path": 'teste.pdf',
//           "doc_usuario": "fredericohi18@gmail.com",
//           "doc_data_cadastro": "2024-02-06 12:00:00.0",
//           "doc_status": "A"
//         }
//       })
//     });


//     var file = File('C:/Users/usuario/Downloads/teste.pdf');
//     if (!file.existsSync()) {
//       print('File not found: ${file.path}');
//       return;
//     }

//     request.files.add(await http.MultipartFile.fromPath('file', file.path));

//     try {
//       http.StreamedResponse response = await request.send();
//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//       } else {
//         print('Upload failed with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error uploading file: $e");
//     }
//   }
// }

