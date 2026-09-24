import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'database_helper.dart';

class PdfExporter {
  
  // Creates and compiles the structured PDF document layout
  static Future<pw.Document> buildPdfDocument(
    String motherName,
    List<Map<String, dynamic>> symptomRawData,
  ) async {
    final pdf = pw.Document(title: "SafeMoms_Medical_Report");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4, // Standard global medical paper format sizes
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 4),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  "This report is for informational purposes only. Clinical decisions should be guided by a certified health professional.",
                  style: pw.TextStyle(fontSize: 8, fontStyle: pw.FontStyle.italic, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            // Medical Report Document Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("SAFEMOMS DIGITAL HEALTH RECORD", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.pink)),
                  pw.Text("OFFLINE BACKUP CLINICAL LOG", style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Patient Meta Profiles Summary Card Box Block
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                color: PdfColors.grey100,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("Patient Name: $motherName", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text("Export Date: ${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey800)),
                  pw.SizedBox(height: 4),
                  pw.Text("Status: Relational SQLite database log extracted completely offline.", style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            pw.Text("Recent Daily Health Log Data", style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),

            // Relational Data Matrix Chart Generation
            symptomRawData.isEmpty
                ? pw.Paragraph(text: "No daily health symptom metrics recorded by the patient during this gestational timeline window.")
                : pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey300),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2), // Date
                      1: const pw.FlexColumnWidth(2), // Weight
                      2: const pw.FlexColumnWidth(2), // Blood Pressure
                      3: const pw.FlexColumnWidth(4), // Symptom Notes
                    },
                    children: [
                      // Table Headers Row
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColors.pink100),
                        children: [
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Logged Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Weight", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Blood Pressure", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                          pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("Clinical Symptom Notes", style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                        ],
                      ),
                      // Loop and map each row entry from your storage table straight into a paper line row grid line
                      ...symptomRawData.map((log) {
                        return pw.TableRow(
                          children: [
                            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(log['logged_date'].toString())),
                            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(log['weight'].toString())),
                            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text("${log['systolic_bp']}/${log['diastolic_bp']} mmHg")),
                            pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(log['symptom_notes'].toString())),
                          ],
                        );
                      }),
                    ],
                  ),
          ];
        },
      ),
    );

    return pdf;
  }

  // Core Engine: Queries SQLite, compiles a chart document, and triggers the phone's native file saver
  static Future<void> generateAndShareReport(String motherName) async {
    // 1. Extract the raw historical data rows straight out of SQLite symptoms table
    final List<Map<String, dynamic>> symptomRawData = await DatabaseHelper.instance.fetchSymptomHistory();
    
    // 2. Build the PDF virtual document buffer
    final pdf = await buildPdfDocument(motherName, symptomRawData);

    // 3. Fire Phone Native Storage Engine Share/Print overlay sheets
    await Printing.sharePdf(
      bytes: await pdf.save(), 
      filename: 'AfriMoms_Doctor_Report_${motherName.replaceAll(" ", "_")}.pdf'
    );
  }
}