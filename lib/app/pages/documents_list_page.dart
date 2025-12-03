import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../models/dynamic_document_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'document_details_page.dart'; // Added document details page import

class DocumentsListPage extends StatelessWidget {
  const DocumentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Documents'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Tous vos documents',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  if (controller.documents.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun document enregistré',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Commencez par créer un document',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.documents.length,
                    itemBuilder: (context, index) {
                      final document = controller.documents[index];
                      return GestureDetector(
                        onTap: () => Get.to(() => DocumentDetailsPage(document: document)),
                        child: _buildDocumentCard(document, context),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(DynamicDocumentModel document, BuildContext context) {
    String documentIcon = _getDocumentIcon(document.type);
    Color documentColor = _getDocumentColor(document.type);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
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
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            documentColor.withOpacity(0.3),
                            documentColor.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: documentColor.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        IconData(documentIcon.codeUnitAt(0), fontFamily: 'MaterialIcons'),
                        size: 25,
                        color: documentColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDocumentTypeName(document.type),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Créé le: ${_formatDate(document.createdAt)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.blue[600]),
                      onPressed: () => _shareDocument(document),
                      tooltip: 'Partager',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red[600]),
                      onPressed: () => _deleteDocument(document),
                      tooltip: 'Supprimer',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDocumentIcon(String type) {
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _shareDocument(DynamicDocumentModel document) async {
    try {
      // Pour une application hors ligne, on peut partager les informations du document
      String content = '''
Document: ${document.title}
Type: ${_getDocumentTypeName(document.type)}
Créé le: ${_formatDate(document.createdAt)}

Détails:
''';
      
      for (var field in document.fields) {
        if (field.value.isNotEmpty) {
          content += '${field.label}: ${field.value}\n';
        }
      }

      await Share.share(content, subject: 'Document - ${document.title}');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de partager le document: $e');
    }
  }

  Future<void> _deleteDocument(DynamicDocumentModel document) async {
    Get.defaultDialog(
      title: "Confirmer la suppression",
      middleText: "Voulez-vous vraiment supprimer le document \"${document.title}\" ?",
      textConfirm: "Supprimer",
      textCancel: "Annuler",
      confirm: () {
        final HomeController controller = Get.find<HomeController>();
        controller.documents.remove(document);
        // Ici, vous pouvez aussi supprimer du stockage local
        // await controller.deleteDocumentFromStorage(document.id);
        Get.back();
        Get.snackbar('Succès', 'Document supprimé avec succès');
      },
      cancel: () => Get.back(),
      barrierDismissible: true,
    );
  }
}