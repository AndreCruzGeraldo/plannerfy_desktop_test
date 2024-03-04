import 'package:plannerfy_desktop/utility/app_config.dart';

class CommentaryModel {
  String status = "";
  String cnpj = "";
  int solicitacaoId = 0;
  String usuario = "";
  String dataCriacao = "";
  String path = "";
  String texto = "";
  int id = 0;
  String origem = "";

  CommentaryModel({
    required this.status,
    required this.cnpj,
    required this.solicitacaoId,
    required this.usuario,
    required this.dataCriacao,
    required this.path,
    required this.texto,
    required this.id,
    required this.origem,
  });

  CommentaryModel.fromJson(MapSD json) {
    status = json["com_status"];
    cnpj = json["com_cnpj"];
    solicitacaoId = json["com_solicitacao_id"];
    usuario = json["com_usuario"];
    dataCriacao = json["com_data_criacao"];
    path = json["com_path"];
    texto = json["com_texto"];
    id = json["com_id"];
    origem = json["com_origem"];
  }

  Map<String, dynamic> toJson() {
    return {
      "com_status": status,
      "com_cnpj": cnpj,
      "com_solicitacao_id": solicitacaoId,
      "com_usuario": usuario,
      "com_data_criacao": dataCriacao,
      "com_path": path,
      "com_texto": texto,
      "com_id": id,
      "com_origem": origem,
    };
  }
}
