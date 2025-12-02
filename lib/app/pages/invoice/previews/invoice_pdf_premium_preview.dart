import 'package:flutter/material.dart';

class PremiumInvoicePreview extends StatelessWidget {
  final Map<String, dynamic> data;
  const PremiumInvoicePreview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aperçu facture premium")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("FACTURE PREMIUM",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...data.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(e.value,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ))
          ],
        ),
      ),
    );
  }
}
