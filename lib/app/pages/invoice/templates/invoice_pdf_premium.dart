import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generatePremiumInvoicePdf(
    Map<String, dynamic> data, Uint8List logo) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageTheme: const pw.PageTheme(
        margin: pw.EdgeInsets.all(20),
      ),
      build: (context) {
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(pw.MemoryImage(logo), width: 80),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("FACTURE PREMIUM",
                        style: pw.TextStyle(
                            fontSize: 22, fontWeight: pw.FontWeight.bold)),
                    pw.Text("N° ${data["invoiceNumber"]}"),
                  ],
                )
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              color: PdfColors.blue,
              child: pw.Text("Informations vendeur",
                  style:
                      const pw.TextStyle(color: PdfColors.white, fontSize: 16)),
            ),
            pw.SizedBox(height: 5),
            pw.Text(data["sellerName"]),
            pw.Text(data["sellerAddress"]),
            pw.SizedBox(height: 15),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              color: PdfColors.grey700,
              child: pw.Text("Informations client",
                  style:
                      const pw.TextStyle(color: PdfColors.white, fontSize: 16)),
            ),
            pw.SizedBox(height: 5),
            pw.Text(data["buyerName"]),
            pw.Text(data["buyerAddress"]),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(width: 0.5),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Produit")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Qté")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("PU")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Total")),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["description"])),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["quantity"])),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["price"])),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["total"])),
                ]),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("TOTAL : ${data["totalTtc"]}",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/invoice_premium.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}
