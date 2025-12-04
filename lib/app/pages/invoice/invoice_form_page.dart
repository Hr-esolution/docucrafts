import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_customizer_app/app/controllers/invoice_controller.dart';
import 'package:pdf_customizer_app/app/models/dynamic_document_model.dart';
import 'package:pdf_customizer_app/app/widgets/product_selection_widget.dart';
import 'package:pdf_customizer_app/app/widgets/logo_selection_widget.dart';
import 'dart:ui';

class InvoiceFormPage extends StatelessWidget {
  const InvoiceFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Créer une Facture'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Get.toNamed('/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: () => controller.navigateToPreview(),
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.generateInvoicePdf(),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => controller.saveInvoice(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.95),
              Colors.blue.withOpacity(0.05),
              Colors.indigo.withOpacity(0.03),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ListView(
              padding: const EdgeInsets.only(top: 80),
              children: [
                // Logo selection widget
                LogoSelectionWidget(
                  logoPath: controller.fields.firstWhere(
                    (field) => field.id == 'company_logo',
                    orElse: () => DocumentField(
                      id: 'company_logo',
                      label: 'Logo de l\'entreprise',
                      value: '',
                      type: FieldType.text,
                      isRequired: false,
                      isEnabled: true,
                    ),
                  ).value.isEmpty ? null : controller.fields.firstWhere(
                    (field) => field.id == 'company_logo',
                    orElse: () => DocumentField(
                      id: 'company_logo',
                      label: 'Logo de l\'entreprise',
                      value: '',
                      type: FieldType.text,
                      isRequired: false,
                      isEnabled: true,
                    ),
                  ).value,
                  onLogoSelected: (logoPath) {
                    controller.updateFieldValue('company_logo', logoPath);
                  },
                ),
                const SizedBox(height: 16),
                // Document fields
                ...List.generate(controller.fields.length, (index) {
                  final field = controller.fields[index];
                  if (!field.isEnabled) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      field.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  if (field.isRequired)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 4.0, top: 2.0),
                                      child: Text(
                                        '*',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (field.type == FieldType.date)
                                _buildGlassmorphicTextField(
                                  hintText: 'Sélectionnez une date',
                                  suffixIcon: Icons.date_range,
                                  readOnly: true,
                                  initialValue: field.value,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101),
                                    );
                                    if (pickedDate != null) {
                                      controller.updateFieldValue(
                                        field.id,
                                        pickedDate.toString().split(' ')[0],
                                      );
                                    }
                                  },
                                ),
                              if (field.type == FieldType.number)
                                _buildGlassmorphicTextField(
                                  hintText: 'Entrez un nombre',
                                  keyboardType: TextInputType.number,
                                  initialValue: field.value,
                                  onChanged: (value) =>
                                      controller.updateFieldValue(
                                    field.id,
                                    value,
                                  ),
                                ),
                              if (field.type == FieldType.phone)
                                _buildGlassmorphicTextField(
                                  hintText: 'Entrez un numéro de téléphone',
                                  keyboardType: TextInputType.phone,
                                  initialValue: field.value,
                                  onChanged: (value) =>
                                      controller.updateFieldValue(
                                    field.id,
                                    value,
                                  ),
                                ),
                              if (field.type == FieldType.email)
                                _buildGlassmorphicTextField(
                                  hintText: 'Entrez une adresse email',
                                  keyboardType: TextInputType.emailAddress,
                                  initialValue: field.value,
                                  onChanged: (value) =>
                                      controller.updateFieldValue(
                                    field.id,
                                    value,
                                  ),
                                ),
                              if (field.type == FieldType.text)
                                _buildGlassmorphicTextField(
                                  hintText: 'Entrez ${field.label.toLowerCase()}',
                                  initialValue: field.value,
                                  maxLines:
                                      field.label.contains('Désignation') ? 3 : 1,
                                  onChanged: (value) =>
                                      controller.updateFieldValue(
                                    field.id,
                                    value,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                // Product selection widget
                const SizedBox(height: 16),
                ProductSelectionWidget(
                  selectedProducts: controller.getProducts(),
                  onAddProduct: controller.addProduct,
                  onRemoveProduct: controller.removeProduct,
                  onProductUpdated: controller.updateProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    bool readOnly = false,
    String initialValue = '',
    int maxLines = 1,
    VoidCallback? onTap,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue.withOpacity(0.6),
            width: 2,
          ),
        ),
        suffixIcon: suffixIcon != null
            ? Icon(
                suffixIcon,
                color: Colors.blue.withOpacity(0.7),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      keyboardType: keyboardType,
      controller: TextEditingController(text: initialValue),
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }
}
