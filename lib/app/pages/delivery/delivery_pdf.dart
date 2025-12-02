import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateDeliveryPdf({
  required String deliveryNumber,
  required String date,
  required String clientName,
  required String clientAddress,
  required String deliveryAddress,
  required String items,
  required String quantity,
  required String carrier,
  required String signatureRequired,
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
                'Bon de Livraison',
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
                        'Numéro du bon: $deliveryNumber',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Date: $date',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.Text(
                        'Transporteur: $carrier',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Client:',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(clientName,
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text(clientAddress,
                          style: const pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Adresse de livraison:',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(deliveryAddress,
                          style: const pw.TextStyle(fontSize: 14)),
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
                  pw.Text(items, style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Quantité: $quantity',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  'Signature requise: $signatureRequired',
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            ),
            pw.SizedBox(height: 40),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Container(
                  width: 200,
                  height: 50,
                  child: pw.Text(
                    'Signature du client',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                ),
                pw.Container(
                  width: 200,
                  height: 50,
                  child: pw.Text(
                    'Signature du livreur',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
