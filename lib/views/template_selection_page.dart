import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/template_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/template_card.dart';

class TemplateSelectionPage extends StatelessWidget {
  const TemplateSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final templateController = Get.find<TemplateController>();
    final String documentType = Get.arguments ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select Template',
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
                Text(
                  'Choose a template for your ${_getDocumentTypeLabel(documentType)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select from the available templates',
                  style: const TextStyle(
                    fontSize: 14,
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

                    if (templateController.availableTemplates.isEmpty) {
                      return const Center(
                        child: Text(
                          'No templates available for this document type',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return AnimationLimiter(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: templateController.availableTemplates.length,
                        itemBuilder: (context, index) {
                          final template = templateController.availableTemplates[index];
                          
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: TemplateCard(
                                  template: template,
                                  onTap: () {
                                    Get.toNamed('/field-configuration', arguments: template);
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

  String _getDocumentTypeLabel(String type) {
    switch (type) {
      case 'invoice':
        return 'Invoice';
      case 'quote':
        return 'Quote';
      case 'delivery':
        return 'Delivery Note';
      case 'business_card':
        return 'Business Card';
      case 'cv':
        return 'CV';
      default:
        return type[0].toUpperCase() + type.substring(1);
    }
  }
}