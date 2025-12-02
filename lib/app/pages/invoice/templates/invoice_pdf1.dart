import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> generateInvoicePdf({
  required String invoiceTitle,
  required String invoiceNumber,
  required String issueDate,
  required String serviceDate,
  required String sellerName,
  required String sellerAddress,
  required String sellerVatNumber,
  required String sellerPhone,
  required String sellerEmail,
  required String buyerName,
  required String buyerAddress,
  required String buyerVatNumber,
  required String itemDescription,
  required String itemQuantity,
  required String itemUnitPrice,
  required String vatRate,
  required String vatAmount,
  required String subtotalHt,
  required String totalTtc,
  required String paymentTerms,
  required String paymentMethod,
  required String lateFees,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(invoiceTitle,
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Facture N° : $invoiceNumber"),
            pw.Text("Date d'émission : $issueDate"),
            pw.Text("Livraison : $serviceDate"),
            pw.Divider(),
            pw.Text("Vendeur",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text(sellerName),
            pw.Text(sellerAddress),
            pw.Text("TVA : $sellerVatNumber"),
            pw.Text("Téléphone : $sellerPhone"),
            pw.Text("Email : $sellerEmail"),
            pw.SizedBox(height: 10),
            pw.Text("Client",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text(buyerName),
            pw.Text(buyerAddress),
            pw.Text("TVA : $buyerVatNumber"),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Description")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Qté")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("PU HT")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text("Total HT")),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(itemDescription)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(itemQuantity)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(itemUnitPrice)),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(subtotalHt)),
                ]),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Sous-total HT : $subtotalHt"),
                    pw.Text("TVA ($vatRate%) : $vatAmount"),
                    pw.Text("Total TTC : $totalTtc",
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ],
            ),
            pw.Divider(),
            pw.Text("Conditions : $paymentTerms"),
            pw.Text("Mode de paiement : $paymentMethod"),
            pw.Text("Pénalités : $lateFees"),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/invoice.pdf");
  await file.writeAsBytes(await pdf.save());
}
