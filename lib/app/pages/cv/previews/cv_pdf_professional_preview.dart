import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;

class ProfessionalCVPreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProfessionalCVPreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aperçu CV professionnel"),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Nom complet',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                data['title'] ?? 'Poste recherché',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (data['phone'] != null && data['phone'].isNotEmpty)
                          Text(
                            '📱 ${data['phone']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        if (data['email'] != null && data['email'].isNotEmpty)
                          Text(
                            '✉️ ${data['email']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        if (data['address'] != null && data['address'].isNotEmpty)
                          Text(
                            '📍 ${data['address']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Experience
              const Text(
                'Expérience professionnelle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (data['experience'] != null && data['experience'].isNotEmpty)
                Text(data['experience'])
              else
                const Text('Aucune expérience professionnelle renseignée'),
              
              const SizedBox(height: 16),
              
              // Education
              const Text(
                'Formation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (data['education'] != null && data['education'].isNotEmpty)
                Text(data['education'])
              else
                const Text('Aucune formation renseignée'),
              
              const SizedBox(height: 16),
              
              // Skills
              const Text(
                'Compétences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (data['skills'] != null && data['skills'].isNotEmpty)
                Text(data['skills'])
              else
                const Text('Aucune compétence renseignée'),
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
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(20),
                  decoration: pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [pw.Color.fromHex('#667eea'), pw.Color.fromHex('#764ba2')],
                      begin: pw.Alignment.topLeft,
                      end: pw.Alignment.bottomRight,
                    ),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 80,
                            height: 80,
                            decoration: pw.BoxDecoration(
                              color: pw.Colors.white.withOpacity(0.2),
                              borderRadius: pw.BorderRadius.circular(8),
                            ),
                            child: pw.Center(
                              child: pw.Icon(
                                pw.PdfIcons.person,
                                size: 40,
                                color: pw.Colors.white,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 16),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  data['name'] ?? 'Nom complet',
                                  style: pw.TextStyle(
                                    fontSize: 24,
                                    fontWeight: pw.FontWeight.bold,
                                    color: pw.Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                  data['title'] ?? 'Poste recherché',
                                  style: pw.TextStyle(
                                    fontSize: 16,
                                    color: pw.Color.fromRGBO(255, 255, 255, 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 16),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          if (data['phone'] != null && data['phone'].isNotEmpty)
                            pw.Text(
                              '📱 ${data['phone']}',
                              style: pw.TextStyle(color: pw.Color.fromRGBO(255, 255, 255, 1)),
                            ),
                          if (data['email'] != null && data['email'].isNotEmpty)
                            pw.Text(
                              '✉️ ${data['email']}',
                              style: pw.TextStyle(color: pw.Color.fromRGBO(255, 255, 255, 1)),
                            ),
                          if (data['address'] != null && data['address'].isNotEmpty)
                            pw.Text(
                              '📍 ${data['address']}',
                              style: pw.TextStyle(color: pw.Color.fromRGBO(255, 255, 255, 1)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 24),
                
                // Experience
                pw.Text(
                  'Expérience professionnelle',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                if (data['experience'] != null && data['experience'].isNotEmpty)
                  pw.Text(data['experience'])
                else
                  pw.Text('Aucune expérience professionnelle renseignée'),
                
                pw.SizedBox(height: 16),
                
                // Education
                pw.Text(
                  'Formation',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                if (data['education'] != null && data['education'].isNotEmpty)
                  pw.Text(data['education'])
                else
                  pw.Text('Aucune formation renseignée'),
                
                pw.SizedBox(height: 16),
                
                // Skills
                pw.Text(
                  'Compétences',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                if (data['skills'] != null && data['skills'].isNotEmpty)
                  pw.Text(data['skills'])
                else
                  pw.Text('Aucune compétence renseignée'),
              ],
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
      subject: 'Curriculum Vitae',
      text: 'Voici mon CV',
    );
  }
}