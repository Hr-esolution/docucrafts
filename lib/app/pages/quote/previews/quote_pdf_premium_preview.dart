import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/models/dynamic_document_model.dart';
import 'package:pdf_customizer_app/app/repositories/storage_repository.dart';
import 'package:pdf_customizer_app/app/controllers/quote_controller.dart';

class PremiumQuotePreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const PremiumQuotePreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final QuoteController controller = Get.find();
    final StorageRepository storageRepository = StorageRepository();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Aperçu Devis Premium"),
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
                id: 'quote_${DateTime.now().millisecondsSinceEpoch}',
                type: 'quote',
                title: data['quote_title'] ?? 'Nouveau Devis',
                fields: controller.fields.toList(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                await storageRepository.saveDocument(document);
                Get.snackbar('Succès', 'Devis enregistré avec succès');
              } catch (e) {
                Get.snackbar('Erreur', 'Échec de l\'enregistrement du devis: $e');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.generateQuotePdf(),
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
                      data['quote_title'] ?? 'Devis',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Numéro: ${data['quote_number'] ?? ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Date: ${data['issue_date'] ?? ''}',
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
                          Text('Nom: ${data['seller_name'] ?? ''}'),
                          Text('Adresse: ${data['seller_address'] ?? ''}'),
                          Text('Téléphone: ${data['seller_phone'] ?? ''}'),
                          Text('Email: ${data['seller_email'] ?? ''}'),
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
                          Text('Nom: ${data['buyer_name'] ?? ''}'),
                          Text('Adresse: ${data['buyer_address'] ?? ''}'),
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
                        Text('Description: ${data['item_description'] ?? ''}'),
                        Text('Quantité: ${data['item_quantity'] ?? ''}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Prix unitaire: ${data['item_unit_price'] ?? ''}'),
                        Text('TVA: ${data['vat_rate'] ?? ''}%'),
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
      ),
    );
  }
}