import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/document_controller.dart';
import '../models/template_model.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/field_config_item.dart';

class FieldConfigurationPage extends StatelessWidget {
  const FieldConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final documentController = Get.put(DocumentController());
    final TemplateModel template = Get.arguments;

    // Initialize the current template in the controller
    documentController.setCurrentTemplate(template);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Configure Fields',
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
                  'Configure fields for ${template.name}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enable or disable fields and mark required ones',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Obx(() {
                    final fields = documentController.currentFields;
                    
                    if (fields.isEmpty) {
                      return const Center(
                        child: Text(
                          'No fields to configure',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: fields.length,
                      itemBuilder: (context, index) {
                        final field = fields[index];
                        
                        return FieldConfigItem(
                          field: field,
                          onEnabledChanged: (enabled) {
                            documentController.currentFields[index] = field.copyWith(enabled: enabled);
                            documentController.currentFields.refresh();
                          },
                          onRequiredChanged: (required) {
                            documentController.currentFields[index] = field.copyWith(required: required);
                            documentController.currentFields.refresh();
                          },
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to document form page
                      Get.toNamed('/document-form', arguments: {
                        'template': documentController.currentTemplate,
                        'fields': documentController.currentFields,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF667eea),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Continue to Form',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}