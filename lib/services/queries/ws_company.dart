import 'package:plannerfy_desktop/models/empresa_model.dart';
import 'package:plannerfy_desktop/services/ws_controller.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class WsCompany {
  Future<List<Empresa>> getCompany() async {
    List<Empresa> empresas = [];

    try {
      MapSD response = await WsController.wsGet(
        query: "/empresa/getEmpresas",
      );

      // print('Raw Web Service Response: $response');

      if (response.containsKey('error') ||
          response.containsKey('connection') ||
          response.isEmpty) {
        return [];
      }

      response["empresas"].forEach((element) {
        empresas.add(Empresa.fromJson(element));
      });

      return empresas;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
