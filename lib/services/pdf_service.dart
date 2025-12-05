import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/document_model.dart';
import '../models/template_model.dart';
import '../services/template_service.dart';

class PdfService {
  final TemplateService _templateService = TemplateService();

  Future<String> generatePdf(DocumentModel document) async {
    // Get the template for this document
    final templates = await _templateService.loadTemplates();
    final template = templates.firstWhere(
      (t) => t.id == document.templateId,
      orElse: () => templates.firstWhere(
        (t) => t.documentType == document.type,
        orElse: () => templates.first,
      ),
    );

    // Create the PDF
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return _buildDocumentContent(document, template); // Centered content
      },
    ));

    // Save the PDF to a file
    final bytes = await pdf.save();
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'document_${document.id}_${Uuid().v4()}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);

    return file.path;
  }

  pw.Widget _buildDocumentContent(DocumentModel document, TemplateModel template) {
    // Get the values from the document fields
    final values = document.fields;
    
    // Build the document based on the template type
    switch (document.type) {
      case 'invoice':
        return _buildInvoice(values, template);
      case 'quote':
        return _buildQuote(values, template);
      case 'delivery':
        return _buildDelivery(values, template);
      case 'business_card':
        return _buildBusinessCard(values, template);
      case 'cv':
        return _buildCV(values, template);
      default:
        return _buildGenericDocument(values, template);
    }
  }

  pw.Widget _buildInvoice(Map<String, dynamic> values, TemplateModel template) {
    final color = pw.ColorValue.hex(template.style['color'] ?? '#2E7D32');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          color: color,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  values['companyName'] ?? 'Company Name',
                  style: pw.TextStyle(fontSize: 20, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(fontSize: 24, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Company and Client Info
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'From:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['companyName'] ?? ''),
                  pw.Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Bill To:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['clientName'] ?? ''),
                  pw.Text(values['clientAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Invoice #:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['invoiceNumber'] ?? ''),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Date:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['date'] ?? ''),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Due Date:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['dueDate'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 30),
        
        // Items Table
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Table.fromTextArray(
                headers: ['Description', 'Qty', 'Price', 'Total'],
                data: [
                  [
                    values['itemDescription'] ?? '',
                    values['quantity']?.toString() ?? '',
                    '\$${values['price']?.toString() ?? '0.00'}',
                    '\$${values['total']?.toString() ?? '0.00'}',
                  ]
                ],
                border: pw.TableBorder.all(),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Notes and Total
        pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['notes'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total: \$${values['total']?.toString() ?? '0.00'}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildQuote(Map<String, dynamic> values, TemplateModel template) {
    final color = pw.ColorValue.hex(template.style['color'] ?? '#FF8F00');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          color: color,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  values['companyName'] ?? 'Company Name',
                  style: pw.TextStyle(fontSize: 20, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Text(
                'QUOTE',
                style: pw.TextStyle(fontSize: 24, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Company and Client Info
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'From:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['companyName'] ?? ''),
                  pw.Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'To:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['clientName'] ?? ''),
                  pw.Text(values['clientAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Quote #:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['quoteNumber'] ?? ''),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Date:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['date'] ?? ''),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Valid Until:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['validUntil'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 30),
        
        // Items Table
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Table.fromTextArray(
                headers: ['Description', 'Qty', 'Price', 'Total'],
                data: [
                  [
                    values['itemDescription'] ?? '',
                    values['quantity']?.toString() ?? '',
                    '\$${values['price']?.toString() ?? '0.00'}',
                    '\$${values['total']?.toString() ?? '0.00'}',
                  ]
                ],
                border: pw.TableBorder.all(),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Notes and Total
        pw.Row(
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['notes'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total: \$${values['total']?.toString() ?? '0.00'}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDelivery(Map<String, dynamic> values, TemplateModel template) {
    final color = pw.ColorValue.hex(template.style['color'] ?? '#4527A0');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          color: color,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Text(
                  values['companyName'] ?? 'Company Name',
                  style: pw.TextStyle(fontSize: 20, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Text(
                'DELIVERY NOTE',
                style: pw.TextStyle(fontSize: 24, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Company and Recipient Info
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'From:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['companyName'] ?? ''),
                  pw.Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'To:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(values['recipientName'] ?? ''),
                  pw.Text(values['recipientAddress'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Delivery #:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['deliveryNumber'] ?? ''),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Date:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['date'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 30),
        
        // Items
        pw.Expanded(
          child: pw.Column(
            children: [
              pw.Text(
                'Items',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
              ),
              pw.SizedBox(height: 10),
              pw.Bullet(
                child: pw.Text(values['items'] ?? 'No items specified'),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Notes and Signature
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Delivery Notes:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(values['deliveryNotes'] ?? ''),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    'Signature:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Divider(thickness: 1),
                  pw.SizedBox(height: 30),
                  pw.Text(values['signature'] ?? '________________'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildBusinessCard(Map<String, dynamic> values, TemplateModel template) {
    final color = pw.ColorValue.hex(template.style['color'] ?? '#37474F');
    
    return pw.Center(
      child: pw.Container(
        width: 300,
        height: 180,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: pw.ColorValue.grey),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
        ),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                values['fullName'] ?? 'Full Name',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                values['jobTitle'] ?? 'Job Title',
                style: pw.TextStyle(fontSize: 12, color: color),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                values['companyName'] ?? 'Company Name',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 15),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('📱 ${values['phone'] ?? ''}'),
                  pw.Text('✉️ ${values['email'] ?? ''}'),
                  pw.Text('🌐 ${values['website'] ?? ''}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  pw.Widget _buildCV(Map<String, dynamic> values, TemplateModel template) {
    final color = pw.ColorValue.hex(template.style['color'] ?? '#5D4037');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          color: color,
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      values['fullName'] ?? 'Full Name',
                      style: pw.TextStyle(fontSize: 24, color: pw.Colors.white, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      values['jobTitle'] ?? 'Professional Title',
                      style: pw.TextStyle(fontSize: 16, color: pw.Colors.white),
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: 80,
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                ),
              ),
            ],
          ),
        ),
        
        pw.SizedBox(height: 20),
        
        // Contact Info
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('📧 ${values['email'] ?? ''}'),
                  pw.Text('📞 ${values['phone'] ?? ''}'),
                  pw.Text('📍 ${values['address'] ?? ''}'),
                ],
              ),
            ),
          ],
        ),
        
        pw.SizedBox(height: 20),
        
        // Summary
        pw.Text(
          'PROFESSIONAL SUMMARY',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Text(values['summary'] ?? ''),
        
        pw.SizedBox(height: 15),
        
        // Experience
        pw.Text(
          'WORK EXPERIENCE',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Bullet(
          child: pw.Text(values['experience'] ?? 'No experience listed'),
        ),
        
        pw.SizedBox(height: 15),
        
        // Education
        pw.Text(
          'EDUCATION',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Bullet(
          child: pw.Text(values['education'] ?? 'No education listed'),
        ),
        
        pw.SizedBox(height: 15),
        
        // Skills
        pw.Text(
          'SKILLS',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
        ),
        pw.SizedBox(height: 5),
        pw.Wrap(
          children: (values['skills'] as String? ?? 'No skills listed')
              .split(',')
              .map((skill) => pw.Container(
                    margin: const pw.EdgeInsets.only(right: 8, bottom: 8),
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: pw.BoxDecoration(
                      color: color,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                    ),
                    child: pw.Text(
                      skill.trim(),
                      style: pw.TextStyle(color: pw.Colors.white, fontSize: 10),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  pw.Widget _buildGenericDocument(Map<String, dynamic> values, TemplateModel template) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Document Type: ${template.name}',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.BulletedList(
          children: values.entries.map((entry) => pw.Text('${entry.key}: ${entry.value}')).toList(),
        ),
      ],
    );
  }
}