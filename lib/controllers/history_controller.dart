import 'package:get/get.dart';
import '../models/document_model.dart';
import '../repositories/document_repository.dart';

class HistoryController extends GetxController {
  final DocumentRepository _documentRepository = DocumentRepository();
  
  var documents = <DocumentModel>[].obs;
  var isLoading = false.obs;
  var selectedDocumentType = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllDocuments();
  }

  Future<void> loadAllDocuments() async {
    isLoading.value = true;
    try {
      final docs = await _documentRepository.getAllDocuments();
      documents.assignAll(docs);
    } catch (e) {
      print('Error loading documents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDocumentsByType(String type) async {
    isLoading.value = true;
    try {
      if (type == 'all') {
        await loadAllDocuments();
      } else {
        final docs = await _documentRepository.getDocumentsByType(type);
        documents.assignAll(docs);
      }
      selectedDocumentType.value = type;
    } catch (e) {
      print('Error loading documents by type: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDocument(int id) async {
    try {
      await _documentRepository.deleteDocument(id);
      documents.removeWhere((doc) => doc.id == id);
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> duplicateDocument(DocumentModel document) async {
    try {
      // Create a new document with the same data but different title
      final duplicatedDocument = document.copyWith(
        id: null,
        title: '${document.title} (Copy)',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final newId = await _documentRepository.insertDocument(duplicatedDocument);
      final documentWithId = duplicatedDocument.copyWith(id: newId);
      documents.insert(0, documentWithId);
    } catch (e) {
      print('Error duplicating document: $e');
    }
  }

  List<String> getDocumentTypes() {
    final types = documents.map((doc) => doc.type).toSet().toList();
    types.insert(0, 'all'); // Add 'all' option at the beginning
    return types;
  }
}