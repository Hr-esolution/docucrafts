import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as pdf;
import 'package:pdf/widgets.dart' show PdfColor;

Future<Uint8List> generateCvPdf({
  required String fullName,
  required String jobTitle,
  required String phone,
  required String email,
  required String address,
  required String summary,
  required String experience,
  required String education,
  required String skills,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.Page(
      pageFormat: pdf.PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            // En-tête
            pw.Container(
              color: PdfColor.fromHex('#E0E0E0'),
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                children: [
                  pw.Text(
                    fullName,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    jobTitle,
                    style: const pw.TextStyle(
                      fontSize: 16,
                      color: PdfColor.fromHex('#616161'),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Informations de contact
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (phone.isNotEmpty)
                        pw.Text('Téléphone: $phone',
                            style: const pw.TextStyle(fontSize: 12)),
                      if (email.isNotEmpty) ...[
                        pw.SizedBox(height: 5),
                        pw.Text('Email: $email',
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                      if (address.isNotEmpty) ...[
                        pw.SizedBox(height: 5),
                        pw.Text('Adresse: $address',
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Résumé
            if (summary.isNotEmpty) ...[
              pw.Container(
                width: double.infinity,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'RÉSUMÉ PROFESSIONNEL',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(summary, style: const pw.TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
            ],

            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Colonne gauche - Expérience et Formation
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (experience.isNotEmpty) ...[
                        pw.Text(
                          'EXPÉRIENCE PROFESSIONNELLE',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(experience,
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 15),
                      ],
                      if (education.isNotEmpty) ...[
                        pw.Text(
                          'FORMATION',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(education,
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ],
                  ),
                ),

                pw.SizedBox(width: 20),

                // Colonne droite - Compétences
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'COMPÉTENCES',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(skills,
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  return doc.save();
}
