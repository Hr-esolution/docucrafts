import 'dart:typed_data';
import 'dart:io';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
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
        id: 'quote_title',
        label: 'Mention \"Devis\"',
        value: 'Devis',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'quote_number',
        label: 'Numéro du devis',
        value: 'QT-${DateTime.now().year}-${Random().nextInt(900) + 100}',
        type: FieldType.text,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'date',
        label: 'Date d\'émission',
        value: DateTime.now().toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'validity_date',
        label: 'Date de validité',
        value: DateTime.now().add(Duration(days: 30)).toString().split(' ')[0],
        type: FieldType.date,
        isRequired: true,
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
        id: 'seller_website',
        label: 'Site web du vendeur',
        value: '',
        type: FieldType.text,
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
        id: 'items',
        label: 'Désignation des articles/services',
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
        id: 'unit_price',
        label: 'Prix unitaire HT',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'vat_rate',
        label: 'Taux de TVA (%)',
        value: '20',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'subtotal_ht',
        label: 'Sous-total HT',
        value: '',
        type: FieldType.number,
        isRequired: true,
        isEnabled: true,
      ),
      DocumentField(
        id: 'discount_rate',
        label: 'Remise (%)',
        value: '0',
        type: FieldType.number,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'discount_amount',
        label: 'Montant de la remise',
        value: '0',
        type: FieldType.number,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'total_vat',
        label: 'Total TVA',
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
      DocumentField(
        id: 'payment_terms',
        label: 'Conditions de paiement',
        value: 'Paiement à la commande',
        type: FieldType.text,
        isRequired: false,
        isEnabled: true,
      ),
      DocumentField(
        id: 'delivery_terms',
        label: 'Conditions de livraison',
        value: 'Livraison sous 15 jours',
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
          Get.to(() => MultiQuotePreview(data: data));
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

  Future<void> generateQuotePdf() async {
    // Récupérer les données du formulaire
    final Map<String, dynamic> data = {};
    for (final field in fields) {
      data[field.id] = field.value;
    }

    // Générer le PDF en utilisant les données du formulaire
    try {
      // Extraire les données nécessaires
      final quoteNumber = data['quote_number'] ?? '';
      final date = data['date'] ?? '';
      final clientName = data['client_name'] ?? '';
      final clientAddress = data['client_address'] ?? '';
      final items = data['items'] ?? '';
      final amount = data['subtotal_ht'] ?? '';
      final vat = data['total_vat'] ?? '';
      final total = data['total_ttc'] ?? '';
      final validityDate = data['validity_date'] ?? '';

      // Importer la fonction depuis le fichier approprié
      final pdfBytes = await generateQuotePdfFromData(
        quoteNumber: quoteNumber,
        date: date,
        clientName: clientName,
        clientAddress: clientAddress,
        items: items,
        amount: amount,
        vat: vat,
        total: total,
        validityDate: validityDate,
      );

      // Sauvegarder le PDF ou l'afficher selon les besoins
      await _saveAndShowPdf(pdfBytes, 'devis_$quoteNumber.pdf');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de générer le PDF: $e');
    }
  }

  Future<Uint8List> generateQuotePdfFromData({
    required String quoteNumber,
    required String date,
    required String clientName,
    required String clientAddress,
    required String items,
    required String amount,
    required String vat,
    required String total,
    required String validityDate,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Devis',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Numéro du devis: $quoteNumber',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.Text(
                          'Date: $date',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.Text(
                          'Date de validité: $validityDate',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'À l\'attention de:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(clientName,
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(clientAddress,
                            style: const pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Désignation des articles',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(items, style: const pw.TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Montant HT: $amount €',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Text(
                      'TVA: $vat €',
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.Divider(),
                    pw.Text(
                      'Total TTC: $total €',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Merci pour votre confiance!',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _saveAndShowPdf(Uint8List pdfBytes, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename');
      
      await file.writeAsBytes(pdfBytes);
      
      // Afficher le PDF dans une nouvelle page
      await Printing.layoutPdf(
        onLayout: (format) => pdfBytes,
        name: filename,
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de sauvegarder ou afficher le PDF: $e');
    }
  }
}