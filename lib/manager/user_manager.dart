import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:plannerfy_desktop/model/company_model.dart';
import 'package:plannerfy_desktop/model/user_model.dart';
import 'package:plannerfy_desktop/ui_antiga/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:plannerfy_desktop/utility/progress_dialog.dart';

import '../services/ws_controller.dart';

class UserManager extends ChangeNotifier {
  UserModel? _user;
  Company? _chosenCompany;

  UserModel? get user => _user;
  Company? get chosenCompany => _chosenCompany;

  setCompany(Company empresa) {
    _chosenCompany = empresa;
    notifyListeners();
  }

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  bool signIn = false;

//--------------------------------------------------------------------
  Future<void> userSignIn(context, String username, String password) async {
    try {
      progressDialog(context);

      String sha256Password = sha256.convert(utf8.encode(password)).toString();
      String uppersha256Password = sha256Password.toUpperCase();

      MapSD response = await WsController.wsGet(
        query: '/user/login',
        body: jsonEncode({
          "user_email": username,
          "user_senha": uppersha256Password,
        }),
      );

      if (response["status"] == "ok") {
        MapSD userData = response["user"];

        UserModel userModel = UserModel.fromJson(userData);
        setUser(userModel);
        setCompany(userModel.empresasVinculadas![0]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro de Login'),
              content: const Text(
                  'E-mail ou senha inválido. Por favor, tente novamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro de Login'),
            content: const Text(
                'Ocorreu um erro durante o processo de login. Por favor, tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
