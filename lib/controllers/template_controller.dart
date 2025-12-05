import 'package:get/get.dart';
import '../models/template_model.dart';
import '../services/template_service.dart';

class TemplateController extends GetxController {
  final TemplateService _templateService = TemplateService();
  
  var templates = <TemplateModel>[].obs;
  var isLoading = false.obs;
  var selectedDocumentType = ''.obs;
  var availableTemplates = <TemplateModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoading.value = true;
    try {
      final loadedTemplates = await _templateService.loadTemplates();
      templates.assignAll(loadedTemplates);
      updateAvailableTemplates();
    } catch (e) {
      print('Error loading templates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateAvailableTemplates() {
    if (selectedDocumentType.value.isNotEmpty) {
      availableTemplates.assignAll(
        templates.where((template) => template.documentType == selectedDocumentType.value).toList()
      );
    } else {
      availableTemplates.assignAll(templates);
    }
  }

  void selectDocumentType(String type) {
    selectedDocumentType.value = type;
    updateAvailableTemplates();
  }

  List<String> getDocumentTypes() {
    return templates.map((template) => template.documentType).toSet().toList();
  }
}