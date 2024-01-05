import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/pages/login/login_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
