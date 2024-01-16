import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class ArquivoContent extends StatelessWidget {
  final List<Map<String, dynamic>> documentos = [
    {
      'id': '123',
      'nome': 'Documento 1.pdf',
      'data': '10/01/2022',
      'hora': '14:30',
      'usuario': 'João Silva',
      'tamanho': '2.5 MB',
    },
    {
      'id': '124',
      'nome': 'Documento 2.pdf',
      'data': '11/01/2022',
      'hora': '16:45',
      'usuario': 'Maria Oliveira',
      'tamanho': '1.8 MB',
    },
    {
      'id': '133',
      'nome': 'Documento 3.pdf',
      'data': '12/01/2022',
      'hora': '10:15',
      'usuario': 'Carlos Pereira',
      'tamanho': '3.2 MB',
    },
    {
      'id': '223',
      'nome': 'Documento 4.pdf',
      'data': '13/01/2022',
      'hora': '09:00',
      'usuario': 'Ana Souza',
      'tamanho': '2.0 MB',
    },
    {
      'id': '127',
      'nome': 'Documento 5.pdf',
      'data': '14/01/2022',
      'hora': '18:20',
      'usuario': 'Lucas Santos',
      'tamanho': '4.5 MB',
    },
    {
      'id': '623',
      'nome': 'Documento 6.pdf',
      'data': '15/01/2022',
      'hora': '11:30',
      'usuario': 'Isabel Lima',
      'tamanho': '2.8 MB',
    },
    {
      'id': '983',
      'nome': 'Documento 7.pdf',
      'data': '16/01/2022',
      'hora': '15:10',
      'usuario': 'Felipe Costa',
      'tamanho': '3.7 MB',
    },
    {
      'id': '059',
      'nome': 'Documento 8.pdf',
      'data': '17/01/2022',
      'hora': '13:45',
      'usuario': 'Amanda Almeida',
      'tamanho': '2.3 MB',
    },
    {
      'id': '789',
      'nome': 'Documento 9.pdf',
      'data': '18/01/2022',
      'hora': '14:55',
      'usuario': 'Ricardo Martins',
      'tamanho': '1.5 MB',
    },
    {
      'id': '521',
      'nome': 'Documento 10.pdf',
      'data': '19/01/2022',
      'hora': '08:40',
      'usuario': 'Fernanda Rocha',
      'tamanho': '3.0 MB',
    },
  ];

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
          Container(
            height: 550.0,
            child: ListView.builder(
              itemCount: documentos.length,
              itemBuilder: (context, index) {
                final documento = documentos[index];
                return Card(
                  child: ListTile(
                    dense: true,
                    title: ListTileTheme(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Image(
                                    image:
                                        AssetImage('lib/assets/images/doc.png'),
                                    height: 40,
                                    width: 40,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    documento['nome'],
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tamanho: ${documento['tamanho']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Solicitação: ${documento['id']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Usuário: ${documento['usuario']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Data: ${documento['data']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Hora: ${documento['hora']}',
                                style: const TextStyle(fontSize: 14),
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
