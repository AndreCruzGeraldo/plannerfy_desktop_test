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
}
