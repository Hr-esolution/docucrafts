import 'package:get/get.dart';
import '../../app/repositories/storage_repository.dart';
import '../../app/models/dynamic_document_model.dart';

class HomeController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DynamicDocumentModel> documents = <DynamicDocumentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDocuments();
  }

  Future<void> loadDocuments() async {
    try {
      final docs = await _storageRepository.getAllDocuments();
      documents.assignAll(docs);
    } catch (e) {
      print('Error loading documents: $e');
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await _storageRepository.deleteDocument(id);
      documents.removeWhere((doc) => doc.id == id);
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  void navigateToDocument(String type) {
    // Navigate to template selection page first
    Get.toNamed('/templates/$type');
  }
}
