import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class InvoiceItem {
  final String name;
  final int qty;
  final double price;

  InvoiceItem(this.name, this.qty, this.price);

  double get total => qty * price;
}

Future<File> generateMultiInvoicePdf(
    Map<String, dynamic> data, List<InvoiceItem> items) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("FACTURE MULTI-ARTICLES",
                style:
                    pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Client : ${data["buyerName"]}"),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Article")),
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
                ...items.map((item) {
                  return pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item.name)),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("${item.qty}")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("${item.price}")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(item.total.toStringAsFixed(2))),
                  ]);
                }),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "TOTAL TTC : ${data["totalTtc"]}",
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/invoice_multi.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}
