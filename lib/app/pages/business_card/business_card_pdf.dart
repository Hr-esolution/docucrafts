import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

Future<Uint8List> generateBusinessCardPdf({
  required String fullName,
  required String jobTitle,
  required String company,
  required String phone,
  required String email,
  required String website,
  required String address,
  required String linkedin,
  required String twitter,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            width: 300,
            height: 180,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 1),
              borderRadius: pw.BorderRadius.circular(10),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  fullName,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  jobTitle,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 10),
                if (company.isNotEmpty) ...[
                  pw.Text(
                    company,
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                ],
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (phone.isNotEmpty)
                      pw.Row(
                        children: [
                          pw.Text('Tél : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(phone,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    if (email.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text('Email : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(email,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                    if (address.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text('Adresse : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(address,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                    if (website.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text('Site : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(website,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                    if (linkedin.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text('LinkedIn : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(linkedin,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                    if (twitter.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text('Twitter : ',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(twitter,
                              style: const pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  return pdf.save();
}
