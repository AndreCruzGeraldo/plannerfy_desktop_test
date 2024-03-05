import 'dart:convert';
import 'package:plannerfy_desktop/model/user_model.dart';
import 'package:plannerfy_desktop/services/ws_controller.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

// class WsUsers {
//   Future<List<UserModel>> getUsers() async {
//     List<UserModel> users = [];

//     try {
//       MapSD response = await WsController.wsGet(
//         query: "/user/getUsers",
//       );

//       print('Raw Web Service Response: $response');

//       if (response.containsKey('error') ||
//           response.containsKey('connection') ||
//           response.isEmpty) {
//         return [];
//       }

//       response["users"].forEach((element) {
//         users.add(UserModel.fromJson(element));
//       });

//       return users;
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }
class WsUsers {
  Future<UserModel?> login(String username, String password) async {
    Map<String, dynamic> body = {
      "user_email": username,
      "user_senha": password,
    };

    try {
      Map<String, dynamic> response = await WsController.wsPost(
        query: "/user/login",
        body: jsonEncode(body),
      );

      if (response.containsKey('error') ||
          response.containsKey('connection') ||
          response.isEmpty) {
        return null;
      }

      return UserModel.fromJson(response);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Object> loginUser() async {
    MapSD object = {
      "user_email": "fredericohi18@gmail.com",
      "user_senha":
          "8D969EEF6ECAD3C29A3A629280E686CF0C3F5D5A86AFF3CA12020C923ADC6C92"
    };
    try {
      final response = await WsController.wsGetFile(
          query: "/user/login", body: jsonEncode(object));
      return response;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
