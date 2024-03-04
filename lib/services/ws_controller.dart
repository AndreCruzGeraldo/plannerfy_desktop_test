import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:plannerfy_desktop/services/queries/ws_company.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:plannerfy_desktop/services/queries/ws_users.dart';

import '../utility/app_config.dart';
import 'package:http/http.dart' as http;

class WsController with WsUsers, WsCompany, WsDocuments {
  static final WsController _singleton = WsController._internal();

  factory WsController() => _singleton;

  WsController._internal();

  static String url = 'http://54.94.0.212:4321';

  static Uri toUri(String query) => Uri().resolve(url + query);
  static String toUriS(String query) => url + query;

  static Future<bool> testConnection() async {
    try {
      MapSD response = await wsGet(query: '/user/ping');
      return response['ping'] == 'pong';
    } catch (e) {
      print(' === ERROR: $e === ');
      return false;
    }
  }

  static Future<MapSD> wsGet(
      {required String query,
      String body = '',
      Duration duration = const Duration(seconds: 15)}) async {
    // String returnValue;
    // String erro = '';
    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(url + query),
      );
      request.body = body;
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String jsonValue = await response.stream.bytesToString();
      return jsonDecode(jsonValue);
    } on TimeoutException catch (e) {
      print('connection: ${e.toString()}');
      return {'connection': e.toString()};
    } catch (e) {
      print("erro de conexão" + e.toString());
      return {'error': e.toString()};
    }
  }

  static Future<Object> wsGetFile(
      {required String query,
      String body = '',
      Duration duration = const Duration(seconds: 15)}) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var request = http.Request(
        'GET',
        Uri.parse(url + query),
      );
      request.body = body;
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      final file = await response.stream.toBytes();
      return file;
    } on TimeoutException catch (e) {
      print('connection: ${e.toString()}');
      return {'connection': e.toString()};
    } catch (e) {
      print("erro de conexão" + e.toString());
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> wsPost({
    required String query,
    required String body,
    Duration duration = const Duration(seconds: 15),
  }) async {
    var headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    try {
      var request = http.Request('POST', Uri.parse(url + query));
      request.body = body;
      request.headers.addAll(headers);
      var response = await http.Client().send(request);
      var returnValue = await utf8.decodeStream(response.stream);
      return jsonDecode(returnValue);
    } on TimeoutException catch (e) {
      print('connection: ${e.toString()}');
      return {'connection': e.toString()};
    } catch (e) {
      print("error de conexão" + e.toString());
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> wsPostFile({
    required String query,
    required Map<String, dynamic> formData,
    required Uint8List
        fileBytes, // Adicione este parâmetro para os bytes do arquivo
    Duration duration = const Duration(seconds: 15),
  }) async {
    var headers = {
      "Content-Type": "multipart/form-data",
    };

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url + query));
      request.headers.addAll(headers);

      // Adicione os dados do formulário como partes do formulário
      request.fields.addAll({
        'json': jsonEncode(formData),
      });

      // Adicione os bytes do arquivo como um campo de arquivo
      request.files.add(
          http.MultipartFile.fromBytes('file', fileBytes, filename: 'file'));

      // Envie a solicitação
      var response = await request.send();

      // Leia a resposta
      var returnValue = await utf8.decodeStream(response.stream);
      return jsonDecode(returnValue);
    } on TimeoutException catch (e) {
      print('connection: ${e.toString()}');
      return {'connection': e.toString()};
    } catch (e) {
      print("error de conexão" + e.toString());
      return {'error': e.toString()};
    }
  }
}
