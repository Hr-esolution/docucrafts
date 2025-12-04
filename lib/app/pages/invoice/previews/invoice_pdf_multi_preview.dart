import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/pages/invoice/templates/invoice_pdf_multi.dart';
import 'package:pdf_customizer_app/app/models/dynamic_document_model.dart';
import 'package:pdf_customizer_app/app/repositories/storage_repository.dart';
import 'package:pdf_customizer_app/app/controllers/invoice_controller.dart';

class MultiInvoicePreview extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<InvoiceItem> items;

  const MultiInvoicePreview(
      {super.key, required this.data, required this.items});

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find();
    final StorageRepository storageRepository = StorageRepository();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Aperçu Facture Multi-Articles"),
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
                id: 'invoice_${DateTime.now().millisecondsSinceEpoch}',
                type: 'invoice',
                title: data['invoice_title'] ?? 'Nouvelle Facture',
                fields: controller.fields.toList(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              try {
                await storageRepository.saveDocument(document);
                Get.snackbar('Succès', 'Facture enregistrée avec succès');
              } catch (e) {
                Get.snackbar('Erreur', 'Échec de l\'enregistrement de la facture: $e');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.generateInvoicePdf(),
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
          child: Column(
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
                      data['invoice_title'] ?? 'Facture',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Numéro: ${data['invoice_number'] ?? ''}',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Articles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          children: items.map((item) {
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text("Qté: ${item.qty} • PU: ${item.price}"),
                              trailing: Text("${item.total.toStringAsFixed(2)} DH"),
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 20),
                      Text(
                        "TOTAL : ${data["totalTtc"]} DH",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
