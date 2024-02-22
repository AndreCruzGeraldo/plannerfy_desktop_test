import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
// import 'package:plannerfy_desktop/database/db_helper.dart';
import 'package:plannerfy_desktop/models/empresa_model.dart';
import 'package:plannerfy_desktop/models/user_model.dart';
import 'package:plannerfy_desktop/pages/home/home_page.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';
import 'package:plannerfy_desktop/utility/progress_dialog.dart';

// import '../database/crud/crud_login.dart';
import '../services/ws_controller.dart';

class UserManager extends ChangeNotifier {
  // Parte responsável por salvar informações do usuário logado
  // e a compania escolhida na HomePage()
  // obs: O default da _chosenCompany é o index 0 do vetor de companias vinculadas ao usuario
  UserModel? _user;
  Empresa? _chosenCompany;

  UserModel? get user => _user;
  Empresa? get chosenCompany => _chosenCompany;

  setCompany(Empresa empresa) {
    _chosenCompany = empresa;
    notifyListeners();
  }

  setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  bool signIn = false;
  // // ignore: unused_field
  // late DatabaseHelper _dbHelper;
  // bool loading = true;

  // UserManager() {
  //   _dbHelper = DatabaseHelper();
  //   loggedUser();
  // }

  // initProvider() {
  //   _dbHelper = DatabaseHelper();
  //   loggedUser();
  // }

  // Future<bool> loggedUser() async {
  //   try {
  //     final String email = await CRUDLogin.getLoggedDbUser();
  //     if (email != "") {
  //       final user = await _fetchUser(email);
  //       if (user != null) {
  //         _user = user;
  //         _chosenCompany = user.empresasVinculadas![0];
  //         signIn = true;
  //         loading = false;
  //         notifyListeners();
  //         return true;
  //       }
  //     }
  //   } catch (e) {
  //     print('Error checking and fetching logged-in user: $e');
  //   }

  //   loading = false;
  //   notifyListeners();
  //   return false;
  // }

//--------------------------------------------------------------------
  void userSignIn(context, String username, String password) async {
    // String username = username.trim();
    // String password = password.trim();

    try {
      progressDialog(context);

      String sha256Password = sha256.convert(utf8.encode(password)).toString();
      String uppersha256Password = sha256Password.toUpperCase();

//
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
        //

        setUser(userModel);

        // await CRUDLogin().saveLogin(username, 1);

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

// Esta função pode ser que eu tenha que passar para o CRUD
  // Future<UserModel?> _fetchUser(String userEmail) async {
  //   try {
  //     final requestBody = jsonEncode({'user_email': userEmail});
  //     print('Request body: $requestBody');

  //     final response = await WsController.wsGet(
  //       query: '/user/getUser',
  //       body: requestBody,
  //     );

  //     print('Response: $response');

  //     return UserModel.fromJson(response['user']);
  //   } catch (e) {
  //     print('Error fetching user: $e');
  //     return null;
  //   }
  // }
}
