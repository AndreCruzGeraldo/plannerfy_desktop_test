import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> list = [
      DropdownMenuItem<String>(
        value: 'Documentos',
        child: Text('Documentos'),
      ),
      DropdownMenuItem<String>(
        value: 'Contrato social',
        child: Text('Contrato social'),
      ),
      DropdownMenuItem<String>(
        value: 'DRE Contabil',
        child: Text('DRE Contabil'),
      ),
      DropdownMenuItem<String>(
        value: 'Balanço',
        child: Text('Balanço'),
      ),
      DropdownMenuItem<String>(
        value: 'Balancete',
        child: Text('Balancete'),
      ),
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              width: 300.0,
              padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: DropdownButton<String>(
                underline: Container(),
                items: list,
                hint: Text(
                  'Tipo de Arquivo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                isExpanded: true,
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
