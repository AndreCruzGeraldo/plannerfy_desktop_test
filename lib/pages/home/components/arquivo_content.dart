import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class ArquivoContent extends StatelessWidget {
  final List<String> documentos = [
    'Documento 1',
    'Documento 2',
    'Documento 3',
    'Documento 4',
    'Documento 5',
    'Documento 6',
    'Documento 7',
    'Documento 8',
    'Documento 9',
    'Documento 10',
    'Documento 11',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(56.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lista de Documentos:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10.0),
          Container(
            height: 500.0,
            child: ListView.builder(
              itemCount: documentos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    dense: true,
                    title: ListTileTheme(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.file_copy_outlined,
                            size: 16,
                            color: markPrimaryColor,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                documentos[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                              // Adapte conforme necessário para incluir tamanho do arquivo
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30.0),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
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
                    Icon(Icons.home),
                    SizedBox(width: 10.0),
                    Text(
                      'Home',
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
