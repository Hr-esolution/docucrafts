import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/controllers/business_card_controller.dart';
import 'package:pdf_customizer_app/app/controllers/cv_controller.dart';
import 'package:pdf_customizer_app/app/controllers/delivery_controller.dart';
import 'package:pdf_customizer_app/app/controllers/invoice_controller.dart';
import 'package:pdf_customizer_app/app/controllers/quote_controller.dart';
import '../../models/dynamic_document_model.dart';
import 'dart:ui';

class FieldSettingsPage extends StatefulWidget {
  const FieldSettingsPage({super.key});

  @override
  State<FieldSettingsPage> createState() => _FieldSettingsPageState();
}

class _FieldSettingsPageState extends State<FieldSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Paramètres des Champs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.blue.withOpacity(0.05),
              Colors.indigo.withOpacity(0.03),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                _buildDocumentTypeSection(
                  'Facture',
                  'invoice',
                  _getFields('invoice'),
                  _toggleFieldEnablement,
                ),
                const SizedBox(height: 20),
                _buildDocumentTypeSection(
                  'Devis',
                  'quote',
                  _getFields('quote'),
                  _toggleFieldEnablement,
                ),
                const SizedBox(height: 20),
                _buildDocumentTypeSection(
                  'Bon de Livraison',
                  'delivery',
                  _getFields('delivery'),
                  _toggleFieldEnablement,
                ),
                const SizedBox(height: 20),
                _buildDocumentTypeSection(
                  'Carte de Visite',
                  'business_card',
                  _getFields('business_card'),
                  _toggleFieldEnablement,
                ),
                const SizedBox(height: 20),
                _buildDocumentTypeSection(
                  'CV',
                  'cv',
                  _getFields('cv'),
                  _toggleFieldEnablement,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<DocumentField> _getFields(String documentType) {
    switch (documentType) {
      case 'invoice':
        final controller = Get.find<InvoiceController>();
        return controller.fields;
      case 'quote':
        final controller = Get.find<QuoteController>();
        return controller.fields;
      case 'delivery':
        final controller = Get.find<DeliveryController>();
        return controller.fields;
      case 'business_card':
        final controller = Get.find<BusinessCardController>();
        return controller.fields;
      case 'cv':
        final controller = Get.find<CvController>();
        return controller.fields;
      default:
        return [];
    }
  }

  void _toggleFieldEnablement(String documentType, String fieldId) {
    switch (documentType) {
      case 'invoice':
        final controller = Get.find<InvoiceController>();
        controller.toggleFieldEnablement(fieldId);
        break;
      case 'quote':
        final controller = Get.find<QuoteController>();
        controller.toggleFieldEnablement(fieldId);
        break;
      case 'delivery':
        final controller = Get.find<DeliveryController>();
        controller.toggleFieldEnablement(fieldId);
        break;
      case 'business_card':
        final controller = Get.find<BusinessCardController>();
        controller.toggleFieldEnablement(fieldId);
        break;
      case 'cv':
        final controller = Get.find<CvController>();
        controller.toggleFieldEnablement(fieldId);
        break;
    }
    // Forcer la mise à jour UI
    setState(() {});
  }

  Widget _buildDocumentTypeSection(
    String title,
    String documentType,
    List<DocumentField> fields,
    Function(String documentType, String fieldId) onToggle,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.2),
                        Colors.indigo.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...fields.map((field) => _buildFieldToggle(
                      field,
                      documentType,
                      onToggle,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldToggle(
    DocumentField field,
    String documentType,
    Function(String documentType, String fieldId) onToggle,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              field.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Switch(
              value: field.isEnabled,
              onChanged: (value) {
                onToggle(documentType, field.id);
              },
              activeColor: Colors.blue,
              activeTrackColor: Colors.blue.withOpacity(0.3),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
          ),
        ),
      ),
    );
  }
}
