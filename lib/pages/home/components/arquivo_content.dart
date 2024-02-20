import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/models/document_model.dart';
import 'package:plannerfy_desktop/services/queries/ws_documents.dart';
import 'package:plannerfy_desktop/pages/home/home_page.dart';
import 'package:intl/intl.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class ArquivoContent extends StatefulWidget {
  const ArquivoContent({Key? key}) : super(key: key);

  @override
  _ArquivoContentState createState() => _ArquivoContentState();
}

class _ArquivoContentState extends State<ArquivoContent> {
  late Future<List<DocumentModel>> _futureDocuments;

  @override
  void initState() {
    super.initState();
    _futureDocuments = _getDocuments();
  }

  Future<List<DocumentModel>> _getDocuments() async {
    // Aqui você pode passar o CNPJ adequado
    String cnpj = '';
    return WsDocuments().getDocuments(cnpj);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Image(
                image: AssetImage('lib/assets/images/doc_log.png'),
                height: 50,
                width: 50,
              ),
              SizedBox(width: 10),
              Text(
                'Lista de Documentos',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          FutureBuilder<List<DocumentModel>>(
            future: _futureDocuments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(), // Alteração aqui
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<DocumentModel>? documents = snapshot.data;
                return documents != null && documents.isNotEmpty
                    ? SizedBox(
                        height: 550.0,
                        child: ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final documento = documents[index];
                            // Formatando a data e hora
                            String formattedDate = DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(documento.dataCriacao));
                            String formattedHour = DateFormat('HH:mm')
                                .format(DateTime.parse(documento.dataCriacao));

                            return Card(
                              child: ListTile(
                                dense: true,
                                title: ListTileTheme(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Image(
                                                image: AssetImage(
                                                    'lib/assets/images/doc.png'),
                                                height: 40,
                                                width: 40,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                documento.texto,
                                                style: const TextStyle(
                                                    fontSize: 17),
                                              ),
                                              const SizedBox(height: 8),
                                              // Aqui listava o tamanho do JSON que tinha
                                              // Text(
                                              //   'Tamanho: ${documento.tamanho}',
                                              //   style: const TextStyle(
                                              //       fontSize: 14),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Solicitação: ${documento.id}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Usuário: ${documento.usuario}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          // Exibindo a data e a hora formatadas
                                          Text(
                                            'Data: $formattedDate',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Hora: $formattedHour',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
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
          const SizedBox(height: 30.0),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(250, 60),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Voltar',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
