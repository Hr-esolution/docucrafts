import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

Future<File> generateMinimalDeliveryPdf(Map<String, dynamic> data) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(data["title"] ?? "BON DE LIVRAISON",
                style:
                    pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Bon de Livraison N° : ${data["deliveryNumber"]}"),
            pw.Text("Date : ${data["deliveryDate"]}"),
            pw.Divider(),
            pw.Text("Expéditeur",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text(data["senderName"]),
            pw.Text(data["senderAddress"]),
            pw.SizedBox(height: 10),
            pw.Text("Destinataire",
                style:
                    pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text(data["recipientName"]),
            pw.Text(data["recipientAddress"]),
            pw.SizedBox(height: 10),
            pw.Divider(),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Description"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Qté"),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Text("Référence"),
                  ),
                ]),
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["description"])),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["quantity"])),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(data["reference"])),
                ]),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Signature du destinataire : ________________",
                style: const pw.TextStyle(fontSize: 12)),
          ],
        );
      },
    ),
  );

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/delivery_minimal.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}
