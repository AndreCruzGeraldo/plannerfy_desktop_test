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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/images/Logo2.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      const SizedBox(height: 20),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 150),
                            child: CustomDropdown2(
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
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 130),
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
