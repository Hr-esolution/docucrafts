import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../models/product.dart';
import '../repositories/storage_repository.dart';

class BusinessCardController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxString title = "Nouvelle Carte de Visite".obs;

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
        label: 'Poste',
        value: '',
        type: FieldType.text,
        isRequired: true,
      ),
      DocumentField(
        id: 'company',
        label: 'Entreprise',
        value: '',
        type: FieldType.text,
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
        id: 'website',
        label: 'Site web',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'address',
        label: 'Adresse',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'linkedin',
        label: 'Profil LinkedIn',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'twitter',
        label: 'Profil Twitter',
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
      Get.snackbar('Erreur', 'Échec de l\'enregistrement de la carte de visite: $e');
    }
  }
}