// import 'package:plannerfy_desktop/database/crud/crud_login.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseHelper with CRUDLogin {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();

//   factory DatabaseHelper() => _instance;

//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;

//     _database = await _initDatabase();
//     return _database;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'plannerfy.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         createLoginTable(db);
//       },
//     );
//   }
// }
