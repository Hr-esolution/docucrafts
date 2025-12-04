import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ModernBusinessCardPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const ModernBusinessCardPreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu carte de visite moderne"),
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
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data['name'] ?? 'Nom complet',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data['title'] ?? 'Titre du poste',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                data['company'] ?? 'Nom de l\'entreprise',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (data['phone'] != null && data['phone'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '📱 ${data['phone']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  if (data['email'] != null && data['email'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '✉️ ${data['email']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
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
    await Printing.layoutPdf(
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
                gradient: pw.LinearGradient(
                  colors: [
                    PdfColor.fromHex('#667eea'),
                    PdfColor.fromHex('#764ba2'),
                  ],
                  begin: pw.Alignment.topLeft,
                  end: pw.Alignment.bottomRight,
                ),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      data['name'] ?? 'Nom complet',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      data['title'] ?? 'Titre du poste',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColor.fromInt(0xB3FFFFFF),
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Text(
                      data['company'] ?? 'Nom de l\'entreprise',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        if (data['phone'] != null && data['phone'].isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 8),
                            child: pw.Text(
                              '📱 ${data['phone']}',
                              style: pw.TextStyle(color: PdfColors.white),
                            ),
                          ),
                        if (data['email'] != null && data['email'].isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 8),
                            child: pw.Text(
                              '✉️ ${data['email']}',
                              style: pw.TextStyle(color: PdfColors.white),
                            ),
                          ),
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

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/modern_business_card.pdf';
    final file = File(filePath);

    await file.writeAsBytes(bytes, flush: true);

    await Share.shareXFiles(
      [XFile(filePath)],
      text: 'Voici ma carte de visite',
      subject: 'Carte de visite',
    );
  }
}
