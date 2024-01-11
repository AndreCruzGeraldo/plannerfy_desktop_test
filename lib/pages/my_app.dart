import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tamanho da tela ao abrir
    DesktopWindow.setWindowSize(const Size(1080, 720));
    // Tamanho de tela mínima
    DesktopWindow.setMinWindowSize(const Size(1080, 720));

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kastelov',
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
