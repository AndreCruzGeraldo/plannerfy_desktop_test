import 'package:plannerfy_desktop/utility/app_config.dart';

class SpreadsheetModel {
  String syncCnpj = "";
  int syncId = 0;
  String syncPlataforma = "";
  String syncTipoArquivo = "";
  String syncPath = "";
  String syncUsuario = "";
  String syncDataCadastro = DateTime.now().toString();
  String syncStatus = "";

  SpreadsheetModel({
    required this.syncCnpj,
    required this.syncId,
    required this.syncPlataforma,
    required this.syncTipoArquivo,
    required this.syncPath,
    required this.syncUsuario,
    required this.syncDataCadastro,
    required this.syncStatus,
  });

  SpreadsheetModel.fromJson(MapSD json) {
    syncCnpj = json['sync_cnpj'] ?? '';
    syncId = json['sync_id'] ?? 0;
    syncPlataforma = json['sync_plataforma'] ?? '';
    syncTipoArquivo = json['sync_tipo_arquivo'] ?? '';
    syncPath = json['sync_path'] ?? '';
    syncUsuario = json['sync_usuario'] ?? '';
    syncDataCadastro = json['sync_data_cadastro'] ?? '';
    syncStatus = json['sync_status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'sync_cnpj': syncCnpj,
      'sync_id': syncId,
      'sync_plataforma': syncPlataforma,
      'sync_tipo_arquivo': syncTipoArquivo,
      'sync_path': syncPath,
      'sync_usuario': syncUsuario,
      'sync_data_cadastro': syncDataCadastro,
      'sync_status': syncStatus,
    };
  }
}
