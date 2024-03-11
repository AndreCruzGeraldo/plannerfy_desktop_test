import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountingManager {
  static Future<Iterable<File>> pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    final files = result?.files.map((file) => File(file.path ?? ''));
    return files ?? [];
  }

  static Future<void> previewFile(File file) async {
    if (file.path.toLowerCase().endsWith('.pdf')) {
      final Uri filePath = Uri.file(file.path);
      if (await canLaunchUrl(filePath)) {
        await launchUrl(filePath);
      } else {
        throw 'Não foi possível iniciar $filePath';
      }
    }
  }
}
