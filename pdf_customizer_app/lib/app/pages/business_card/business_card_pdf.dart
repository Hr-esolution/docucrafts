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
                  style: pw.TextStyle(
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
                          pw.Icon(
                            pw.PdfIcons.phone,
                            size: 10,
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            phone,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    if (email.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Icon(
                            pw.PdfIcons.email,
                            size: 10,
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            email,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                    if (address.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Icon(
                            pw.PdfIcons.location,
                            size: 10,
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            address,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                    if (website.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Icon(
                            pw.PdfIcons.link,
                            size: 10,
                          ),
                          pw.SizedBox(width: 5),
                          pw.Text(
                            website,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                    if (linkedin.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text(
                            'LinkedIn: ',
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            linkedin,
                            style: pw.TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                    if (twitter.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Twitter: ',
                            style: pw.TextStyle(fontSize: 10),
                          ),
                          pw.Text(
                            twitter,
                            style: pw.TextStyle(fontSize: 10),
                          ),
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