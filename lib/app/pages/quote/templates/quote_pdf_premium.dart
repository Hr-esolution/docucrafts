import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generatePremiumQuotePdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              decoration: pw.BoxDecoration(
                color: pw.PdfColors.grey300,
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
                          pw.Text(data["title"] ?? "DEVIS",
                              style: pw.TextStyle(
                                  fontSize: 26,
                                  fontWeight: pw.FontWeight.bold,
                                  color: pw.PdfColors.black)),
                          pw.SizedBox(height: 5),
                          pw.Text("N°: ${data["quoteNumber"]}",
                              style: pw.TextStyle(
                                  fontSize: 12, color: pw.PdfColors.black50)),
                          pw.Text("Date: ${data["issueDate"]}",
                              style: pw.TextStyle(
                                  fontSize: 12, color: pw.PdfColors.black50)),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(data["sellerName"] ?? "",
                              style: pw.TextStyle(
                                  fontSize: 14, fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["sellerAddress"] ?? ""),
                          pw.Text(data["sellerPhone"] ?? ""),
                          pw.Text(data["sellerEmail"] ?? ""),
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
                          pw.Text("Client",
                              style: pw.TextStyle(
                                  fontSize: 16, fontWeight: pw.FontWeight.bold)),
                          pw.SizedBox(height: 5),
                          pw.Text(data["buyerName"] ?? "",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["buyerAddress"] ?? ""),
                          pw.Text(data["buyerPhone"] ?? ""),
                          pw.Text(data["buyerEmail"] ?? ""),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("Validité",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["validityDate"] ?? ""),
                          pw.SizedBox(height: 10),
                          pw.Text("Conditions de paiement",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(data["paymentTerms"] ?? "30 jours"),
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
                color: pw.PdfColors.grey400,
              ),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: pw.PdfColors.grey200,
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
                      child: pw.Text("PU HT",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("TVA",
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 12)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("Total HT",
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
                      child: pw.Text("${data["price"] ?? "0"} €",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("${data["taxRate"] ?? "0"}%",
                          style: pw.TextStyle(fontSize: 11)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text("${data["totalHt"] ?? "0"} €",
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
                        color: pw.PdfColors.grey400,
                      ),
                    ),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(15),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text("Total HT : ",
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(width: 50),
                              pw.Text("${data["totalHt"] ?? "0"} €",
                                  style: pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            children: [
                              pw.Text("TVA (${data["taxRate"] ?? "0"}%) : ",
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(width: 50),
                              pw.Text("${data["taxAmount"] ?? "0"} €",
                                  style: pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                          pw.Divider(height: 20),
                          pw.Row(
                            children: [
                              pw.Text("Total TTC : ",
                                  style: pw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(width: 50),
                              pw.Text("${data["totalTtc"] ?? "0"} €",
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
            pw.SizedBox(height: 20),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Conditions générales",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text(data["generalTerms"] ?? ""),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/quote_premium.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}