import 'package:flutter/material.dart';

class DocumentTypeCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color color;
  final VoidCallback onTap;

  const DocumentTypeCard({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconData(),
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (title.toLowerCase()) {
      case 'invoice':
        return Icons.receipt;
      case 'quote':
        return Icons.calculate;
      case 'delivery':
        return Icons.local_shipping;
      case 'business card':
        return Icons.business;
      case 'cv':
        return Icons.person;
      default:
        return Icons.document_scanner;
    }
  }
}