// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:flutter/services.dart' show rootBundle;

// Future pdfInvoiceDownload(
//   BuildContext context,
//   String? title,
//   String? body,
// ) async {
//   final pdf = pw.Document();
//   // add asset image
//   final bytes =
//       (await rootBundle.load('assets/images/demo.png')).buffer.asUint8List();
//   final image = pw.MemoryImage(bytes);
//   pdf.addPage(pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (pw.Context context) {
//         return pw.Column(children: [
//           pw.GridView(
//             crossAxisCount: 2,
//             children: [
//               pw.Image(image),
//             ],
//           ),
//         ]);
//       }));
//   final pdfSaved = await pdf.save();
//   await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfSaved);
// }
