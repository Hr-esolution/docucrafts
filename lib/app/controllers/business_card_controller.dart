import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../repositories/storage_repository.dart';
import '../controllers/template_controller.dart';
import '../pages/business_card/previews/business_card_pdf_minimal_preview.dart';
import '../pages/business_card/previews/business_card_pdf_modern_preview.dart';
import '../pages/business_card/previews/business_card_pdf_professional_preview.dart';

class BusinessCardController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxString title = "Nouvelle Carte de Visite".obs;
  final TemplateController _templateController = Get.find<TemplateController>();

  @override
  void onInit() {
    super.onInit();
    _initializeFieldsWithTemplate();
  }

  void _initializeFieldsWithTemplate() {
    // Try to get the selected template for business cards
    final TemplateController _templateController = Get.find<TemplateController>();
    final selectedTemplate = _templateController.getSelectedTemplate();
    
    if (selectedTemplate != null && selectedTemplate.category == 'business_card') {
      // Use the selected template
      fields.assignAll(selectedTemplate.fields.map((fieldMap) => DocumentField(
        id: fieldMap['id'] ?? '',
        label: fieldMap['label'] ?? '',
        value: fieldMap['value'] ?? fieldMap['defaultValue'] ?? '',
        type: _stringToFieldType(fieldMap['type'] ?? 'text'),
        isRequired: fieldMap['isRequired'] ?? false,
        isEnabled: fieldMap['isEnabled'] ?? true,
      )).toList());
    } else {
      // Fallback to default fields if no template is available
      _initializeDefaultFields();
    }
  }

  void _initializeDefaultFields() {
    fields.assignAll([
      DocumentField(
        id: 'company_logo',
        label: 'Logo de l\'entreprise',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'full_name',
        label: 'Nom complet',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'job_title',
        label: 'Poste',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'company',
        label: 'Entreprise',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'phone',
        label: 'Téléphone',
        value: '',
        type: FieldType.phone,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'email',
        label: 'Email',
        value: '',
        type: FieldType.email,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'website',
        label: 'Site web',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'address',
        label: 'Adresse',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'linkedin',
        label: 'Profil LinkedIn',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'twitter',
        label: 'Profil Twitter',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
    ]);
  }

  FieldType _stringToFieldType(String type) {
    switch (type) {
      case 'number':
        return FieldType.number;
      case 'date':
        return FieldType.date;
      case 'email':
        return FieldType.email;
      case 'phone':
        return FieldType.phone;
      case 'text':
      default:
        return FieldType.text;
    }
  }

  void updateFieldValue(String fieldId, String newValue) {
    final fieldIndex = fields.indexWhere((field) => field.id == fieldId);
    if (fieldIndex != -1) {
      fields[fieldIndex] = DocumentField(
        id: fields[fieldIndex].id,
        label: fields[fieldIndex].label,
        value: newValue,
        type: fields[fieldIndex].type,
        isRequired: fields[fieldIndex].isRequired,
        isEnabled: fields[fieldIndex].isEnabled,
      );
      update();
    }
  }

  void toggleFieldEnablement(String fieldId) {
    final fieldIndex = fields.indexWhere((field) => field.id == fieldId);
    if (fieldIndex != -1) {
      fields[fieldIndex] = DocumentField(
        id: fields[fieldIndex].id,
        label: fields[fieldIndex].label,
        value: fields[fieldIndex].value,
        type: fields[fieldIndex].type,
        isRequired: fields[fieldIndex].isRequired,
        isEnabled: !fields[fieldIndex].isEnabled,
      );
      update();
    }
  }

  Future<void> saveBusinessCard() async {
    final document = DynamicDocumentModel(
      id: 'business_card_${DateTime.now().millisecondsSinceEpoch}',
      type: 'business_card',
      title: title.value,
      fields: fields.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _storageRepository.saveDocument(document);
      Get.snackbar('Succès', 'Carte de visite enregistrée avec succès');
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Échec de l\'enregistrement de la carte de visite: $e');
    }
  }
}
