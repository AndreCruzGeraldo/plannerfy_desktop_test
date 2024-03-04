import 'package:plannerfy_desktop/utility/app_config.dart';

class AccountingModel {
  String cnpj = "";
  int id = 0;
  int ano = 0;
  String tipoArquivo = "";
  String nome = "";
  String descricao = "";
  String path = "";
  String usuario = "";
  String dataCadastro = DateTime.now().toString();
  String status = "";

  AccountingModel({
    required this.cnpj,
    required this.id,
    required this.ano,
    required this.tipoArquivo,
    required this.nome,
    required this.descricao,
    required this.path,
    required this.usuario,
    required this.dataCadastro,
    required this.status,
  });

  AccountingModel.fromJson(MapSD json) {
    cnpj = json['con_cnpj'] ?? "";
    id = json['con_id'] ?? 0;
    ano = json['con_ano'] ?? 0;
    tipoArquivo = json['con_tipo_arquivo'] ?? "";
    nome = json['con_nome'] ?? "";
    descricao = json['con_descricao'] ?? "";
    path = json['con_path'] ?? "";
    usuario = json['con_usuario'] ?? "";
    dataCadastro = json['con_data_cadastro'] ?? "";
    status = json['con_status'] ?? "";
  }

  MapSD toJson() {
    return {
      'con_cnpj': cnpj,
      'con_id': id,
      'con_ano': ano,
      'con_tipo_arquivo': tipoArquivo,
      'con_nome': nome,
      'con_descricao': descricao,
      'con_path': path,
      'con_usuario': usuario,
      'con_data_cadastro': dataCadastro,
      'con_status': status,
    };
  }
}
