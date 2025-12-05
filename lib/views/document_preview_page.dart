import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/document_controller.dart';
import '../models/document_model.dart';
import '../models/template_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/document_preview.dart';

class DocumentPreviewPage extends StatelessWidget {
  const DocumentPreviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documentController = Get.find<DocumentController>();
    final args = Get.arguments as Map<String, dynamic>;
    final templateData = args['template'];
    final formData = args['data'];

    // Create a temporary document model for preview
    final template = TemplateModel(
      id: templateData['id'],
      name: templateData['name'],
      documentType: templateData['documentType'],
      previewImage: 'assets/images/${templateData['documentType']}.png',
      fields: [],
      style: templateData['style'],
    );

    final previewDocument = DocumentModel(
      id: null,
      type: templateData['documentType'],
      title: 'Preview Document',
      templateId: templateData['id'],
      fields: Map.from(formData),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Document Preview',
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Review your document before saving',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Make sure all information is correct',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: DocumentPreview(
                      document: previewDocument,
                      template: template,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Save the document
                            final documentToSave = DocumentModel(
                              id: null,
                              type: templateData['documentType'],
                              title: _getDocumentTitle(templateData['documentType'], formData),
                              templateId: templateData['id'],
                              fields: Map.from(formData),
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now(),
                            );
                            
                            await documentController.createDocument(documentToSave);
                            Get.back(); // Go back to home
                            Get.snackbar('Success', 'Document saved successfully!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF667eea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
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

  String _getDocumentTitle(String documentType, Map<String, dynamic> formData) {
    String title = '';
    
    switch (documentType) {
      case 'invoice':
        title = 'Invoice ${formData['invoiceNumber'] ?? ''}';
        break;
      case 'quote':
        title = 'Quote ${formData['quoteNumber'] ?? ''}';
        break;
      case 'delivery':
        title = 'Delivery ${formData['deliveryNumber'] ?? ''}';
        break;
      case 'business_card':
        title = 'Business Card ${formData['fullName'] ?? ''}';
        break;
      case 'cv':
        title = 'CV ${formData['fullName'] ?? ''}';
        break;
      default:
        title = '${documentType[0].toUpperCase()}${documentType.substring(1)} Document';
    }
    
    return title.isNotEmpty ? title : 'Untitled Document';
  }
}