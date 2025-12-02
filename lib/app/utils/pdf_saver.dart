import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfSaver {
  static Future<String> savePdf(Uint8List pdfData, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfData);
      return filePath;
    } catch (e) {
      throw Exception('Erreur lors de la sauvegarde du PDF: $e');
    }
  }
}
