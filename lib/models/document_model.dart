import 'package:plannerfy_desktop/utility/app_config.dart';

class DocumentModel {
  late final String docCnpj;
  late final int docId;
  late final String docNome;
  late final String docDescricao;
  late final String docPath;
  late final String docUsuario;
  late final String docDataCadastro;
  late final String docStatus;

  DocumentModel({
    required this.docCnpj,
    required this.docId,
    required this.docNome,
    required this.docDescricao,
    required this.docPath,
    required this.docUsuario,
    required this.docDataCadastro,
    required this.docStatus,
  });

  DocumentModel.fromJson(MapSD json) {
    docCnpj = json['doc_cnpj'];
    docId = json['doc_id'];
    docNome = json['doc_nome'];
    docDescricao = json['doc_descricao'];
    docPath = json['doc_path'];
    docUsuario = json['doc_usuario'];
    docDataCadastro = json['doc_data_cadastro'];
    docStatus = json['doc_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_cnpj': docCnpj,
      'doc_id': docId,
      'doc_nome': docNome,
      'doc_descricao': docDescricao,
      'doc_path': docPath,
      'doc_usuario': docUsuario,
      'doc_data_cadastro': docDataCadastro,
      'doc_status': docStatus,
    };
  }
}
