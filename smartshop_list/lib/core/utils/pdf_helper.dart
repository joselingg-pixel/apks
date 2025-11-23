import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/shop/domain/entities/shop_entities.dart';

class PdfHelper {
  static Future<void> generateAndShare(ShoppingList list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0, 
                child: pw.Text("SmartShop List: ${list.title}", style: pw.TextStyle(fontSize: 24))
              ),
              pw.SizedBox(height: 20),
              ...list.items.map(
                (item) => pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 10, height: 10,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                          color: item.isCompleted ? PdfColors.grey : PdfColors.white
                        )
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text("${item.name} (${item.category})", style: pw.TextStyle(fontSize: 16)),
                    ]
                  )
                )
              ),
              pw.SizedBox(height: 30),
              pw.Footer(title: pw.Text("Generado con SmartShop App"))
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/lista_${list.id}.pdf");
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Mi lista de la compra: ${list.title}');
  }
}
