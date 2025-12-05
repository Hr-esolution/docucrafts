import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/template_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/document_type_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final templateController = Get.put(TemplateController());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'DocuCrafts',
        showBackButton: false,
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
                  'Create New Document',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select the type of document you want to create',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Obx(() {
                    if (templateController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final documentTypes = templateController.getDocumentTypes();
                    if (documentTypes.isEmpty) {
                      return const Center(
                        child: Text('No document types available'),
                      );
                    }

                    return AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: documentTypes.length,
                        itemBuilder: (context, index) {
                          final type = documentTypes[index];
                          final color = _getColorForType(type);
                          
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: DocumentTypeCard(
                                  title: _getLabelForType(type),
                                  iconPath: '', // Not used in the widget
                                  color: color,
                                  onTap: () {
                                    templateController.selectDocumentType(type);
                                    Get.toNamed('/template-selection', arguments: type);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'invoice':
        return Colors.green;
      case 'quote':
        return Colors.orange;
      case 'delivery':
        return Colors.purple;
      case 'business_card':
        return Colors.blue;
      case 'cv':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getLabelForType(String type) {
    switch (type) {
      case 'invoice':
        return 'Invoice';
      case 'quote':
        return 'Quote';
      case 'delivery':
        return 'Delivery';
      case 'business_card':
        return 'Business Card';
      case 'cv':
        return 'CV';
      default:
        return type[0].toUpperCase() + type.substring(1);
    }
  }
}