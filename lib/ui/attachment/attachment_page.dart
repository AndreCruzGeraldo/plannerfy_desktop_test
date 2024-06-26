// ignore_for_file: unused_field
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/model/commentary_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:intl/intl.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/components/company_dropdown.dart';

class AttachmentPage extends StatefulWidget {
  final String? selectedEmpresa;
  const AttachmentPage({Key? key, this.selectedEmpresa}) : super(key: key);

  @override
  _AttachmentPageState createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  late Future<List<CommentaryModel>> _futureDocuments;
  Uint8List? _pdfBytes;
  bool _isLoading = false;
  String? selectedEmpresa;
  bool empresaSelecionada = false;

  @override
  void initState() {
    _futureDocuments = _getDocuments();
    super.initState();
    selectedEmpresa = widget
        .selectedEmpresa; // Inicializa a empresa selecionada com o valor passado por parâmetro
    empresaSelecionada =
        selectedEmpresa != null; // Atualiza a flag empresaSelecionada
  }

  Future<List<CommentaryModel>> _getDocuments() async {
    UserManager userProvider = Provider.of<UserManager>(context, listen: false);
    String cnpj = userProvider.chosenCompany!.empCnpj;
    return WsDocuments().getDocuments(context, cnpj);
  }

  Future<String> _savePdf(Uint8List pdfBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/documento.pdf';
    final file = File(path);
    await file.writeAsBytes(pdfBytes);
    return path;
  }

  void _previewFile(File file) {
    if (file.path.toLowerCase().endsWith('.pdf')) {
      launch(file.path);
    } else {
      print('O arquivo não é um PDF.');
    }
  }

  void previewFile(CommentaryModel commentary) async {
    setState(() {
      _isLoading = true;
    });

    Uint8List? _pdfBytes = await WsDocuments()
        .getFileComentario(commentary.toJson()) as Uint8List?;

    setState(() {
      _isLoading = false;
    });

    if (_pdfBytes != null) {
      _previewFile(File(await _savePdf(_pdfBytes)));
    } else {
      print('Erro ao carregar o PDF.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Home > Solicitações'),
        backgroundColor: markPrimaryColor,
      ),
      body: Row(
        children: [
          // Lado esquerdo do app
          Expanded(
            flex: 4,
            child: Container(
              color: markPrimaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CompanyDropdown(
                          selectedEmpresa: selectedEmpresa,
                          enabled: false,
                          onEmpresaChanged: (empresa) {
                            setState(() {
                              selectedEmpresa = empresa;
                              empresaSelecionada = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 125),
                ],
              ),
            ),
          ),
          // Lado direito do app
          Expanded(
            flex: 6,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(56.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Image(
                            image: AssetImage('lib/assets/images/doc_log.png'),
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Lista de Comentarios/Documentos',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder<List<CommentaryModel>>(
                        future: _futureDocuments,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(), // Alteração aqui
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<CommentaryModel>? documents = snapshot.data;
                            return documents != null && documents.isNotEmpty
                                ? SizedBox(
                                    height: 550.0,
                                    child: ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        final documento = documents[index];
                                        // Formatando a data e hora
                                        String formattedDate =
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    documento.dataCriacao));
                                        String formattedHour =
                                            DateFormat('HH:mm').format(
                                                DateTime.parse(
                                                    documento.dataCriacao));

                                        return Card(
                                          child: InkWell(
                                            onTap: () {
                                              previewFile(documento);
                                            },
                                            child: ListTile(
                                              dense: true,
                                              title: ListTileTheme(
                                                dense: true,
                                                contentPadding: EdgeInsets.zero,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Image(
                                                              image: AssetImage(
                                                                  'lib/assets/images/doc.png'),
                                                              height: 40,
                                                              width: 40,
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Text(
                                                              documento.texto,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          17),
                                                            ),
                                                            const SizedBox(
                                                                height: 8),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          'Solicitação: ${documento.id}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Usuário: ${documento.usuario}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Data: $formattedDate',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                        Text(
                                                          'Hora: $formattedHour',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Text('Nenhum documento encontrado.');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
