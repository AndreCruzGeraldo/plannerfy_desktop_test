import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/home_btn.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown.dart';
import 'package:plannerfy_desktop/pages/home/components/home_dropdown2.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: markPrimaryColor,
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Alinhar no topo
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                          height: 100), // Aumentar espaço acima da imagem
                      Image.asset(
                        'lib/assets/images/Logo2.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                          height: 100), // Aumentar espaço abaixo da imagem
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150),
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
                            // Implemente a lógica para quando um valor for selecionado
                          },
                          hintText: 'Selecione Empresa',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(80.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomDropdown2(
                              items: const [
                                'Documentos',
                                'Contrato social',
                                'DRE Contabil',
                                'Balanço',
                                'Balancete',
                              ],
                              onChanged: (value) {
                                // Implemente a lógica para quando um valor for selecionado
                              },
                              hintText: 'Tipo de Arquivo',
                            ),
                            const SizedBox(height: 20),
                            DottedBorder(
                              radius: Radius.circular(8),
                              borderType: BorderType.RRect,
                              color: Colors.grey,
                              strokeWidth: 2.0,
                              child: Padding(
                                padding: const EdgeInsets.all(80.0),
                                child: Column(
                                  children: [
                                    Text("Arraste e solte os arquivos aqui"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("ou"),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors
                                            .white, // Background color of the button
                                        onPrimary: Colors
                                            .grey, // Text color when pressed
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20.0), // Rounded edges
                                          side: BorderSide(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.upload), // Prefix icon
                                          SizedBox(
                                              width:
                                                  8.0), // Spacer between icon and text
                                          Text(
                                              'Selecionar Arquivos'), // Button text
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            HomeButton(
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
                          ],
                        ),
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
              icon: const Icon(Icons.logout),
              color: Colors.black, // Cor do ícone
            ),
          ),
        ],
      ),
    );
  }
}
