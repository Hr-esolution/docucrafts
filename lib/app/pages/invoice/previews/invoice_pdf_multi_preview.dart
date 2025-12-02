import 'package:flutter/material.dart';
import 'package:pdf_customizer_app/app/pages/invoice/templates/invoice_pdf_multi.dart';

class MultiInvoicePreview extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<InvoiceItem> items;

  const MultiInvoicePreview(
      {super.key, required this.data, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Aperçu facture multi-articles")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Articles :",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Qté: ${item.qty} • PU: ${item.price}"),
                    trailing: Text("${item.total.toStringAsFixed(2)} DH"),
                  );
                }).toList(),
              ),
            ),
            Text(
              "TOTAL : ${data["totalTtc"]} DH",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
