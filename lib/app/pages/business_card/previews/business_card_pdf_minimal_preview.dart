import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class MinimalBusinessCardPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const MinimalBusinessCardPreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu carte de visite"),
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
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                data['name'] ?? 'Nom complet',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['title'] ?? 'Titre du poste',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data['company'] ?? 'Nom de l\'entreprise',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                border: pw.BoxBorder.all(color: PdfColors.grey),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      data['name'] ?? 'Nom complet',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      data['title'] ?? 'Titre du poste',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Text(
                      data['company'] ?? 'Nom de l\'entreprise',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.w500,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
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