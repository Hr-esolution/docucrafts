import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../repositories/storage_repository.dart';

class QuoteController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxString title = "Nouveau Devis".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFields();
  }

  void _initializeFields() {
    fields.assignAll([
      DocumentField(
        id: 'quote_number',
        label: 'Numéro du devis',
        value: '',
        type: FieldType.text,
        isRequired: true,
      ),
      DocumentField(
        id: 'date',
        label: 'Date',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
      ),
      DocumentField(
        id: 'client_name',
        label: 'Nom du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
      ),
      DocumentField(
        id: 'client_address',
        label: 'Adresse du client',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'items',
        label: 'Désignation des articles',
        value: '',
        type: FieldType.text,
      ),
      DocumentField(
        id: 'amount',
        label: 'Montant HT',
        value: '',
        type: FieldType.number,
      ),
      DocumentField(
        id: 'vat',
        label: 'TVA',
        value: '',
        type: FieldType.number,
      ),
      DocumentField(
        id: 'total',
        label: 'Total TTC',
        value: '',
        type: FieldType.number,
      ),
      DocumentField(
        id: 'validity_date',
        label: 'Date de validité',
        value: '',
        type: FieldType.date,
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
      );
      fields.refresh(); // Utilisation de refresh() pour s'assurer que l'observable est mis à jour
    }
  }

  Future<void> saveQuote() async {
    final document = DynamicDocumentModel(
      id: 'quote_${DateTime.now().millisecondsSinceEpoch}',
      type: 'quote',
      title: title.value,
      fields: fields.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    try {
      await _storageRepository.saveDocument(document);
      Get.snackbar('Succès', 'Devis enregistré avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'enregistrement du devis: $e');
    }
  }
}