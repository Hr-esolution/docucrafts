import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../models/product.dart';
import '../repositories/storage_repository.dart';
import '../controllers/template_controller.dart';
import '../pages/delivery/previews/delivery_pdf_minimal_preview.dart';
import '../pages/delivery/previews/delivery_pdf_multi_preview.dart';
import '../pages/delivery/previews/delivery_pdf_premium_preview.dart';
import 'dart:math';

class DeliveryController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final RxString title = "Nouveau Bon de Livraison".obs;
  final TemplateController _templateController = Get.find<TemplateController>();

  @override
  void onInit() {
    super.onInit();
    _initializeFieldsWithTemplate();
  }

  void _initializeFieldsWithTemplate() {
    // Try to get the selected template for delivery notes
    final selectedTemplate = _templateController.getSelectedTemplate();

    if (selectedTemplate != null && selectedTemplate.category == 'delivery') {
      // Use the selected template
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
      // Fallback to default fields if no template is available
      _initializeDefaultFields();
    }
  }

  void _initializeDefaultFields() {
    fields.assignAll([
      DocumentField(
        id: 'delivery_title',
        label: 'Mention \"Bon de Livraison\"',
        value: 'Bon de Livraison',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_number',
        label: 'Numéro du bon de livraison',
        value: 'DL-${DateTime.now().year}-${Random().nextInt(900) + 100}',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'date',
        label: 'Date de livraison',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'order_date',
        label: 'Date de la commande',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_name',
        label: 'Nom du vendeur/entreprise',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_address',
        label: 'Adresse du vendeur',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_city',
        label: 'Ville du vendeur',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_postal_code',
        label: 'Code postal du vendeur',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_country',
        label: 'Pays du vendeur',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_vat_number',
        label: 'Numéro de TVA du vendeur',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_phone',
        label: 'Téléphone du vendeur',
        value: '',
        type: FieldType.phone,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'seller_email',
        label: 'Email du vendeur',
        value: '',
        type: FieldType.email,
        isRequired: false,
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
        id: 'client_city',
        label: 'Ville du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_postal_code',
        label: 'Code postal du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_country',
        label: 'Pays du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_vat_number',
        label: 'Numéro de TVA du client',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_phone',
        label: 'Téléphone du client',
        value: '',
        type: FieldType.phone,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'client_email',
        label: 'Email du client',
        value: '',
        type: FieldType.email,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_address',
        label: 'Adresse de livraison',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_city',
        label: 'Ville de livraison',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_postal_code',
        label: 'Code postal de livraison',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_country',
        label: 'Pays de livraison',
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
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'quantity',
        label: 'Quantité',
        value: '1',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'reference',
        label: 'Référence du produit',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'carrier',
        label: 'Transporteur',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'tracking_number',
        label: 'Numéro de suivi',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'signature_required',
        label: 'Signature requise',
        value: 'Oui',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'notes',
        label: 'Notes/Commentaires',
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

  Future<void> saveDelivery() async {
    final document = DynamicDocumentModel(
      id: 'delivery_${DateTime.now().millisecondsSinceEpoch}',
      type: 'delivery',
      title: title.value,
      fields: fields.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _storageRepository.saveDocument(document);
      Get.snackbar('Succès', 'Bon de livraison enregistré avec succès');
    } catch (e) {
      Get.snackbar(
          'Erreur', 'Échec de l\'enregistrement du bon de livraison: $e');
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
    if (selectedTemplate != null && selectedTemplate.category == 'delivery') {
      switch (selectedTemplate.id) {
        case 'delivery_minimal':
          Get.to(() => MinimalDeliveryPreview(data: data));
          break;
        case 'delivery_multi_column':
          Get.to(() => MultiDeliveryPreview(data: data));
          break;
        case 'delivery_premium':
          Get.to(() => PremiumDeliveryPreview(data: data));
          break;
        default:
          Get.to(() => MinimalDeliveryPreview(data: data));
          break;
      }
    } else {
      // Si aucun template n'est sélectionné, utiliser le template minimal par défaut
      Get.to(() => MinimalDeliveryPreview(data: data));
    }
  }
}
