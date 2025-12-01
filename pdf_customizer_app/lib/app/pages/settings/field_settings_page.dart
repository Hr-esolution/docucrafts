import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/dynamic_document_model.dart';

class FieldSettingsPage extends StatefulWidget {
  const FieldSettingsPage({Key? key}) : super(key: key);

  @override
  State<FieldSettingsPage> createState() => _FieldSettingsPageState();
}

class _FieldSettingsPageState extends State<FieldSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres des Champs'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
  }

  Widget _buildDocumentTypeSection(
    String title,
    String documentType,
    List<DocumentField> fields,
    Function(String documentType, String fieldId) onToggle,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...fields.map((field) => _buildFieldToggle(
                  field,
                  documentType,
                  onToggle,
                )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldToggle(
    DocumentField field,
    String documentType,
    Function(String documentType, String fieldId) onToggle,
  ) {
    return ListTile(
      title: Text(field.label),
      trailing: Switch(
        value: field.isEnabled,
        onChanged: (value) {
          onToggle(documentType, field.id);
        },
      ),
    );
  }
}