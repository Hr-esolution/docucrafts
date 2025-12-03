import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../repositories/storage_repository.dart';

class CvController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxString title = "Nouveau CV".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFields();
  }

  void _initializeFields() {
    fields.assignAll([
      DocumentField(
        id: 'full_name',
        label: 'Nom complet',
        value: '',
        type: FieldType.text,
        isRequired: true,
      ),
      DocumentField(
        id: 'job_title',
        label: 'Poste recherché',
        value: '',
        type: FieldType.text,
        isRequired: true,
      ),
      DocumentField(
        id: 'phone',
        label: 'Téléphone',
        value: '',
        type: FieldType.phone,
      ),
      DocumentField(
        id: 'email',
        label: 'Email',
        value: '',
        type: FieldType.email,
      ),
      DocumentField(
        id: 'address',
        label: 'Adresse',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'summary',
        label: 'Résumé professionnel',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'experience',
        label: 'Expérience professionnelle',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'education',
        label: 'Formation',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'skills',
        label: 'Compétences',
        value: '',
        type: FieldType.text,
      ),
    ]);
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

  Future<void> saveCv() async {
    final document = DynamicDocumentModel(
      id: 'cv_${DateTime.now().millisecondsSinceEpoch}',
      type: 'cv',
      title: title.value,
      fields: fields.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _storageRepository.saveDocument(document);
      Get.snackbar('Succès', 'CV enregistré avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'enregistrement du CV: $e');
    }
  }
}
