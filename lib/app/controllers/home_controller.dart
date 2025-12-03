import 'package:get/get.dart';
import '../repositories/storage_repository.dart';
import '../models/dynamic_document_model.dart';
import '../controllers/template_controller.dart';

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

  void navigateToDocument(String type) {
    // Navigate to template selection page first
    Get.toNamed('/templates/$type');
  }
}
