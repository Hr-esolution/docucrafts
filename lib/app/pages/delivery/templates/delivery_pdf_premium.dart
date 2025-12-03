import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' show PdfColor;
import 'package:path_provider/path_provider.dart';

Future<File> generatePremiumDeliveryPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#E0E0E0'),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(data["title"] ?? "BON DE LIVRAISON",
                              style: pw.TextStyle(
                                  fontSize: 26,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#000000')),
                          pw.SizedBox(height: 5),
                          pw.Text("N°: ${data["deliveryNumber"]}",
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColor.fromHex('#757575'))),
                          pw.Text("Date: ${data["deliveryDate"]}",
                              style: pw.TextStyle(
                                  fontSize: 12, color: PdfColor.fromHex('#757575'))),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(data["senderName"] ?? "",
                              style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["senderAddress"] ?? ""),
                          pw.Text(data["senderPhone"] ?? ""),
                          pw.Text(data["senderEmail"] ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  left: true,
                  right: true,
                  top: true,
                  bottom: true,
                ),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(15),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Destinataire",
                              style: pw.TextStyle(
                                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 5),
                          pw.Text(data["recipientName"] ?? "",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["recipientAddress"] ?? ""),
                          pw.Text(data["recipientPhone"] ?? ""),
                          pw.Text(data["recipientEmail"] ?? ""),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("Date de livraison",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["deliveryDate"] ?? ""),
                          pw.SizedBox(height: 10),
                          pw.Text("Moyen de transport",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["transportMethod"] ?? ""),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex('#BDBDBD'),
              ),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EEEEEE'),
                  ),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("Désignation",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("Qté",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("Référence",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("PU",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("Total",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(data["description"] ?? "",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(data["quantity"] ?? "0",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(data["reference"] ?? "",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("${data["unitPrice"] ?? "0"} €",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("${data["total"] ?? "0"} €",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              width: double.infinity,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.BoxBorder.all(
                        color: PdfColor.fromHex('#BDBDBD'),
                      ),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(15),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text("Total : ",
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(width: 50),
                              pw.Text("${data["total"] ?? "0"} €",
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Observations",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.SizedBox(height: 5),
                      pw.Text(data["notes"] ?? ""),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Signature du destinataire",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 30),
                      pw.Text("_________________"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/delivery_premium.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}