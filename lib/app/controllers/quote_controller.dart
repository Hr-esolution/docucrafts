import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../models/product.dart';
import '../repositories/storage_repository.dart';
import '../controllers/template_controller.dart';
import '../pages/quote/previews/quote_pdf_minimal_preview.dart';
import '../pages/quote/previews/quote_pdf_multi_preview.dart';
import '../pages/quote/previews/quote_pdf_premium_preview.dart';

class QuoteController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final RxString title = "Nouveau Devis".obs;
  final TemplateController _templateController = Get.find<TemplateController>();

  @override
  void onInit() {
    super.onInit();
    _initializeFieldsWithTemplate();
  }

  void _initializeFieldsWithTemplate() {
    // Try to get the selected template for quotes
    final selectedTemplate = _templateController.getSelectedTemplate();
    
    if (selectedTemplate != null && selectedTemplate.category == 'quote') {
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
        id: 'quote_number',
        label: 'Numéro du devis',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'date',
        label: 'Date',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_name',
        label: 'Nom du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_address',
        label: 'Adresse du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'items',
        label: 'Désignation des articles',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'amount',
        label: 'Montant HT',
        value: '',
        type: FieldType.number,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'vat',
        label: 'TVA',
        value: '',
        type: FieldType.number,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'total',
        label: 'Total TTC',
        value: '',
        type: FieldType.number,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'validity_date',
        label: 'Date de validité',
        value: '',
        type: FieldType.date,
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

  // Product management methods
  void addProduct(Product product) {
    products.add(product);
    update();
  }

  void removeProduct(Product product) {
    products.removeWhere((p) => p.id == product.id);
    update();
  }

  void updateProduct(Product updatedProduct) {
    final index = products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      products[index] = updatedProduct;
      update();
    }
  }

  void clearProducts() {
    products.clear();
    update();
  }

  List<Product> getProducts() {
    return products.toList();
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

  void navigateToPreview() {
    // Récupérer les données du formulaire
    final Map<String, dynamic> data = {};
    for (final field in fields) {
      data[field.id] = field.value;
    }
    
    // Récupérer le template sélectionné
    final selectedTemplate = _templateController.getSelectedTemplate();
    
    // Rediriger vers la page d'aperçu appropriée en fonction du template
    if (selectedTemplate != null && selectedTemplate.category == 'quote') {
      switch (selectedTemplate.id) {
        case 'quote_minimal':
          Get.to(() => MinimalQuotePreview(data: data));
          break;
        case 'quote_multi_column':
          Get.to(() => MultiColumnQuotePreview(data: data));
          break;
        case 'quote_premium':
          Get.to(() => PremiumQuotePreview(data: data));
          break;
        default:
          Get.to(() => MinimalQuotePreview(data: data));
          break;
      }
    } else {
      // Si aucun template n'est sélectionné, utiliser le template minimal par défaut
      Get.to(() => MinimalQuotePreview(data: data));
    }
  }
}