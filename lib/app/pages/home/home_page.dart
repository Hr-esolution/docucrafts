import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Customizer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Templates Section
              const Text(
                'Templates',
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
                    title: 'Facture',
                    icon: Icons.receipt,
                    color: Colors.blue,
                    onTap: () => controller.navigateToDocument('invoice'),
                  ),
                  _buildTemplateCard(
                    title: 'Devis',
                    icon: Icons.description,
                    color: Colors.green,
                    onTap: () => controller.navigateToDocument('quote'),
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
                    onTap: () => controller.navigateToDocument('business_card'),
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

              // My Documents Section
              const Text(
                'Mes Documents',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.documents.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun document trouvé',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.documents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final document = controller.documents[index];
                    return _buildDocumentCard(
                      title: document.title,
                      icon: Icons.insert_drive_file,
                      color: Colors.grey,
                      onTap: () {
                        // Add functionality to view document
                        // For now, just show a snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Document: ${document.title}')),
                        );
                      },
                    );
                  },
                );
              }),
            ],
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
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
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
    );
  }

  Widget _buildDocumentCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
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
    );
  }
}
