import 'package:get/get.dart';
import '../models/template.dart';
import '../repositories/template_repository.dart';

class TemplateController extends GetxController {
  final TemplateRepository _repository = TemplateRepository();
  final RxList<Template> _templates = <Template>[].obs;
  final RxString _selectedTemplateId = ''.obs;

  List<Template> get templates => _templates.toList();
  String get selectedTemplateId => _selectedTemplateId.value;

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    _templates.value = await _repository.getTemplates();
  }

  Future<void> addTemplate(Template template) async {
    await _repository.saveTemplate(template);
    await loadTemplates();
  }

  Future<void> updateTemplate(Template template) async {
    await _repository.saveTemplate(template);
    await loadTemplates();
  }

  Future<void> deleteTemplate(String id) async {
    await _repository.deleteTemplate(id);
    await loadTemplates();
  }

  Template? getTemplateById(String id) {
    try {
      return _templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Template> getTemplatesByCategory(String category) {
    return _templates.where((t) => t.category == category).toList();
  }

  void setSelectedTemplate(String templateId) {
    _selectedTemplateId.value = templateId;
  }

  Template? getSelectedTemplate() {
    if (_selectedTemplateId.value.isEmpty) {
      return null;
    }
    return getTemplateById(_selectedTemplateId.value);
  }

  Future<void> addDefaultTemplates() async {
    await _repository.addDefaultTemplates();
    await loadTemplates();
  }
}