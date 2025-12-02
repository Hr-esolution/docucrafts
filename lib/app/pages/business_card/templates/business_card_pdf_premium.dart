import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generatePremiumBusinessCardPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: pw.PageFormat.a4.applyMargin(
        left: 2.0 * pw.PdfPageMetrics.mm,
        top: 2.0 * pw.PdfPageMetrics.mm,
        right: 2.0 * pw.PdfPageMetrics.mm,
        bottom: 2.0 * pw.PdfPageMetrics.mm,
      ),
      build: (context) {
        return pw.Center(
          child: pw.Container(
            width: 85 * pw.PdfPageMetrics.mm,
            height: 55 * pw.PdfPageMetrics.mm,
            decoration: pw.BoxDecoration(
              border: pw.BoxBorder.all(
                color: pw.PdfColors.grey,
              ),
              gradient: pw.BoxGradient.linear(
                pw.Point(0, 0),
                pw.Point(85 * pw.PdfPageMetrics.mm, 55 * pw.PdfPageMetrics.mm),
                [pw.PdfColors.grey300, pw.PdfColors.grey100],
              ),
            ),
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(15),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(data["company"] ?? "",
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: pw.PdfColors.grey)),
                  pw.SizedBox(height: 5),
                  pw.Text(data["name"] ?? "",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 3),
                  pw.Text(data["jobTitle"] ?? "",
                      style: pw.TextStyle(
                          fontSize: 10, fontWeight: pw.FontWeight.normal)),
                  pw.SizedBox(height: 10),
                  pw.Divider(
                    thickness: 0.5,
                    color: pw.PdfColors.grey,
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
                                style: pw.TextStyle(fontSize: 8)),
                            pw.Text("✉️ ${data["email"] ?? ""}",
                                style: pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("🏢 ${data["address"] ?? ""}",
                                style: pw.TextStyle(fontSize: 8)),
                            pw.Text("🌐 ${data["website"] ?? ""}",
                                style: pw.TextStyle(fontSize: 8)),
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
  await file.writeAsBytes(await pdf.save());
  return file;
}