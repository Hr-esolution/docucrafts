import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LogoSelectionWidget extends StatelessWidget {
  final String? logoPath;
  final Function(String) onLogoSelected;

  const LogoSelectionWidget({
    Key? key,
    this.logoPath,
    required this.onLogoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Logo de l\'entreprise',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                if (logoPath != null && logoPath!.isNotEmpty)
                  Container(
                    width: 80,
                    height: 60,
                    child: Image.file(
                      File(logoPath!),
                      fit: BoxFit.contain,
                    ),
                  )
                else
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.image,
                      color: Colors.grey[400],
                      size: 30,
                    ),
                  ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _selectLogo,
                        icon: Icon(Icons.image),
                        label: Text('Sélectionner un logo'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                      if (logoPath != null && logoPath!.isNotEmpty)
                        TextButton(
                          onPressed: () => onLogoSelected(''),
                          child: Text(
                            'Supprimer le logo',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      onLogoSelected(image.path);
    }
  }
}