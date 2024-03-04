import 'package:plannerfy_desktop/utility/app_config.dart';

class Company {
  String empCnpj = "";
  String empDataCadastro = "";
  String empRazaoSocial = "";
  String empStatus = "";
  String empCep = "";
  String empNomeFantasia = "";
  String empCidade = "";
  String empDataBloqueio = "";
  String empEndereco = "";

  Company({
    required this.empCnpj,
    required this.empDataCadastro,
    required this.empRazaoSocial,
    required this.empStatus,
    required this.empCep,
    required this.empNomeFantasia,
    required this.empCidade,
    required this.empDataBloqueio,
    required this.empEndereco,
  });

  Company.fromJson(MapSD json) {
    empCnpj = json["emp_cnpj"];
    empDataCadastro = json["emp_data_cadastro"];
    empRazaoSocial = json["emp_razao_social"];
    empStatus = json["emp_status"];
    empCep = json["emp_cep"];
    empNomeFantasia = json["emp_nome_fantasia"];
    empCidade = json["emp_cidade"];
    empDataBloqueio = json["emp_data_bloqueio"];
    empEndereco = json["emp_endereco"];
  }

  MapSD toJson() {
    return {
      "emp_cnpj": empCnpj,
      "emp_data_cadastro": empDataCadastro,
      "emp_razao_social": empRazaoSocial,
      "emp_status": empStatus,
      "emp_cep": empCep,
      "emp_nome_fantasia": empNomeFantasia,
      "emp_cidade": empCidade,
      "emp_data_bloqueio": empDataBloqueio,
      "emp_endereco": empEndereco,
    };
  }
}
