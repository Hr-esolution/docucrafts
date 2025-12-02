import 'package:flutter/material.dart';

class MinimalInvoicePreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const MinimalInvoicePreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aperçu facture minimal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: data.entries.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text(e.value,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
