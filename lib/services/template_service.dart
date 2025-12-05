import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/field_model.dart';
import '../models/template_model.dart';

class TemplateService {
  static const String _templatesKey = 'saved_templates';

  Future<List<TemplateModel>> loadTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_templatesKey);

    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((template) => TemplateModel.fromMap(template.cast<String, dynamic>()))
            .toList();
      } catch (e) {
        print('Error loading templates: $e');
        return [];
      }
    }

    // Return default templates if none found
    return _getDefaultTemplates();
  }

  Future<void> saveTemplates(List<TemplateModel> templates) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(templates.map((template) => template.toMap()).toList());
    await prefs.setString(_templatesKey, jsonString);
  }

  List<TemplateModel> _getDefaultTemplates() {
    // Define default templates for different document types
    return [
      // Invoice Templates
      TemplateModel(
        id: 'invoice_basic',
        name: 'Basic Invoice',
        documentType: 'invoice',
        previewImage: 'assets/images/invoice.png',
        fields: [
          FieldModel(name: 'companyName', label: 'Company Name', type: 'text', required: true),
          FieldModel(name: 'companyAddress', label: 'Company Address', type: 'text', required: true),
          FieldModel(name: 'clientName', label: 'Client Name', type: 'text', required: true),
          FieldModel(name: 'clientAddress', label: 'Client Address', type: 'text', required: true),
          FieldModel(name: 'invoiceNumber', label: 'Invoice Number', type: 'text', required: true),
          FieldModel(name: 'date', label: 'Date', type: 'date', required: true),
          FieldModel(name: 'dueDate', label: 'Due Date', type: 'date'),
          FieldModel(name: 'itemDescription', label: 'Item Description', type: 'text', required: true),
          FieldModel(name: 'quantity', label: 'Quantity', type: 'number', required: true),
          FieldModel(name: 'price', label: 'Price', type: 'number', required: true),
          FieldModel(name: 'total', label: 'Total', type: 'number', required: true),
          FieldModel(name: 'notes', label: 'Notes', type: 'textarea'),
        ],
        style: {
          'color': '#2E7D32',
          'fontSize': 14.0,
          'headerStyle': 'basic',
        },
      ),
      TemplateModel(
        id: 'invoice_modern',
        name: 'Modern Invoice',
        documentType: 'invoice',
        previewImage: 'assets/images/invoice.png',
        fields: [
          FieldModel(name: 'companyName', label: 'Company Name', type: 'text', required: true),
          FieldModel(name: 'companyLogo', label: 'Company Logo', type: 'image'),
          FieldModel(name: 'companyAddress', label: 'Company Address', type: 'text', required: true),
          FieldModel(name: 'clientName', label: 'Client Name', type: 'text', required: true),
          FieldModel(name: 'clientAddress', label: 'Client Address', type: 'text', required: true),
          FieldModel(name: 'invoiceNumber', label: 'Invoice Number', type: 'text', required: true),
          FieldModel(name: 'date', label: 'Date', type: 'date', required: true),
          FieldModel(name: 'dueDate', label: 'Due Date', type: 'date'),
          FieldModel(name: 'items', label: 'Items', type: 'table', required: true),
          FieldModel(name: 'subtotal', label: 'Subtotal', type: 'number'),
          FieldModel(name: 'tax', label: 'Tax', type: 'number'),
          FieldModel(name: 'total', label: 'Total', type: 'number', required: true),
          FieldModel(name: 'paymentTerms', label: 'Payment Terms', type: 'textarea'),
        ],
        style: {
          'color': '#1565C0',
          'fontSize': 16.0,
          'headerStyle': 'modern',
        },
      ),
      
      // Quote Templates
      TemplateModel(
        id: 'quote_basic',
        name: 'Basic Quote',
        documentType: 'quote',
        previewImage: 'assets/images/quote.png',
        fields: [
          FieldModel(name: 'companyName', label: 'Company Name', type: 'text', required: true),
          FieldModel(name: 'companyAddress', label: 'Company Address', type: 'text', required: true),
          FieldModel(name: 'clientName', label: 'Client Name', type: 'text', required: true),
          FieldModel(name: 'clientAddress', label: 'Client Address', type: 'text', required: true),
          FieldModel(name: 'quoteNumber', label: 'Quote Number', type: 'text', required: true),
          FieldModel(name: 'date', label: 'Date', type: 'date', required: true),
          FieldModel(name: 'validUntil', label: 'Valid Until', type: 'date', required: true),
          FieldModel(name: 'itemDescription', label: 'Item Description', type: 'text', required: true),
          FieldModel(name: 'quantity', label: 'Quantity', type: 'number', required: true),
          FieldModel(name: 'price', label: 'Price', type: 'number', required: true),
          FieldModel(name: 'total', label: 'Total', type: 'number', required: true),
          FieldModel(name: 'notes', label: 'Notes', type: 'textarea'),
        ],
        style: {
          'color': '#FF8F00',
          'fontSize': 14.0,
          'headerStyle': 'basic',
        },
      ),
      
      // Delivery Templates
      TemplateModel(
        id: 'delivery_basic',
        name: 'Basic Delivery',
        documentType: 'delivery',
        previewImage: 'assets/images/delivery.png',
        fields: [
          FieldModel(name: 'companyName', label: 'Company Name', type: 'text', required: true),
          FieldModel(name: 'companyAddress', label: 'Company Address', type: 'text', required: true),
          FieldModel(name: 'recipientName', label: 'Recipient Name', type: 'text', required: true),
          FieldModel(name: 'recipientAddress', label: 'Recipient Address', type: 'text', required: true),
          FieldModel(name: 'deliveryNumber', label: 'Delivery Number', type: 'text', required: true),
          FieldModel(name: 'date', label: 'Date', type: 'date', required: true),
          FieldModel(name: 'items', label: 'Items', type: 'table', required: true),
          FieldModel(name: 'deliveryNotes', label: 'Delivery Notes', type: 'textarea'),
          FieldModel(name: 'signature', label: 'Signature', type: 'signature'),
        ],
        style: {
          'color': '#4527A0',
          'fontSize': 14.0,
          'headerStyle': 'basic',
        },
      ),
      
      // Business Card Templates
      TemplateModel(
        id: 'business_card_basic',
        name: 'Basic Business Card',
        documentType: 'business_card',
        previewImage: 'assets/images/business_card.png',
        fields: [
          FieldModel(name: 'fullName', label: 'Full Name', type: 'text', required: true),
          FieldModel(name: 'jobTitle', label: 'Job Title', type: 'text', required: true),
          FieldModel(name: 'companyName', label: 'Company Name', type: 'text', required: true),
          FieldModel(name: 'phone', label: 'Phone', type: 'text', required: true),
          FieldModel(name: 'email', label: 'Email', type: 'email', required: true),
          FieldModel(name: 'address', label: 'Address', type: 'text'),
          FieldModel(name: 'website', label: 'Website', type: 'url'),
          FieldModel(name: 'logo', label: 'Company Logo', type: 'image'),
        ],
        style: {
          'color': '#37474F',
          'fontSize': 12.0,
          'headerStyle': 'card',
        },
      ),
      
      // CV Templates
      TemplateModel(
        id: 'cv_basic',
        name: 'Basic CV',
        documentType: 'cv',
        previewImage: 'assets/images/cv.png',
        fields: [
          FieldModel(name: 'fullName', label: 'Full Name', type: 'text', required: true),
          FieldModel(name: 'jobTitle', label: 'Professional Title', type: 'text', required: true),
          FieldModel(name: 'email', label: 'Email', type: 'email', required: true),
          FieldModel(name: 'phone', label: 'Phone', type: 'text', required: true),
          FieldModel(name: 'address', label: 'Address', type: 'text'),
          FieldModel(name: 'summary', label: 'Professional Summary', type: 'textarea', required: true),
          FieldModel(name: 'experience', label: 'Work Experience', type: 'list', required: true),
          FieldModel(name: 'education', label: 'Education', type: 'list', required: true),
          FieldModel(name: 'skills', label: 'Skills', type: 'list', required: true),
          FieldModel(name: 'photo', label: 'Photo', type: 'image'),
        ],
        style: {
          'color': '#5D4037',
          'fontSize': 12.0,
          'headerStyle': 'professional',
        },
      ),
    ];
  }
}