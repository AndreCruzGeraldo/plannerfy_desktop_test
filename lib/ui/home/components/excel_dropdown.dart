import 'package:flutter/material.dart';

class ExcelDropdown extends StatelessWidget {
  final String? plataforma;
  final String? tipoArquivo;
  final void Function(String?) onPlataformaChanged;
  final void Function(String?) onTipoArquivoChanged;
  final bool showDateInput;
  final List<Map<String, dynamic>> tiposDocumentos;
  final List<Map<String, dynamic>> tiposPlataformas;

  static int currentYear = DateTime.now().year;

  const ExcelDropdown({
    Key? key,
    required this.plataforma,
    required this.tipoArquivo,
    required this.onPlataformaChanged,
    required this.onTipoArquivoChanged,
    this.showDateInput = true,
    required this.tiposDocumentos,
    required this.tiposPlataformas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 30.0,
                  alignment: Alignment.centerLeft,
                  value: plataforma,
                  items: tiposPlataformas.map((tipoPlataforma) {
                    final String? platformDisplay =
                        tipoPlataforma['plat_exibicao'] as String?;
                    return DropdownMenuItem<String>(
                      value: platformDisplay ?? '',
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Center(child: Text(platformDisplay ?? '')),
                      ),
                    );
                  }).toList(),
                  onChanged: onPlataformaChanged,
                  hint: plataforma != null
                      ? null
                      : const Center(
                          child: Text(
                            'Plataformas',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 30.0,
                  alignment: Alignment.centerLeft,
                  value: tipoArquivo,
                  items: tiposDocumentos.map((tipoDocumento) {
                    final String? docDisplay =
                        tipoDocumento['tipo_doc_exibicao'] as String?;
                    return DropdownMenuItem<String>(
                      value: docDisplay ?? '',
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Center(child: Text(docDisplay ?? '')),
                      ),
                    );
                  }).toList(),
                  onChanged: onTipoArquivoChanged,
                  hint: tipoArquivo != null
                      ? null
                      : const Center(
                          child: Text(
                            'Tipo de Arquivo',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
