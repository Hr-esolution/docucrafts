import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInvoicePdf({
  required String invoiceNumber,
  required String date,
  required String clientName,
  required String clientAddress,
  required String items,
  required String amount,
  required String vat,
  required String total,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Facture',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Numéro de facture: $invoiceNumber',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Date: $date',
                        style: pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'À l\'attention de:',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(clientName, style: pw.TextStyle(fontSize: 14)),
                      pw.Text(clientAddress, style: pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Désignation des articles',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(items, style: pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Montant: $amount €',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.Text(
                    'TVA: $vat €',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.Divider(),
                  pw.Text(
                    'Total: $total €',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Merci pour votre confiance!',
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
