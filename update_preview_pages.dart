import 'dart:io';

void main() {
  // Define the preview page paths to update
  List<String> previewPages = [
    '/workspace/lib/app/pages/quote/previews/quote_pdf_multi_preview.dart',
    '/workspace/lib/app/pages/quote/previews/quote_pdf_premium_preview.dart',
    '/workspace/lib/app/pages/delivery/previews/delivery_pdf_minimal_preview.dart',
    '/workspace/lib/app/pages/delivery/previews/delivery_pdf_multi_preview.dart',
    '/workspace/lib/app/pages/delivery/previews/delivery_pdf_premium_preview.dart',
    '/workspace/lib/app/pages/business_card/previews/business_card_pdf_minimal_preview.dart',
    '/workspace/lib/app/pages/business_card/previews/business_card_pdf_modern_preview.dart',
    '/workspace/lib/app/pages/business_card/previews/business_card_pdf_professional_preview.dart',
    '/workspace/lib/app/pages/cv/previews/cv_pdf_modern_preview.dart',
    '/workspace/lib/app/pages/cv/previews/cv_pdf_professional_preview.dart',
    '/workspace/lib/app/pages/cv/previews/cv_pdf_simple_preview.dart',
  ];

  for (String filePath in previewPages) {
    if (File(filePath).existsSync()) {
      updatePreviewPage(filePath);
    }
  }
  
  print('All preview pages have been updated!');
}

void updatePreviewPage(String filePath) {
  String content = File(filePath).readAsStringSync();
  
  // Check if the file already has the required imports
  if (content.contains('package:get/get.dart') && 
      content.contains('DynamicDocumentModel')) {
    print('Skipping $filePath - already updated');
    return;
  }
  
  // Determine document type from file path
  String docType = '';
  String controllerType = '';
  String generateFunction = '';
  
  if (filePath.contains('/quote/')) {
    docType = 'quote';
    controllerType = 'QuoteController';
    generateFunction = 'generateQuotePdf';
  } else if (filePath.contains('/delivery/')) {
    docType = 'delivery';
    controllerType = 'DeliveryController';
    generateFunction = 'generateDeliveryPdf';
  } else if (filePath.contains('/business_card/')) {
    docType = 'business_card';
    controllerType = 'BusinessCardController';
    generateFunction = 'generateBusinessCardPdf';
  } else if (filePath.contains('/cv/')) {
    docType = 'cv';
    controllerType = 'CvController';
    generateFunction = 'generateCvPdf';
  } else {
    docType = 'invoice';
    controllerType = 'InvoiceController';
    generateFunction = 'generateInvoicePdf';
  }
  
  // Add imports
  String newContent = content.replaceFirst(
    'import \'package:flutter/material.dart\';',
    '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/models/dynamic_document_model.dart';
import 'package:pdf_customizer_app/app/repositories/storage_repository.dart';
import 'package:pdf_customizer_app/app/controllers/${docType.contains('_') ? docType.split('_')[0] : docType}_controller.dart';'''
  );
  
  // Find the class name
  RegExp classNameRegex = RegExp(r'class\s+(\w+)\s+extends');
  Match? classNameMatch = classNameRegex.firstMatch(newContent);
  String className = classNameMatch?.group(1) ?? 'UnknownClass';
  
  // Add controller initialization
  String controllerInit = '''
    final ${controllerType} controller = Get.find();
    final StorageRepository storageRepository = StorageRepository();''';
  
  // Replace the build method start
  newContent = newContent.replaceFirst(
    RegExp(r'Widget build\(BuildContext context\) \{'),
    '''Widget build(BuildContext context) {
    final ${controllerType} controller = Get.find();
    final StorageRepository storageRepository = StorageRepository();'''
  );
  
  // Replace the scaffold
  String scaffoldReplacement = '''
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Aperçu ${_getDocumentTypeName(docType).toLowerCase()}"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              // Save the document with the current data
              final document = DynamicDocumentModel(
                id: '${docType}_${DateTime.now().millisecondsSinceEpoch}',
                type: '$docType',
                title: data['${docType}_title'] ?? 'Nouveau ${_getDocumentTypeName(docType)}',
                fields: controller.fields.toList(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                await storageRepository.saveDocument(document);
                Get.snackbar('Succès', '${_getDocumentTypeName(docType)} enregistré avec succès');
              } catch (e) {
                Get.snackbar('Erreur', 'Échec de l\'enregistrement du ${_getDocumentTypeName(docType).toLowerCase()}: \$e');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.$generateFunction(),
          ),
        ],
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Document header
              Container(
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
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['${docType}_title'] ?? '${_getDocumentTypeName(docType)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Numéro: \${data['${docType}_number'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Date: \${data['issue_date'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              // Seller and buyer information
              Row(
                children: [
                  Expanded(
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Vendeur',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Nom: \${data['seller_name'] ?? ''}'),
                          Text('Adresse: \${data['seller_address'] ?? ''}'),
                          Text('Téléphone: \${data['seller_phone'] ?? ''}'),
                          Text('Email: \${data['seller_email'] ?? ''}'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Client',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Nom: \${data['buyer_name'] ?? ''}'),
                          Text('Adresse: \${data['buyer_address'] ?? ''}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Items table
              Container(
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
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Description: \${data['item_description'] ?? ''}'),
                        Text('Quantité: \${data['item_quantity'] ?? ''}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Prix unitaire: \${data['item_unit_price'] ?? ''}'),
                        Text('TVA: \${data['vat_rate'] ?? ''}%'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total HT:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(data['subtotal_ht'] ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TVA:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(data['vat_amount'] ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total TTC:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(data['total_ttc'] ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),''';
  
  // Replace the Scaffold content
  RegExp scaffoldRegex = RegExp(r'body:\s*Padding\([^}]*\)');
  newContent = newContent.replaceFirst(scaffoldRegex, scaffoldReplacement);
  
  // Replace the Scaffold opening
  newContent = newContent.replaceFirst(
    RegExp(r'Scaffold\(\s*'),
    'Scaffold(\n      extendBodyBehindAppBar: true,\n      appBar: AppBar('
  );
  
  File(filePath).writeAsStringSync(newContent);
  print('Updated: $filePath');
}

String _getDocumentTypeName(String type) {
  switch (type) {
    case 'invoice':
      return 'Facture';
    case 'quote':
      return 'Devis';
    case 'delivery':
      return 'Bon de Livraison';
    case 'business_card':
      return 'Carte de Visite';
    case 'cv':
      return 'CV';
    default:
      return 'Document';
  }
}