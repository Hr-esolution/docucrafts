import 'package:flutter/material.dart';
import '../models/field_model.dart';

class FieldConfigItem extends StatelessWidget {
  final FieldModel field;
  final ValueChanged<bool>? onEnabledChanged;
  final ValueChanged<bool>? onRequiredChanged;

  const FieldConfigItem({
    Key? key,
    required this.field,
    this.onEnabledChanged,
    this.onRequiredChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${_getFieldTypeLabel(field.type)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: field.enabled,
              onChanged: onEnabledChanged,
            ),
            const SizedBox(width: 8),
            if (field.enabled)
              Switch(
                value: field.required,
                onChanged: onRequiredChanged,
                activeColor: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  String _getFieldTypeLabel(String type) {
    switch (type) {
      case 'text':
        return 'Text';
      case 'number':
        return 'Number';
      case 'date':
        return 'Date';
      case 'email':
        return 'Email';
      case 'textarea':
        return 'Text Area';
      case 'table':
        return 'Table';
      case 'signature':
        return 'Signature';
      case 'image':
        return 'Image';
      case 'url':
        return 'URL';
      case 'list':
        return 'List';
      default:
        return type[0].toUpperCase() + type.substring(1);
    }
  }
}