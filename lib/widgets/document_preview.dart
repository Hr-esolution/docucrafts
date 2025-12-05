import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/document_model.dart';
import '../models/template_model.dart';
import '../services/template_service.dart';

class DocumentPreview extends StatelessWidget {
  final DocumentModel document;
  final TemplateModel? template;

  const DocumentPreview({
    Key? key,
    required this.document,
    this.template,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.grey, width: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildPreviewContent(),
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    // Get the values from the document fields
    final values = document.fields;
    
    // Build the preview based on the document type
    switch (document.type) {
      case 'invoice':
        return _buildInvoicePreview(values);
      case 'quote':
        return _buildQuotePreview(values);
      case 'delivery':
        return _buildDeliveryPreview(values);
      case 'business_card':
        return _buildBusinessCardPreview(values);
      case 'cv':
        return _buildCVPreview(values);
      default:
        return _buildGenericPreview(values);
    }
  }

  Widget _buildInvoicePreview(Map<String, dynamic> values) {
    Color color = const Color(0xFF2E7D32); // Default green color
    
    if (template != null) {
      try {
        String colorHex = template!.style['color'] ?? '#2E7D32';
        color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  values['companyName'] ?? 'Company Name',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'INVOICE',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Company and Client Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['companyName'] ?? ''),
                  Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bill To:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['clientName'] ?? ''),
                  Text(values['clientAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Invoice #:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['invoiceNumber'] ?? ''),
                  const SizedBox(height: 8),
                  const Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['date'] ?? ''),
                  const SizedBox(height: 8),
                  const Text(
                    'Due Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['dueDate'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Items Table
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(values['itemDescription'] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(values['quantity']?.toString() ?? '0'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('\$${values['price']?.toString() ?? '0.00'}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('\$${values['total']?.toString() ?? '0.00'}'),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Notes and Total
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['notes'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total: \$${values['total']?.toString() ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildQuotePreview(Map<String, dynamic> values) {
    Color color = const Color(0xFFFF8F00); // Default orange color
    
    if (template != null) {
      try {
        String colorHex = template!.style['color'] ?? '#FF8F00';
        color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  values['companyName'] ?? 'Company Name',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'QUOTE',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Company and Client Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['companyName'] ?? ''),
                  Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'To:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['clientName'] ?? ''),
                  Text(values['clientAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quote #:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['quoteNumber'] ?? ''),
                  const SizedBox(height: 8),
                  const Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['date'] ?? ''),
                  const SizedBox(height: 8),
                  const Text(
                    'Valid Until:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['validUntil'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Items Table
        Table(
          border: TableBorder.all(),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            const TableRow(
              decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Price', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(values['itemDescription'] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(values['quantity']?.toString() ?? '0'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('\$${values['price']?.toString() ?? '0.00'}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('\$${values['total']?.toString() ?? '0.00'}'),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Notes and Total
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['notes'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total: \$${values['total']?.toString() ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildDeliveryPreview(Map<String, dynamic> values) {
    Color color = const Color(0xFF4527A0); // Default purple color
    
    if (template != null) {
      try {
        String colorHex = template!.style['color'] ?? '#4527A0';
        color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  values['companyName'] ?? 'Company Name',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'DELIVERY NOTE',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Company and Recipient Info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['companyName'] ?? ''),
                  Text(values['companyAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'To:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(values['recipientName'] ?? ''),
                  Text(values['recipientAddress'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery #:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['deliveryNumber'] ?? ''),
                  const SizedBox(height: 8),
                  const Text(
                    'Date:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['date'] ?? ''),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Items
        const Text(
          'Items',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(values['items'] ?? 'No items specified'),
        ),
        
        const SizedBox(height: 16),
        
        // Notes and Signature
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(values['deliveryNotes'] ?? ''),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Signature:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),
                  const SizedBox(height: 30),
                  Text(values['signature'] ?? '________________'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBusinessCardPreview(Map<String, dynamic> values) {
    Color color = const Color(0xFF37474F); // Default dark gray color
    
    if (template != null) {
      try {
        String colorHex = template!.style['color'] ?? '#37474F';
        color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return Center(
      child: Container(
        width: 300,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                values['fullName'] ?? 'Full Name',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                values['jobTitle'] ?? 'Job Title',
                style: TextStyle(fontSize: 12, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                values['companyName'] ?? 'Company Name',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('📱 ${values['phone'] ?? ''}'),
                  Text('✉️ ${values['email'] ?? ''}'),
                  Text('🌐 ${values['website'] ?? ''}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCVPreview(Map<String, dynamic> values) {
    Color color = const Color(0xFF5D4037); // Default brown color
    
    if (template != null) {
      try {
        String colorHex = template!.style['color'] ?? '#5D4037';
        color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (e) {
        // Use default color if parsing fails
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      values['fullName'] ?? 'Full Name',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      values['jobTitle'] ?? 'Professional Title',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Contact Info
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📧 ${values['email'] ?? ''}'),
                  Text('📞 ${values['phone'] ?? ''}'),
                  Text('📍 ${values['address'] ?? ''}'),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Summary
        const Text(
          'PROFESSIONAL SUMMARY',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(values['summary'] ?? ''),
        
        const SizedBox(height: 12),
        
        // Experience
        const Text(
          'WORK EXPERIENCE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(values['experience'] is List ? (values['experience'] as List).join(', ') : values['experience']?.toString() ?? 'No experience listed'),
        
        const SizedBox(height: 12),
        
        // Education
        const Text(
          'EDUCATION',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(values['education'] is List ? (values['education'] as List).join(', ') : values['education']?.toString() ?? 'No education listed'),
        
        const SizedBox(height: 12),
        
        // Skills
        const Text(
          'SKILLS',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: (values['skills'] is List ? (values['skills'] as List).map((skill) => skill.toString()).toList() : (values['skills']?.toString() ?? 'No skills listed').split(','))
              .map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      skill.trim(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildGenericPreview(Map<String, dynamic> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document Preview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...values.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(entry.value?.toString() ?? ''),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}