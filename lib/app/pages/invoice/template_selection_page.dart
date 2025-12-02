import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/invoice_controller.dart';

class TemplateSelectionPage extends StatelessWidget {
  const TemplateSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionnez un modèle'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choisissez un modèle de facture :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildTemplateCard(
                    title: 'Modèle Standard',
                    description: 'Modèle classique avec tous les éléments essentiels',
                    icon: Icons.receipt,
                    onTap: () {
                      controller.selectTemplate('standard');
                      Get.back(result: 'standard');
                    },
                  ),
                  _buildTemplateCard(
                    title: 'Modèle Minimal',
                    description: 'Modèle simple et épuré',
                    icon: Icons.minimize,
                    onTap: () {
                      controller.selectTemplate('minimal');
                      Get.back(result: 'minimal');
                    },
                  ),
                  _buildTemplateCard(
                    title: 'Modèle Multi-Articles',
                    description: 'Pour les factures avec plusieurs lignes d\'articles',
                    icon: Icons.list_alt,
                    onTap: () {
                      controller.selectTemplate('multi');
                      Get.back(result: 'multi');
                    },
                  ),
                  _buildTemplateCard(
                    title: 'Modèle Premium',
                    description: 'Design élégant avec logo et mise en page avancée',
                    icon: Icons.star,
                    onTap: () {
                      controller.selectTemplate('premium');
                      Get.back(result: 'premium');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: Icon(
                  icon,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
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
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
      ),
    );
  }
}