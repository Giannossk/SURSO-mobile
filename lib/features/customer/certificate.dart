import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/event.dart';

Future<void> shareCertificate({required Event event, required String attendeeName}) async {
  final doc = pw.Document();
  final accent = PdfColor.fromHex('#4F46E5');

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (context) => pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all(color: accent, width: 3)),
        padding: const pw.EdgeInsets.all(32),
        child: pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('CERTIFICATE OF ATTENDANCE',
                  style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: accent)),
              pw.SizedBox(height: 24),
              pw.Text('This certifies that', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),
              pw.Text(attendeeName, style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('attended', style: const pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),
              pw.Text(event.title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('${event.date.day}/${event.date.month}/${event.date.year} · ${event.location}',
                  style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    ),
  );

  await Printing.sharePdf(bytes: await doc.save(), filename: 'certificate-${event.id}.pdf');
}
