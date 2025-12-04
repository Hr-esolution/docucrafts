import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import 'dart:ui';
import '../document_details_page.dart'; // Added document details page import

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text('DocuCrafts'),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
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
              Colors.purple.withOpacity(0.03),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Welcome Section
                const Text(
                  'Bienvenue sur DocuCrafts',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez vos documents professionnels en toute simplicité',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Document Types Section
                const Text(
                  'Types de Documents',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildTemplateCard(
                      title: 'Devis',
                      icon: Icons.description,
                      color: Colors.green,
                      onTap: () => controller.navigateToDocument('quote'),
                    ),
                    _buildTemplateCard(
                      title: 'Facture',
                      icon: Icons.receipt,
                      color: Colors.blue,
                      onTap: () => controller.navigateToDocument('invoice'),
                    ),
                    _buildTemplateCard(
                      title: 'Bon de Livraison',
                      icon: Icons.local_shipping,
                      color: Colors.orange,
                      onTap: () => controller.navigateToDocument('delivery'),
                    ),
                    _buildTemplateCard(
                      title: 'Carte de Visite',
                      icon: Icons.card_membership,
                      color: Colors.purple,
                      onTap: () =>
                          controller.navigateToDocument('business_card'),
                    ),
                    _buildTemplateCard(
                      title: 'CV',
                      icon: Icons.person,
                      color: Colors.teal,
                      onTap: () => controller.navigateToDocument('cv'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Gestion Section
                const Text(
                  'Gestion',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  title: 'Gestion Produits',
                  subtitle: 'Ajouter, modifier ou supprimer vos produits',
                  icon: Icons.inventory,
                  color: Colors.amber,
                  onTap: () => Get.toNamed('/products'),
                ),
                const SizedBox(height: 16),
                _buildSettingsCard(
                  title: 'Configuration Documents',
                  subtitle: 'Personnaliser les champs et modèles',
                  icon: Icons.settings_applications,
                  color: Colors.indigo,
                  onTap: () => Get.toNamed('/settings'),
                ),
                const SizedBox(height: 30),

                // My Documents Section
                const Text(
                  'Mes Documents',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.toNamed('/documents'),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_forward_ios, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Voir tous les documents',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.documents.isEmpty) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.4),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Aucun document trouvé',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.documents.length > 4
                        ? 4
                        : controller.documents
                            .length, // Afficher seulement les 4 premiers documents
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final document = controller.documents[index];
                      return _buildDocumentCard(
                        title: document.title,
                        icon: _getDocumentIcon(document.type),
                        color: _getDocumentColor(document.type),
                        onTap: () {
                          _showDocumentDetails(document, context);
                        },
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      _getDocumentIconByTitle(title),
                      size: 30,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
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
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 25,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
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
        ),
      ),
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.3),
                          color.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 30,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'invoice':
        return Icons.receipt;
      case 'quote':
        return Icons.description;
      case 'delivery':
        return Icons.local_shipping;
      case 'business_card':
        return Icons.card_membership;
      case 'cv':
        return Icons.person;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String type) {
    switch (type) {
      case 'invoice':
        return Colors.blue;
      case 'quote':
        return Colors.green;
      case 'delivery':
        return Colors.orange;
      case 'business_card':
        return Colors.purple;
      case 'cv':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getDocumentIconByTitle(String title) {
    switch (title) {
      case 'Devis':
        return Icons.description;
      case 'Facture':
        return Icons.receipt;
      case 'Bon de Livraison':
        return Icons.local_shipping;
      case 'Carte de Visite':
        return Icons.card_membership;
      case 'CV':
        return Icons.person;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showDocumentDetails(dynamic document, BuildContext context) {
    Get.to(() => DocumentDetailsPage(document: document));
  }
}
