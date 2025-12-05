import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/document_model.dart';

class DocumentCard extends StatelessWidget {
  final DocumentModel document;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDuplicate;

  const DocumentCard({
    Key? key,
    required this.document,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    document.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'duplicate') onDuplicate?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Text('Duplicate'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${_getDocumentTypeLabel(document.type)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Created: ${_formatDate(document.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(document.type),
                const SizedBox(width: 8),
                _buildTemplateChip(document.templateId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDocumentTypeLabel(String type) {
    switch (type) {
      case 'invoice':
        return 'Invoice';
      case 'quote':
        return 'Quote';
      case 'delivery':
        return 'Delivery Note';
      case 'business_card':
        return 'Business Card';
      case 'cv':
        return 'CV';
      default:
        return type;
    }
  }

  Widget _buildStatusChip(String type) {
    Color color;
    String label;
    
    switch (type) {
      case 'invoice':
        color = Colors.green;
        label = 'Invoice';
        break;
      case 'quote':
        color = Colors.orange;
        label = 'Quote';
        break;
      case 'delivery':
        color = Colors.purple;
        label = 'Delivery';
        break;
      case 'business_card':
        color = Colors.blue;
        label = 'Card';
        break;
      case 'cv':
        color = Colors.brown;
        label = 'CV';
        break;
      default:
        color = Colors.grey;
        label = type;
    }
    
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildTemplateChip(String templateId) {
    String label = templateId.split('_').last;
    label = label[0].toUpperCase() + label.substring(1);
    
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}