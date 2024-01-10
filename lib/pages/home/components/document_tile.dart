import 'package:flutter/material.dart';
import 'package:plannerfy_desktop/utility/app_config.dart';

class DocumentTile extends StatelessWidget {
  final String documentName;
  final int fileSize;
  final VoidCallback onDelete;

  const DocumentTile({
    required this.documentName,
    required this.fileSize,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 20,
        ),
      ),
      title: ListTileTheme(
        dense: true,
        contentPadding: EdgeInsets.zero,
        child: Row(
          children: [
            const Icon(
              Icons.file_copy_outlined,
              size: 16,
              color: markPrimaryColor,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  documentName,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _formatBytes(fileSize),
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double result = bytes.toDouble();
    while (result > 1024 && i < suffixes.length - 1) {
      result /= 1024;
      i++;
    }
    return '${result.toStringAsFixed(2)} ${suffixes[i]}';
  }
}
