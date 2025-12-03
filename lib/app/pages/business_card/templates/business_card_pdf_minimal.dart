import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdf;
import 'package:path_provider/path_provider.dart';

Future<File> generateMinimalBusinessCardPdf(Map<String, dynamic> data) async {
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: pdf.PdfPageFormat.a4.applyMargin(
        left: 2.0 * pdf.PdfPageFormat.mm,
        top: 2.0 * pdf.PdfPageFormat.mm,
        right: 2.0 * pdf.PdfPageFormat.mm,
        bottom: 2.0 * pdf.PdfPageFormat.mm,
      ),
      build: (context) {
        return pw.Center(
          child: pw.Container(
            width: 85 * pdf.PdfPageFormat.mm,
            height: 55 * pdf.PdfPageFormat.mm,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: pdf.PdfColor.fromHex("#9E9E9E"),
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(data["name"] ?? "",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text(data["jobTitle"] ?? "",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.normal)),
                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text(data["phone"] ?? "",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(data["email"] ?? "",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(data["address"] ?? "",
                      style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(data["website"] ?? "",
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/business_card_minimal.pdf");
  await file.writeAsBytes(await doc.save());
  return file;
}
