import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../repositories/storage_repository.dart';
import '../controllers/template_controller.dart';

class BusinessCardController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxString title = "Nouvelle Carte de Visite".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFieldsWithTemplate();
  }

  void _initializeFieldsWithTemplate() {
    final TemplateController _templateController =
        Get.find<TemplateController>();
    final selectedTemplate = _templateController.getSelectedTemplate();

    if (selectedTemplate != null &&
        selectedTemplate.category == 'business_card') {
      fields.assignAll(selectedTemplate.fields
          .map((fieldMap) => DocumentField(
                id: fieldMap['id'] ?? '',
                label: fieldMap['label'] ?? '',
                value: fieldMap['value'] ?? fieldMap['defaultValue'] ?? '',
                type: _stringToFieldType(fieldMap['type'] ?? 'text'),
                isRequired: fieldMap['isRequired'] ?? false,
                isEnabled: fieldMap['isEnabled'] ?? true,
              ))
          .toList());
    } else {
      _initializeDefaultFields();
    }
  }

  void _initializeDefaultFields() {
    fields.assignAll([
      DocumentField(
          id: 'full_name',
          label: 'Nom complet',
          value: '',
          type: FieldType.text,
          isRequired: true),
      DocumentField(
          id: 'job_title',
          label: 'Poste/Fonction',
          value: '',
          type: FieldType.text,
          isRequired: true),
      DocumentField(
          id: 'company',
          label: 'Entreprise',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'department',
          label: 'Département',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'phone',
          label: 'Téléphone professionnel',
          value: '',
          type: FieldType.phone),
      DocumentField(
          id: 'mobile_phone',
          label: 'Téléphone mobile',
          value: '',
          type: FieldType.phone),
      DocumentField(
          id: 'email',
          label: 'Email professionnel',
          value: '',
          type: FieldType.email),
      DocumentField(
          id: 'personal_email',
          label: 'Email personnel',
          value: '',
          type: FieldType.email),
      DocumentField(
          id: 'website',
          label: 'Site web professionnel',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'personal_website',
          label: 'Site web personnel',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'address',
          label: 'Adresse professionnelle',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'city',
          label: 'Ville',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'postal_code',
          label: 'Code postal',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'country',
          label: 'Pays',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'linkedin',
          label: 'Profil LinkedIn',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'twitter',
          label: 'Profil Twitter/X',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'facebook',
          label: 'Profil Facebook',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'instagram',
          label: 'Profil Instagram',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'skype',
          label: 'Compte Skype',
          value: '',
          type: FieldType.text),
      DocumentField(
          id: 'whatsapp',
          label: 'Numéro WhatsApp',
          value: '',
          type: FieldType.phone),
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
      fields[fieldIndex] = fields[fieldIndex].copyWith(value: newValue);
      update();
    }
  }

  void toggleFieldEnablement(String fieldId) {
    final fieldIndex = fields.indexWhere((field) => field.id == fieldId);
    if (fieldIndex != -1) {
      fields[fieldIndex] =
          fields[fieldIndex].copyWith(isEnabled: !fields[fieldIndex].isEnabled);
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

  void navigateToPreview() {
    // Ici tu peux implémenter la logique pour ouvrir la page de preview
    // par exemple :
    // Get.to(() => BusinessCardPreviewPage(fields: fields.toList(), title: title.value));
  }
}
