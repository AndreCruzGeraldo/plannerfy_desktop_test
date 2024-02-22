import 'package:flutter/material.dart';

void progressDialog(BuildContext context, {String text = ''}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => ProgressWidget(text: text),
  );
}

class ProgressWidget extends StatelessWidget {
  final String text;

  const ProgressWidget({this.text = ''});

  @override
  Widget build(BuildContext context) {
    return text == ''
        ? const Center(
            child: Card(
              color: Colors.black38,
              child: SizedBox(
                height: 80,
                width: 80,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          )
        : Center(
            child: Card(
              color: Colors.black87,
              child: SizedBox(
                width: 280,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
