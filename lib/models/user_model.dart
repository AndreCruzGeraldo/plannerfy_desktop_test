import 'empresa_model.dart';

class UserModel {
  DateTime dataCadastro = DateTime.now();
  String status = "";
  String cpf = "";
  String senha = "";
  String fone = "";
  String email = "";
  DateTime dataBloqueio = DateTime.now();
  String nome = "";
  String tipo = "";
  List<Empresa>? empresasVinculadas = [];

  UserModel({
    required this.dataCadastro,
    required this.status,
    required this.cpf,
    required this.senha,
    required this.fone,
    required this.email,
    required this.dataBloqueio,
    required this.nome,
    required this.tipo,
    this.empresasVinculadas,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    dataCadastro = DateTime.parse(json["user_data_cadastro"]);
    dataBloqueio = DateTime.parse(json["user_data_bloqueio"]);
    status = json["user_status"];
    cpf = json["user_cpf"];
    fone = json["user_telefone"];
    senha = json["user_senha"];
    email = json["user_email"];
    nome = json["user_nome"];
    tipo = json["user_tipo_usuario"];

    if (json['empresas'] != null) {
      empresasVinculadas = List<Empresa>.from(
        json['empresas'].map((empresaJson) => Empresa.fromJson(empresaJson)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "user_data_cadastro": dataCadastro.toString(),
      "user_status": status,
      "user_cpf": cpf,
      "user_senha": senha,
      "user_telefone": fone,
      "user_email": email,
      "user_data_bloqueio": dataBloqueio.toString(),
      "user_nome": nome,
      "user_tipo_usuario": tipo,
      'empresas':
          empresasVinculadas?.map((empresa) => empresa.toJson()).toList(),
    };
  }
}
