import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

class ExampleDragTarget extends StatefulWidget {
  const ExampleDragTarget({Key? key}) : super(key: key);

  @override
  _ExampleDragTargetState createState() => _ExampleDragTargetState();
}

class _ExampleDragTargetState extends State<ExampleDragTarget> {
  final List<XFile> _list = [];
  bool _dragging = false;
  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (detail) async {
        setState(() {
          _list.addAll(detail.files);
        });
      },
      onDragUpdated: (details) {
        setState(() {
          offset = details.localPosition;
        });
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
          offset = detail.localPosition;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _dragging = false;
          offset = null;
        });
      },
      child: _list.isNotEmpty
          ? Container(
              height: 200,
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_list[index].name),
                  );
                },
              ),
            )
          : Container(
              height: 200,
              color: Colors.grey,
              child: Center(
                child: Text("Drop files here"),
              ),
            ),
    );
  }
}
