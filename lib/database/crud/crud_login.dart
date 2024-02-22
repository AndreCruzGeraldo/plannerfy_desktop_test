// import 'package:plannerfy_desktop/database/db_helper.dart';
// import 'package:plannerfy_desktop/database/tables/table_login.dart';
// import 'package:sqflite/sqflite.dart';

// class CRUDLogin {
//   Future<void> createLoginTable(Database db) async {
//     await db.execute(
//         "CREATE TABLE IF NOT EXISTS $tableLogin($loginEmailField TEXT PRIMARY KEY, $loginField INTEGER UNIQUE)");
//   }

//   Future<void> saveLogin(String email, int login) async {
//     final Database? db = await DatabaseHelper().database;
//     if (db != null) {
//       await db.insert(
//         tableLogin,
//         {loginEmailField: email, loginField: login},
//         conflictAlgorithm: ConflictAlgorithm.replace,
//       );
//     } else {
//       throw Exception('Failed to get database instance');
//     }
//   }

//   static Future<String> getLoggedDbUser() async {
//     final db = await DatabaseHelper().database;
//     if (db == null) {
//       throw Exception('Failed to open database');
//     }

//     List<Map<String, dynamic>> result =
//         await db.query(tableLogin, where: '$loginField = ?', whereArgs: [1]);
//     if (result.isNotEmpty) {
//       print(result.first[loginEmailField]);
//       return result.first[loginEmailField];
//     } else {
//       return "";
//     }
//   }

//   Future<void> signOutAllUsers() async {
//     final Database? db = await DatabaseHelper().database;
//     if (db != null) {
//       await db.update(
//         tableLogin,
//         {loginField: 0},
//       );
//     } else {
//       throw Exception('Falha ao buscar a instância do database');
//     }
//   }
// }
