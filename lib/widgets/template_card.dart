import 'package:flutter/material.dart';
import '../models/template_model.dart';

class TemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback? onTap;
  final bool isSelected;

  const TemplateCard({
    Key? key,
    required this.template,
    this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Icon(
                  Icons.picture_as_pdf,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                template.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _getDocumentTypeLabel(template.documentType),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: template.fields
                    .take(3) // Show only first 3 fields as tags
                    .map((field) => Chip(
                          label: Text(
                            field.label,
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: field.required
                              ? Colors.red.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                        ))
                    .toList(),
              ),
              if (template.fields.length > 3)
                Text(
                  '+${template.fields.length - 3} more',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDocumentTypeLabel(String type) {
    switch (type) {
      case 'invoice':
        return 'Invoice Template';
      case 'quote':
        return 'Quote Template';
      case 'delivery':
        return 'Delivery Template';
      case 'business_card':
        return 'Business Card Template';
      case 'cv':
        return 'CV Template';
      default:
        return '${type[0].toUpperCase()}${type.substring(1)} Template';
    }
  }
}