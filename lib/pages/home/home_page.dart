import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_btn.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

import '../login/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedValue;
  List<DropdownMenuItem<String>> list = [
    DropdownMenuItem<String>(
      value: 'Documentos',
      child: Text('Documentos'),
    ),
    DropdownMenuItem<String>(
      value: 'Contrato social',
      child: Text('Contrato social'),
    ),
    DropdownMenuItem<String>(
      value: 'DRE Contabil',
      child: Text('DRE Contabil'),
    ),
    DropdownMenuItem<String>(
      value: 'Balanço',
      child: Text('Balanço'),
    ),
    DropdownMenuItem<String>(
      value: 'Balancete',
      child: Text('Balancete'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    color: markPrimaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/assets/images/Logo2.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // const SizedBox(height: 20),
                            // const SizedBox(height: 20),
                            // const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(70.0),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: DropdownButton<String>(
                                  underline: Container(),
                                  items: list,
                                  hint: Text(
                                    'Tipo de Arquivo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              child: HomeButton(
                                texto: "Enviar",
                                login: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                onPressed: () {
                  // Lógica para o logout
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ); // Volta para a tela anterior (ou tela de login)
                },
                icon: Icon(Icons.logout),
                color: Colors.black, // Cor do ícone
              ),
            ),
          ],
        ),
      ),
    );
  }
}
