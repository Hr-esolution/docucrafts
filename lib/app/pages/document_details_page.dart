import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../controllers/home_controller.dart';
import 'package:share_plus/share_plus.dart';

class DocumentDetailsPage extends StatelessWidget {
  final DynamicDocumentModel document;

  const DocumentDetailsPage({Key? key, required this.document})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Document'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareDocument(document),
            tooltip: 'Partager',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildDocumentHeader(),
              const SizedBox(height: 20),
              Expanded(child: _buildDocumentContent()),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _printDocument(document),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.print),
            heroTag: "print",
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _shareDocument(document),
            backgroundColor: Colors.green,
            child: const Icon(Icons.share),
            heroTag: "share",
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _deleteDocument(controller, document),
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete),
            heroTag: "delete",
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------
  // HEADER
  // ---------------------------------------------
  Widget _buildDocumentHeader() {
    Color color = _getDocumentColor(document.type);
    IconData icon = _getDocumentIcon(document.type);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.4)),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDocumentTypeName(document.type),
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoItem(Icons.calendar_today, 'Créé le',
                  _formatDate(document.createdAt)),
              _buildInfoItem(
                  Icons.update, 'Modifié le', _formatDate(document.updatedAt)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            "$label: $value",
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------
  // CONTENT
  // ---------------------------------------------
  Widget _buildDocumentContent() {
    List<DocumentField> filledFields =
        document.fields.where((field) => field.value.isNotEmpty).toList();

    if (filledFields.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune donnée enregistrée',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filledFields.length,
      itemBuilder: (context, index) => _buildFieldItem(filledFields[index]),
    );
  }

  Widget _buildFieldItem(DocumentField field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              field.value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------
  // HELPERS
  // ---------------------------------------------
  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'invoice':
        return Icons.receipt_long;
      case 'quote':
        return Icons.request_quote;
      case 'delivery':
        return Icons.local_shipping;
      case 'business_card':
        return Icons.business_center;
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
    return "${date.day}/${date.month}/${date.year}";
  }

  // ---------------------------------------------
  // PRINT DOCUMENT
  // ---------------------------------------------
  Future<void> _printDocument(DynamicDocumentModel document) async {
    try {
      // For now, we'll just share the document data as text
      // In a real implementation, this would generate and print a PDF
      String content = '''Document: ${document.title}
Type: ${_getDocumentTypeName(document.type)}
Créé le: ${_formatDate(document.createdAt)}
Modifié le: ${_formatDate(document.updatedAt)}

Détails:
''';

      for (var field in document.fields) {
        if (field.value.isNotEmpty) {
          content += '${field.label}: ${field.value}\n';
        }
      }

      await Share.share(content, subject: 'Document - ${document.title}');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'imprimer le document: $e');
    }
  }

  // ---------------------------------------------
  // SHARE
  // ---------------------------------------------
  Future<void> _shareDocument(DynamicDocumentModel document) async {
    try {
      String content = '''
Document: ${document.title}
Type: ${_getDocumentTypeName(document.type)}
Créé le: ${_formatDate(document.createdAt)}
Modifié le: ${_formatDate(document.updatedAt)}

Détails:
''';

      for (var field in document.fields) {
        if (field.value.isNotEmpty) {
          content += '${field.label}: ${field.value}\n';
        }
      }

      await Share.share(content, subject: 'Document - ${document.title}');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de partager: $e');
    }
  }

  // ---------------------------------------------
  // DELETE (corrigé)
  // ---------------------------------------------
  Future<void> _deleteDocument(
      HomeController controller, DynamicDocumentModel document) async {
    Get.defaultDialog(
      title: "Confirmer la suppression",
      middleText:
          "Voulez-vous vraiment supprimer le document \"${document.title}\" ?",
      textConfirm: "Supprimer",
      textCancel: "Annuler",
      onConfirm: () async {
        controller.documents.remove(document);
        Get.back(); // ferme le dialog
        Get.back(); // revient à la liste
        Get.snackbar('Succès', 'Document supprimé avec succès');
      },
      onCancel: () => Get.back(),
      barrierDismissible: true,
    );
  }
}
