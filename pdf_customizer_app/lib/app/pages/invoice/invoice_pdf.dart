import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> generateInvoicePdf({
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
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // En-tête de la facture
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                invoiceTitle,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Numéro de facture et dates
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Numéro de facture: $invoiceNumber',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                      pw.Text(
                        'Date d\'émission: $issueDate',
                        style: pw.TextStyle(fontSize: 12),
                      ),
                      if (serviceDate.isNotEmpty && serviceDate != issueDate) 
                        pw.Text(
                          'Date de prestation: $serviceDate',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Facturé à:',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(buyerName, style: pw.TextStyle(fontSize: 12)),
                      pw.Text(buyerAddress, style: pw.TextStyle(fontSize: 12)),
                      if (buyerVatNumber.isNotEmpty)
                        pw.Text('N° TVA: $buyerVatNumber', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            
            // Informations du vendeur
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Émis par:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(sellerName, style: pw.TextStyle(fontSize: 12)),
                  pw.Text(sellerAddress, style: pw.TextStyle(fontSize: 12)),
                  if (sellerVatNumber.isNotEmpty)
                    pw.Text('N° TVA: $sellerVatNumber', style: pw.TextStyle(fontSize: 12)),
                  if (sellerPhone.isNotEmpty)
                    pw.Text('Tél: $sellerPhone', style: pw.TextStyle(fontSize: 12)),
                  if (sellerEmail.isNotEmpty)
                    pw.Text('Email: $sellerEmail', style: pw.TextStyle(fontSize: 12)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Détails des articles
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Désignation des biens ou services',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey400),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('Désignation', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('Qté', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('Prix unitaire HT', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(itemDescription),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text(itemQuantity),
                          ),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(5),
                            child: pw.Text('${itemUnitPrice} €'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Montants
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Row(
                    children: [
                      pw.Text('Sous-total HT: ', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('$subtotalHt €', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('Taux de TVA: ', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('$vatRate%', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Text('Montant TVA: ', style: pw.TextStyle(fontSize: 12)),
                      pw.Text('$vatAmount €', style: pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                  pw.Divider(height: 10),
                  pw.Row(
                    children: [
                      pw.Text('Total TTC: ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text('$totalTtc €', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Conditions de paiement
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Conditions de paiement',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text('Mode de paiement: $paymentMethod', style: pw.TextStyle(fontSize: 12)),
                  pw.Text('Délai de paiement: $paymentTerms', style: pw.TextStyle(fontSize: 12)),
                  if (lateFees.isNotEmpty)
                    pw.Text('Pénalités de retard: $lateFees', style: pw.TextStyle(fontSize: 12)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Message de fin
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Merci pour votre confiance!',
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
          ],
        );
      },
    ),
  );

  return pdf.save();
}