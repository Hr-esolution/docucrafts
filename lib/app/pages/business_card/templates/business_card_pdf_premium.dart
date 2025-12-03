import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

Future<File> generatePremiumBusinessCardPdf(Map<String, dynamic> data) async {
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.applyMargin(
        left: 2.0 * PdfPageFormat.mm,
        top: 2.0 * PdfPageFormat.mm,
        right: 2.0 * PdfPageFormat.mm,
        bottom: 2.0 * PdfPageFormat.mm,
      ),
      build: (context) {
        return pw.Center(
          child: pw.Container(
            width: 85 * PdfPageFormat.mm,
            height: 55 * PdfPageFormat.mm,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                color: PdfColor.fromHex('#9E9E9E'),
                width: 1,
              ),
              color: PdfColor.fromHex('#F5F5F5'), // fond uni
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(15),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    data["company"] ?? "",
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#9E9E9E'),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    data["name"] ?? "",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    data["jobTitle"] ?? "",
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(
                    thickness: 0.5,
                    color: PdfColor.fromHex('#9E9E9E'),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("📱 ${data["phone"] ?? ""}",
                                style: const pw.TextStyle(fontSize: 8)),
                            pw.Text("✉️ ${data["email"] ?? ""}",
                                style: const pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("🏢 ${data["address"] ?? ""}",
                                style: const pw.TextStyle(fontSize: 8)),
                            pw.Text("🌐 ${data["website"] ?? ""}",
                                style: const pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/business_card_premium.pdf");
  await file.writeAsBytes(await doc.save());
  return file;
}
