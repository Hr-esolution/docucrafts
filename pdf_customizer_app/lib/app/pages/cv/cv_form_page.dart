import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/cv_controller.dart';

class CvFormPage extends StatelessWidget {
  const CvFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CvController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un CV'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => controller.saveCv(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ListView.builder(
            itemCount: controller.fields.length,
            itemBuilder: (context, index) {
              final field = controller.fields[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (field.type == FieldType.date)
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Sélectionnez une date',
                          border: const OutlineInputBorder(),
                          suffixIcon: const Icon(Icons.date_range),
                        ),
                        readOnly: true,
                        controller: TextEditingController(text: field.value),
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
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Entrez un nombre',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(text: field.value),
                        onChanged: (value) => controller.updateFieldValue(
                          field.id,
                          value,
                        ),
                      ),
                    if (field.type == FieldType.phone)
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Entrez un numéro de téléphone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        controller: TextEditingController(text: field.value),
                        onChanged: (value) => controller.updateFieldValue(
                          field.id,
                          value,
                        ),
                      ),
                    if (field.type == FieldType.email)
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Entrez une adresse email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        controller: TextEditingController(text: field.value),
                        onChanged: (value) => controller.updateFieldValue(
                          field.id,
                          value,
                        ),
                      ),
                    if (field.type == FieldType.text)
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Entrez ${field.label.toLowerCase()}',
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: field.label.contains('Désignation') ? 3 : 1,
                        controller: TextEditingController(text: field.value),
                        onChanged: (value) => controller.updateFieldValue(
                          field.id,
                          value,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}