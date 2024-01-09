import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/home/components/company_selection.dart';
import 'package:plannerfy_desktop/pages/home/components/document_selection.dart';
import 'package:plannerfy_desktop/pages/home/components/home_btn.dart';
import 'package:plannerfy_desktop/pages/home/components/logout_button.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<void> _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        if (_list.isNotEmpty && selectedArquivo != 'Documentos') {
          // If there is already a file in the list and selectedArquivo is not 'Documentos'
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Substituir arquivo?'),
                content: const Text('Deseja substituir o arquivo existente?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _list.clear(); // Clear the current list
                        _list.addAll(
                            result.files.map((file) => XFile(file.path!)));
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Substituir'),
                  ),
                ],
              );
            },
          );
        } else {
          // If the list is empty or selectedArquivo is 'Documentos', add the new file
          _list.addAll(result.files.map((file) => XFile(file.path!)));
        }
      });
    }
  }

  String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double result = bytes.toDouble();
    while (result > 1024 && i < suffixes.length - 1) {
      result /= 1024;
      i++;
    }
    return '${result.toStringAsFixed(2)} ${suffixes[i]}';
  }

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
                        CompanySelection(
                          selectedEmpresa: selectedEmpresa,
                          onEmpresaChanged: (value) {
                            setState(() {
                              selectedEmpresa = value;
                            });
                          },
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
                      DocumentSelection(
                        selectedEmpresa: selectedEmpresa,
                        selectedArquivo: selectedArquivo,
                        onArquivoChanged: (value) {
                          setState(() {
                            selectedArquivo = value;
                          });
                        },
                        showDateInput: selectedArquivo != null &&
                            selectedArquivo != 'Documentos',
                        onDateSelected: (String month, String year) {
                          // Aqui você pode armazenar os valores do mês e ano conforme necessário
                        },
                      ),
                      const SizedBox(height: 20),
                      if (selectedEmpresa != null)
                        DropTarget(
                          onDragDone: (detail) async {
                            if (selectedArquivo != 'Documentos') {
                              if (_list.isEmpty) {
                                setState(() {
                                  _list.addAll(detail.files.take(1));
                                });
                              } else {
                                // Se já houver um arquivo na lista e a opção não for "Documentos"
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Substituir arquivo?'),
                                      content: const Text(
                                          'Deseja substituir o arquivo existente?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _list
                                                  .clear(); // Limpa a lista atual
                                              _list.addAll(detail.files.take(
                                                  1)); // Adiciona o novo arquivo
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Substituir'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } else {
                              setState(() {
                                _list.addAll(detail.files);
                              });
                            }
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
                                            350, // Ajuste a altura do ListView conforme necessário
                                        child: ListView.separated(
                                          itemCount: _list.length,
                                          separatorBuilder: (context, index) =>
                                              const Divider(color: Colors.grey),
                                          itemBuilder: (context, index) {
                                            final file = _list[index];
                                            return FutureBuilder<int>(
                                              future: file.length(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  final fileSize =
                                                      snapshot.data ?? 0;
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
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .file_copy_outlined,
                                                            size: 16,
                                                            color:
                                                                markPrimaryColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                file.name,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              Text(
                                                                _formatBytes(
                                                                    fileSize),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            10),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return const CircularProgressIndicator();
                                                }
                                              },
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
                                      onPressed: _openFilePicker,
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
                      if (selectedEmpresa != null)
                        // const SizedBox(height: 60),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: HomeButton(
                            texto: "Enviar",
                            login: () {
                              if (selectedEmpresa == null ||
                                  selectedArquivo == null ||
                                  _list.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Atenção!'),
                                      content: const Text(
                                          'Por favor, selecione o tipo de arquivo e adicionar arquivos.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
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
