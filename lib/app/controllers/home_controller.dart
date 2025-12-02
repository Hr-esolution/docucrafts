import 'package:get/get.dart';
import '../repositories/storage_repository.dart';
import '../models/dynamic_document_model.dart';

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
    switch (type) {
      case 'invoice':
        Get.toNamed('/invoice');
        break;
      case 'quote':
        Get.toNamed('/quote');
        break;
      case 'delivery':
        Get.toNamed('/delivery');
        break;
      case 'business_card':
        Get.toNamed('/business_card');
        break;
      case 'cv':
        Get.toNamed('/cv');
        break;
    }
  }
}
