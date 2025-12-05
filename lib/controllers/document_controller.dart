import 'package:get/get.dart';
import '../models/document_model.dart';
import '../models/field_model.dart';
import '../models/template_model.dart';
import '../repositories/document_repository.dart';
import '../services/template_service.dart';
import '../services/pdf_service.dart';

class DocumentController extends GetxController {
  final DocumentRepository _documentRepository = DocumentRepository();
  final TemplateService _templateService = TemplateService();
  final PdfService _pdfService = PdfService();

  var documents = <DocumentModel>[].obs;
  var currentDocument = <String, dynamic>{}.obs;
  var currentTemplate = <String, dynamic>{}.obs;
  var currentFields = <FieldModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllDocuments();
  }

  Future<void> loadAllDocuments() async {
    isLoading.value = true;
    try {
      final docs = await _documentRepository.getAllDocuments();
      documents.assignAll(docs);
    } catch (e) {
      print('Error loading documents: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDocument(DocumentModel document) async {
    isLoading.value = true;
    try {
      final id = await _documentRepository.insertDocument(document);
      final newDocument = document.copyWith(id: id);
      documents.insert(0, newDocument);
    } catch (e) {
      print('Error creating document: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDocument(DocumentModel document) async {
    isLoading.value = true;
    try {
      await _documentRepository.updateDocument(document);
      final index = documents.indexWhere((d) => d.id == document.id);
      if (index != -1) {
        documents[index] = document;
      }
    } catch (e) {
      print('Error updating document: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDocument(int id) async {
    isLoading.value = true;
    try {
      await _documentRepository.deleteDocument(id);
      documents.removeWhere((d) => d.id == id);
    } catch (e) {
      print('Error deleting document: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> generatePdfForDocument(DocumentModel document) async {
    return await _pdfService.generatePdf(document);
  }

  void setCurrentDocumentData(Map<String, dynamic> data) {
    currentDocument.assignAll(data);
  }

  void setCurrentTemplate(TemplateModel template) {
    currentTemplate.clear();
    currentTemplate['id'] = template.id;
    currentTemplate['name'] = template.name;
    currentTemplate['documentType'] = template.documentType;
    currentTemplate['fields'] = template.fields;
    currentTemplate['style'] = template.style;
    
    // Set current fields to the template's fields
    currentFields.assignAll(template.fields);
  }

  void updateFieldData(String fieldName, dynamic value) {
    currentDocument[fieldName] = value;
  }

  List<FieldModel> getEnabledFields() {
    return currentFields.where((field) => field.enabled).toList();
  }

  bool isFieldRequired(String fieldName) {
    final field = currentFields.firstWhere((f) => f.name == fieldName, orElse: () => FieldModel(name: '', label: '', type: 'text'));
    return field.required;
  }
}