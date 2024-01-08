import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_btn.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown2.dart';
import 'package:plannerfy_desktop/pages/home/components/logout_button.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedEmpresa; // Variável para armazenar o valor selecionado
  String? selectedArquivo; // Variável para armazenar o valor selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
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
                        Image.asset(
                          'lib/assets/images/Logo2.png',
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: CustomDropdown(
                            items: const [
                              'Estrelar Ltda',
                              'MegaTech Solutions Inc',
                              'Global Foods Group',
                              'InnovateWare Co',
                              'Visionary Motors Corporation',
                              'Evergreen Investments LLC',
                              'Quantum Innovations Ltd',
                              'Pacific Crest Enterprises',
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedEmpresa =
                                    value; // Atualiza o valor selecionado
                              });
                            },
                            hintText: selectedEmpresa ??
                                'Selecione Empresa', // Atualiza o hint text com o valor selecionado
                          ),
                        ),
                      ],
                    ),
                  ),
                  LogoutButton(
                    onPressed: () {
                      // Lógica para o logout
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ); // Volta para a tela anterior (ou tela de login)
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: CustomDropdown2(
                          items: const [
                            'Documentos',
                            'Contrato social',
                            'DRE Contabil',
                            'Balanço',
                            'Balancete',
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedArquivo =
                                  value; // Atualiza o valor selecionado
                            });
                          },
                          hintText: selectedArquivo ??
                              'Tipo de Arquivo', // Atualiza o hint text com o valor selecionado
                        ),
                      ),
                      const SizedBox(height: 60),
                      DottedBorder(
                        radius: const Radius.circular(8),
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        strokeWidth: 2.0,
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                            children: [
                              const Text(
                                "Arraste e solte os arquivos aqui",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 20, color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("ou",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey)),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  elevation: 1,
                                  primary: Colors.white,
                                  onPrimary: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: const BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),
                                  minimumSize: const Size(double.infinity, 60),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.upload),
                                    SizedBox(width: 10.0),
                                    Text('Selecionar Arquivo',
                                        style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: HomeButton(
                          texto: "Enviar",
                          login: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
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
    );
  }
}
        //   Positioned(
        //     top: 20,
        //     right: 20,
        //     child: IconButton(
        //       onPressed: () {
        //         // Lógica para o logout
        //         Navigator.pop(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const LoginPage(),
        //           ),
        //         ); // Volta para a tela anterior (ou tela de login)
        //       },
        //       icon: const Icon(Icons.logout),
        //       color: Colors.black, // Cor do ícone
        //     ),
        //   ),
        // ],
