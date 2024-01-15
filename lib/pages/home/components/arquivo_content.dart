import 'package:flutter/material.dart';

class SolicitacoesContent extends StatefulWidget {
  const SolicitacoesContent({Key? key}) : super(key: key);

  @override
  State<SolicitacoesContent> createState() => _SolicitacoesContentState();
}

int numero = 0;

class _SolicitacoesContentState extends State<SolicitacoesContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Número: $numero",
            style: const TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    numero++;
                  });
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (numero > 0) {
                      numero--;
                    }
                  });
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
