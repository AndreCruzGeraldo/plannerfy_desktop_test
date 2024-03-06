import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:plannerfy_desktop/manager/user_manager.dart';
import 'package:plannerfy_desktop/ui_antiga/login/login_page.dart';
import 'package:plannerfy_desktop/ui_antiga/home/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Definir o tamanho da tela ao abrir
    DesktopWindow.setWindowSize(const Size(1080, 720));
    // Definir o tamanho mínimo da tela
    DesktopWindow.setMinWindowSize(const Size(1080, 720));

    return
        MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: true,
        ),
      ],
      child: MaterialApp(
        title: 'Plannerfy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Kastelov',
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
