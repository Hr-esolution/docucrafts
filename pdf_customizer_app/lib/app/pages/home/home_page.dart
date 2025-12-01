import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Créer un nouveau document',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildDocumentCard(
              title: 'Facture',
              icon: Icons.receipt,
              color: Colors.blue,
              onTap: () => controller.navigateToDocument('invoice'),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'Devis',
              icon: Icons.description,
              color: Colors.green,
              onTap: () => controller.navigateToDocument('quote'),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'Bon de Livraison',
              icon: Icons.local_shipping,
              color: Colors.orange,
              onTap: () => controller.navigateToDocument('delivery'),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'Carte de Visite',
              icon: Icons.card_membership,
              color: Colors.purple,
              onTap: () => controller.navigateToDocument('business_card'),
            ),
            const SizedBox(height: 16),
            _buildDocumentCard(
              title: 'CV',
              icon: Icons.person,
              color: Colors.teal,
              onTap: () => controller.navigateToDocument('cv'),
            ),
          ],
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          foregroundColor: color,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}