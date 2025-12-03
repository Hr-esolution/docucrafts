import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/template.dart';

class TemplateRepository {
  static const String _templatesKey = 'templates';

  Future<List<Template>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = prefs.getStringList(_templatesKey) ?? [];
    
    return templatesJson
        .map((json) => Template.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> saveTemplate(Template template) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplates();
    
    // Check if template already exists
    final existingIndex = templates.indexWhere((t) => t.id == template.id);
    if (existingIndex != -1) {
      templates[existingIndex] = template;
    } else {
      templates.add(template);
    }
    
    final templatesJson = templates.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_templatesKey, templatesJson);
  }

  Future<void> deleteTemplate(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplates();
    
    templates.removeWhere((t) => t.id == id);
    
    final templatesJson = templates.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_templatesKey, templatesJson);
  }

  Future<void> addDefaultTemplates() async {
    final defaultTemplates = [
      Template(
        id: 'invoice_default_1',
        name: 'Standard Invoice',
        description: 'A clean and professional invoice template',
        category: 'invoice',
        previewImage: 'assets/templates/invoice_default.png',
        fields: [
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'invoice_number', 'label': 'Invoice Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'invoice_date', 'label': 'Invoice Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'due_date', 'label': 'Due Date', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'quote_default_1',
        name: 'Professional Quote',
        description: 'A comprehensive quote template',
        category: 'quote',
        previewImage: 'assets/templates/quote_default.png',
        fields: [
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'quote_number', 'label': 'Quote Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'quote_date', 'label': 'Quote Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'valid_until', 'label': 'Valid Until', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'delivery_default_1',
        name: 'Delivery Note',
        description: 'Simple delivery note template',
        category: 'delivery',
        previewImage: 'assets/templates/delivery_default.png',
        fields: [
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_name', 'label': 'Recipient Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_address', 'label': 'Recipient Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_number', 'label': 'Delivery Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_date', 'label': 'Delivery Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_by', 'label': 'Delivery By', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.containsKey(_templatesKey))) {
      for (final template in defaultTemplates) {
        await saveTemplate(template);
      }
    }
  }
}