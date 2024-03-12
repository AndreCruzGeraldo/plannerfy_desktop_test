import 'package:flutter/material.dart';

String version = "1.0.0";

typedef MapSD = Map<String, dynamic>;

enum TipoArquivo { CONTABILIDADE, DOCUMENTO, PLANILHA }

MaterialColor? materialMarkPrimaryColor =
    const Color(0xFF479A47) as MaterialColor?;
const Color markPrimaryColor = Color(0xFF0E353C);
const Color color2 = Color(0xFF16555B);
const Color color3 = Color(0xFF0E353C);
const Color color4 = Color(0xFF0E353C);
const Color markSecondaryColor = Color(0xFF16555B);
final Color markTertiaryColor = Colors.yellow[400]!;
final Color backgroundColor = Colors.grey[200]!;
const Color inativeColor = Color(0xFFE0E0E0);
final Color redColor = Colors.red[700]!;
const Color transparentWeakColor = Color.fromARGB(52, 121, 121, 121);

final Color textDarkColor = Colors.grey[800]!;
final Color colorCard = Colors.grey[350]!;
const Color inactiveColor = Color(0xFFE0DDDD);
const Color blackText = Colors.black54;

const String plannerfyLogo = "lib/assets/images/logo_nome.png";
const String plannerfyIconWhite = "lib/assets/images/icon_white.png";

const String primaryFont = "Kastelov";

double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;

String getSaudacaoText({required String user}) {
  DateTime now = DateTime.now();
  if (user != "") {
    if (now.hour < 12 && now.hour >= 6) return "Bom dia, $user";
    if (now.hour >= 12 && now.hour <= 18) return "Boa tarde, $user";
    if (now.hour >= 19 || now.hour < 6) return "Boa noite, $user";
  }
  return "Bem vindo";
}

String formatWordToLower(String word, {int? maxWords}) {
  List<String> words = word.trim().split(" ");
  if (maxWords == null) maxWords = words.length;
  String newDescricao = "";

  int count = 1;
  words.forEach((w) {
    if (w.length > 0 && maxWords! >= count) {
      newDescricao += w.substring(0, 1).toUpperCase();
      newDescricao += w.substring(1).toLowerCase();
      newDescricao += " ";
      count++;
    }
  });

  return newDescricao.trim();
}
