import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class ProfessionalBusinessCardPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProfessionalBusinessCardPreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu carte de visite professionnelle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              _printDocument(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareDocument();
            },
          ),
        ],
      ),
      body: _buildPreview(),
    );
  }

  Widget _buildPreview() {
    return Center(
      child: Container(
        width: 350,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? 'Nom complet',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['title'] ?? 'Titre du poste',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data['company'] ?? 'Nom de l\'entreprise',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['phone'] != null && data['phone'].isNotEmpty)
                    Text('📱 ${data['phone']}'),
                  if (data['email'] != null && data['email'].isNotEmpty)
                    Text('✉️ ${data['email']}'),
                  if (data['address'] != null && data['address'].isNotEmpty)
                    Text('📍 ${data['address']}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _printDocument(BuildContext context) async {
    final document = await _generatePdfDocument();
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => document.save(),
    );
  }

  Future<pw.Document> _generatePdfDocument() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Container(
              width: 350,
              height: 200,
              decoration: pw.BoxDecoration(
                color: pw.Colors.white,
                border: pw.BoxBorder.all(color: pw.Colors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
                boxShadow: [
                  pw.BoxShadow(
                    color: pw.Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: pw.Offset(0, 3),
                  ),
                ],
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(20),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                data['name'] ?? 'Nom complet',
                                style: pw.TextStyle(
                                  fontSize: 18,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                              pw.SizedBox(height: 4),
                              pw.Text(
                                data['title'] ?? 'Titre du poste',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  color: pw.Colors.grey,
                                ),
                              ),
                              pw.SizedBox(height: 12),
                              pw.Text(
                                data['company'] ?? 'Nom de l\'entreprise',
                                style: pw.TextStyle(
                                  fontSize: 14,
                                  fontWeight: pw.FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 60,
                          height: 60,
                          decoration: pw.BoxDecoration(
                            color: pw.Colors.grey200,
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.Center(
                            child: pw.Icon(
                              pw.PdfIcons.person,
                              size: 30,
                              color: pw.Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        if (data['phone'] != null && data['phone'].isNotEmpty)
                          pw.Text('📱 ${data['phone']}'),
                        if (data['email'] != null && data['email'].isNotEmpty)
                          pw.Text('✉️ ${data['email']}'),
                        if (data['address'] != null && data['address'].isNotEmpty)
                          pw.Text('📍 ${data['address']}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    return pdf;
  }

  void _shareDocument() async {
    final document = await _generatePdfDocument();
    final bytes = await document.save();
    
    await Share.shareWithResult(
      bytes,
      subject: 'Carte de visite',
      text: 'Voici ma carte de visite',
    );
  }
}