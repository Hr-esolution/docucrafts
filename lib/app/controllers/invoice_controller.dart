import 'package:get/get.dart';
import '../models/dynamic_document_model.dart';
import '../models/product.dart';
import '../repositories/storage_repository.dart';
import '../pages/invoice/invoice_pdf.dart' as invoice_pdf;
import '../pages/invoice/previews/invoice_pdf_minimal_preview.dart';
import '../pages/invoice/previews/invoice_pdf_multi_preview.dart';
import '../pages/invoice/previews/invoice_pdf_premium_preview.dart';
import 'dart:math';
import '../controllers/template_controller.dart';

class InvoiceController extends GetxController {
  final StorageRepository _storageRepository = StorageRepository();
  final RxList<DocumentField> fields = <DocumentField>[].obs;
  final RxList<Product> products = <Product>[].obs;
  final RxString title = "Nouvelle Facture".obs;
  final TemplateController _templateController = Get.find<TemplateController>();

  @override
  void onInit() {
    super.onInit();
    _initializeFieldsWithTemplate();
  }

  void _initializeFieldsWithTemplate() {
    // Try to get the selected template for invoices
    final selectedTemplate = _templateController.getSelectedTemplate();
    
    if (selectedTemplate != null && selectedTemplate.category == 'invoice') {
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
      // Champs obligatoires pour la mention explicite
      DocumentField(
        id: 'invoice_title',
        label: 'Mention "Facture"',
        value: 'Facture',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      // Champs obligatoires pour le numéro de facture
      DocumentField(
        id: 'invoice_number',
        label: 'Numéro de facture unique',
        value: 'INV-${DateTime.now().year}-${Random().nextInt(900) + 100}',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      // Champs obligatoires pour les dates
      DocumentField(
        id: 'issue_date',
        label: 'Date d\'émission',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'service_date',
        label: 'Date de prestation/livraison',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: false,
        isEnabled: true,
      ),
      // Champs obligatoires pour l'identité du vendeur
      DocumentField(
        id: 'seller_name',
        label: 'Nom du vendeur',
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
      // Champs obligatoires pour l'identité de l'acheteur
      DocumentField(
        id: 'buyer_name',
        label: 'Nom du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'buyer_address',
        label: 'Adresse du client',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'buyer_vat_number',
        label: 'Numéro de TVA intracommunautaire du client',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      // Champs pour la description des biens ou services
      DocumentField(
        id: 'item_description',
        label: 'Désignation des biens ou services',
        value: '',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'item_quantity',
        label: 'Quantité',
        value: '1',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'item_unit_price',
        label: 'Prix unitaire HT',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'vat_rate',
        label: 'Taux de TVA',
        value: '20',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'vat_amount',
        label: 'Montant de la TVA',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      // Champs pour les montants
      DocumentField(
        id: 'subtotal_ht',
        label: 'Sous-total HT',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'total_ttc',
        label: 'Total TTC',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      // Champs pour les conditions de paiement
      DocumentField(
        id: 'payment_terms',
        label: 'Conditions de paiement',
        value: 'Net à 30 jours',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'payment_method',
        label: 'Mode de paiement',
        value: '',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'late_fees',
        label: 'Pénalités de retard',
        value: '1.5% par mois de retard',
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

  Future<void> saveInvoice() async {
    final document = DynamicDocumentModel(
      id: 'invoice_${DateTime.now().millisecondsSinceEpoch}',
      type: 'invoice',
      title: title.value,
      fields: fields.toList(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await _storageRepository.saveDocument(document);
      Get.snackbar('Succès', 'Facture enregistrée avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Échec de l\'enregistrement de la facture: $e');
    }
  }

  Future<void> generateInvoicePdf() async {
    // Récupérer les valeurs des champs
    final invoiceTitle = _getFieldValue('invoice_title');
    final invoiceNumber = _getFieldValue('invoice_number');
    final issueDate = _getFieldValue('issue_date');
    final serviceDate = _getFieldValue('service_date');
    final sellerName = _getFieldValue('seller_name');
    final sellerAddress = _getFieldValue('seller_address');
    final sellerVatNumber = _getFieldValue('seller_vat_number');
    final sellerPhone = _getFieldValue('seller_phone');
    final sellerEmail = _getFieldValue('seller_email');
    final buyerName = _getFieldValue('buyer_name');
    final buyerAddress = _getFieldValue('buyer_address');
    final buyerVatNumber = _getFieldValue('buyer_vat_number');
    final itemDescription = _getFieldValue('item_description');
    final itemQuantity = _getFieldValue('item_quantity');
    final itemUnitPrice = _getFieldValue('item_unit_price');
    final vatRate = _getFieldValue('vat_rate');
    final vatAmount = _getFieldValue('vat_amount');
    final subtotalHt = _getFieldValue('subtotal_ht');
    final totalTtc = _getFieldValue('total_ttc');
    final paymentTerms = _getFieldValue('payment_terms');
    final paymentMethod = _getFieldValue('payment_method');
    final lateFees = _getFieldValue('late_fees');

    // Générer le PDF
    await invoice_pdf.generateInvoicePdf(
      invoiceTitle: invoiceTitle,
      invoiceNumber: invoiceNumber,
      issueDate: issueDate,
      serviceDate: serviceDate,
      sellerName: sellerName,
      sellerAddress: sellerAddress,
      sellerVatNumber: sellerVatNumber,
      sellerPhone: sellerPhone,
      sellerEmail: sellerEmail,
      buyerName: buyerName,
      buyerAddress: buyerAddress,
      buyerVatNumber: buyerVatNumber,
      itemDescription: itemDescription,
      itemQuantity: itemQuantity,
      itemUnitPrice: itemUnitPrice,
      vatRate: vatRate,
      vatAmount: vatAmount,
      subtotalHt: subtotalHt,
      totalTtc: totalTtc,
      paymentTerms: paymentTerms,
      paymentMethod: paymentMethod,
      lateFees: lateFees,
    );

    // Afficher un message de succès ou gérer le PDF autrement
    Get.snackbar('Succès', 'PDF généré avec succès');
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
    if (selectedTemplate != null && selectedTemplate.category == 'invoice') {
      switch (selectedTemplate.id) {
        case 'invoice_minimal':
          Get.to(() => MinimalInvoicePreview(data: data));
          break;
        case 'invoice_multi_column':
          Get.to(() => MultiColumnInvoicePreview(data: data));
          break;
        case 'invoice_premium':
          Get.to(() => PremiumInvoicePreview(data: data));
          break;
        default:
          Get.to(() => MinimalInvoicePreview(data: data));
          break;
      }
    } else {
      // Si aucun template n'est sélectionné, utiliser le template minimal par défaut
      Get.to(() => MinimalInvoicePreview(data: data));
    }
  }

  String _getFieldValue(String fieldId) {
    final field = fields.firstWhere((field) => field.id == fieldId,
        orElse: () => DocumentField(
            id: fieldId, label: '', value: '', type: FieldType.text));
    return field.value;
  }
}
