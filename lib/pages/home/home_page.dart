import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/drag_drop.dart';
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

  final List<XFile> _list = [];
  bool _dragging = false;
  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 4, // 40% da largura total
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
                                selectedEmpresa = value;
                              });
                            },
                            hintText: selectedEmpresa ?? 'Selecione Empresa',
                          ),
                        ),
                      ],
                    ),
                  ),
                  LogoutButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6, // 60% da largura total
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
                              selectedArquivo = value;
                            });
                          },
                          hintText: selectedArquivo ?? 'Tipo de Arquivo',
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropTarget(
                        onDragDone: (detail) async {
                          setState(() {
                            _list.addAll(detail.files);
                          });
                        },
                        onDragUpdated: (details) {
                          setState(() {
                            offset = details.localPosition;
                          });
                        },
                        onDragEntered: (detail) {
                          setState(() {
                            _dragging = true;
                            offset = detail.localPosition;
                          });
                        },
                        onDragExited: (detail) {
                          setState(() {
                            _dragging = false;
                            offset = null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(
                              40.0), // Ajuste o padding conforme necessário
                          child: DottedBorder(
                            radius: const Radius.circular(8),
                            borderType: BorderType.RRect,
                            color: Colors.grey,
                            strokeWidth: 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  if (_list.isEmpty)
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  if (_list.isNotEmpty)
                                    SizedBox(
                                      height:
                                          400, // Ajuste a altura do ListView conforme necessário
                                      child: ListView.separated(
                                        itemCount: _list.length,
                                        separatorBuilder: (context, index) =>
                                            const Divider(color: Colors.grey),
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            trailing: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _list.removeAt(index);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
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
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    _list[index].name,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  const Text(
                                    "Arraste e solte os arquivos aqui",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                  const Text(
                                    "ou",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 1,
                                      primary: Colors.white,
                                      onPrimary: Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      minimumSize:
                                          const Size(double.infinity, 60),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        ),
                      ),
                      // const SizedBox(height: 60),
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
