import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/document_card.dart';

class DocumentHistoryPage extends StatelessWidget {
  const DocumentHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Document History',
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
                  'Your Documents',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your created documents',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Obx(() {
                    return DropdownButton<String>(
                      value: historyController.selectedDocumentType.value,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          historyController.loadDocumentsByType(newValue);
                        }
                      },
                      items: historyController.getDocumentTypes()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value[0].toUpperCase() + value.substring(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: Container(),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.white,
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (historyController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (historyController.documents.isEmpty) {
                      return const Center(
                        child: Text(
                          'No documents found',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => historyController.loadAllDocuments(),
                      child: ListView.builder(
                        itemCount: historyController.documents.length,
                        itemBuilder: (context, index) {
                          final document = historyController.documents[index];
                          return DocumentCard(
                            document: document,
                            onEdit: () {
                              // For now, just show a snackbar
                              Get.snackbar('Edit', 'Edit functionality would be implemented here');
                            },
                            onDuplicate: () {
                              historyController.duplicateDocument(document);
                            },
                            onDelete: () {
                              historyController.deleteDocument(document.id!);
                            },
                            onTap: () {
                              // For now, just show a snackbar
                              Get.snackbar('View', 'View functionality would be implemented here');
                            },
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
}