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
      // Invoice Templates
      Template(
        id: 'invoice_default_1',
        name: 'Standard Invoice',
        description: 'A clean and professional invoice template',
        category: 'invoice',
        previewImage: 'assets/images/logo.png',
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
        id: 'invoice_modern_1',
        name: 'Modern Invoice',
        description: 'A modern and sleek invoice template',
        category: 'invoice',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_logo', 'label': 'Company Logo', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'invoice_number', 'label': 'Invoice Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'invoice_date', 'label': 'Invoice Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'due_date', 'label': 'Due Date', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'payment_terms', 'label': 'Payment Terms', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'invoice_business_1',
        name: 'Business Invoice',
        description: 'A formal business invoice template',
        category: 'invoice',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_logo', 'label': 'Company Logo', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_phone', 'label': 'Company Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_email', 'label': 'Company Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_phone', 'label': 'Client Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'client_email', 'label': 'Client Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'invoice_number', 'label': 'Invoice Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'invoice_date', 'label': 'Invoice Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'due_date', 'label': 'Due Date', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'tax_rate', 'label': 'Tax Rate (%)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'discount', 'label': 'Discount (%)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'payment_terms', 'label': 'Payment Terms', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Quote Templates
      Template(
        id: 'quote_default_1',
        name: 'Professional Quote',
        description: 'A comprehensive quote template',
        category: 'quote',
        previewImage: 'assets/images/logo.png',
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
        id: 'quote_modern_1',
        name: 'Modern Quote',
        description: 'A modern quote template with enhanced features',
        category: 'quote',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_logo', 'label': 'Company Logo', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'quote_number', 'label': 'Quote Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'quote_date', 'label': 'Quote Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'valid_until', 'label': 'Valid Until', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'payment_terms', 'label': 'Payment Terms', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'quote_business_1',
        name: 'Business Quote',
        description: 'A formal business quote template',
        category: 'quote',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_logo', 'label': 'Company Logo', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_phone', 'label': 'Company Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_email', 'label': 'Company Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'client_name', 'label': 'Client Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_address', 'label': 'Client Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'client_phone', 'label': 'Client Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'client_email', 'label': 'Client Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'quote_number', 'label': 'Quote Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'quote_date', 'label': 'Quote Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'valid_until', 'label': 'Valid Until', 'type': 'date', 'isRequired': false, 'isEnabled': true},
          {'id': 'tax_rate', 'label': 'Tax Rate (%)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'discount', 'label': 'Discount (%)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'payment_terms', 'label': 'Payment Terms', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Delivery Templates
      Template(
        id: 'delivery_default_1',
        name: 'Delivery Note',
        description: 'Simple delivery note template',
        category: 'delivery',
        previewImage: 'assets/images/logo.png',
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
      Template(
        id: 'delivery_detailed_1',
        name: 'Detailed Delivery',
        description: 'A detailed delivery note with item tracking',
        category: 'delivery',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_phone', 'label': 'Company Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'recipient_name', 'label': 'Recipient Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_address', 'label': 'Recipient Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_phone', 'label': 'Recipient Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'delivery_number', 'label': 'Delivery Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_date', 'label': 'Delivery Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_by', 'label': 'Delivery By', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'items_count', 'label': 'Number of Items', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'total_weight', 'label': 'Total Weight (kg)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'delivery_business_1',
        name: 'Business Delivery',
        description: 'A formal business delivery template',
        category: 'delivery',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'company_logo', 'label': 'Company Logo', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_name', 'label': 'Company Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_address', 'label': 'Company Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company_phone', 'label': 'Company Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'company_email', 'label': 'Company Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'recipient_name', 'label': 'Recipient Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_address', 'label': 'Recipient Address', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'recipient_phone', 'label': 'Recipient Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'recipient_email', 'label': 'Recipient Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'delivery_number', 'label': 'Delivery Number', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_date', 'label': 'Delivery Date', 'type': 'date', 'isRequired': true, 'isEnabled': true},
          {'id': 'delivery_time', 'label': 'Delivery Time', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'delivery_by', 'label': 'Delivery By', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'driver_name', 'label': 'Driver Name', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'vehicle_number', 'label': 'Vehicle Number', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'items_count', 'label': 'Number of Items', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'total_weight', 'label': 'Total Weight (kg)', 'type': 'number', 'isRequired': false, 'isEnabled': true},
          {'id': 'notes', 'label': 'Notes', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // Business Card Templates
      Template(
        id: 'business_card_basic_1',
        name: 'Basic Business Card',
        description: 'Simple and clean business card template',
        category: 'business_card',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company', 'label': 'Company', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'business_card_professional_1',
        name: 'Professional Business Card',
        description: 'Professional business card with social links',
        category: 'business_card',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company', 'label': 'Company', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'website', 'label': 'Website', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'linkedin', 'label': 'LinkedIn Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'twitter', 'label': 'Twitter Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'business_card_creative_1',
        name: 'Creative Business Card',
        description: 'Creative business card with extended information',
        category: 'business_card',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'company', 'label': 'Company', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'mobile', 'label': 'Mobile', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'website', 'label': 'Website', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'linkedin', 'label': 'LinkedIn Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'twitter', 'label': 'Twitter Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'instagram', 'label': 'Instagram Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'facebook', 'label': 'Facebook Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      // CV Templates
      Template(
        id: 'cv_basic_1',
        name: 'Basic CV',
        description: 'Simple and clean CV template',
        category: 'cv',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'summary', 'label': 'Professional Summary', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'experience', 'label': 'Work Experience', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'education', 'label': 'Education', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'skills', 'label': 'Skills', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'cv_professional_1',
        name: 'Professional CV',
        description: 'Professional CV with detailed sections',
        category: 'cv',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'linkedin', 'label': 'LinkedIn Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'summary', 'label': 'Professional Summary', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'experience', 'label': 'Work Experience', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'education', 'label': 'Education', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'skills', 'label': 'Skills', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'certifications', 'label': 'Certifications', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'languages', 'label': 'Languages', 'type': 'text', 'isRequired': false, 'isEnabled': true},
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Template(
        id: 'cv_modern_1',
        name: 'Modern CV',
        description: 'Modern CV with enhanced design elements',
        category: 'cv',
        previewImage: 'assets/images/logo.png',
        fields: [
          {'id': 'full_name', 'label': 'Full Name', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'job_title', 'label': 'Job Title', 'type': 'text', 'isRequired': true, 'isEnabled': true},
          {'id': 'phone', 'label': 'Phone', 'type': 'phone', 'isRequired': false, 'isEnabled': true},
          {'id': 'email', 'label': 'Email', 'type': 'email', 'isRequired': false, 'isEnabled': true},
          {'id': 'website', 'label': 'Website', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'address', 'label': 'Address', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'linkedin', 'label': 'LinkedIn Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'twitter', 'label': 'Twitter Profile', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'summary', 'label': 'Professional Summary', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'experience', 'label': 'Work Experience', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'education', 'label': 'Education', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'skills', 'label': 'Skills', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'certifications', 'label': 'Certifications', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'languages', 'label': 'Languages', 'type': 'text', 'isRequired': false, 'isEnabled': true},
          {'id': 'hobbies', 'label': 'Hobbies', 'type': 'text', 'isRequired': false, 'isEnabled': true},
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