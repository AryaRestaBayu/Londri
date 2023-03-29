import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfPreviewPage extends StatelessWidget {
  final String getPoto;
  final String getStatus;
  final String getTanggal;
  final String getOutlet;
  final String getNama;
  final String getEmail;
  final String getBerat;
  final String getHarga;
  final String getJam;

  PdfPreviewPage(
      {required this.getPoto,
      required this.getStatus,
      required this.getTanggal,
      required this.getOutlet,
      required this.getNama,
      required this.getEmail,
      required this.getBerat,
      required this.getHarga,
      required this.getJam,
      Key? key})
      : super(key: key);

  final String tgl = DateFormat.d().format(DateTime.now());
  final String bulan = DateFormat.yMMMM().format(DateTime.now());
  final String jam = DateFormat.Hm().format(DateTime.now());
  final pw.TextStyle style = const pw.TextStyle(fontSize: 15);
  final pw.SizedBox sizedBox = pw.SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    final ByteData bytes = await rootBundle.load('images/logo.png');
    final netImage = await networkImage(getPoto);
    final Uint8List byteList = bytes.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 25),
                          pw.Text(
                            'Detail Paket',
                            style: pw.TextStyle(
                                fontSize: 30, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 15),
                          pw.Text('$tgl $bulan $jam',
                              style: pw.TextStyle(fontSize: 15))
                        ],
                      ),
                      pw.Image(pw.MemoryImage(byteList),
                          fit: pw.BoxFit.fitHeight, height: 120, width: 120)
                    ]),
                pw.Divider(borderStyle: pw.BorderStyle.solid),
                pw.SizedBox(height: 20),
                pw.Container(
                  width: 550,
                  child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Status Transaksi', style: style),
                              sizedBox,
                              pw.Text('Tanggal Transaksi', style: style),
                              sizedBox,
                              pw.Text('Outlet Transaksi', style: style),
                              sizedBox,
                              pw.Text('Nama Client', style: style),
                              sizedBox,
                              pw.Text('Email', style: style),
                              sizedBox,
                              pw.Text('Berat', style: style),
                              sizedBox,
                              pw.Text('Foto Paket', style: style),
                              pw.SizedBox(height: 332),
                              pw.Text('Total Harga',
                                  style: pw.TextStyle(fontSize: 17)),
                            ]),
                        pw.Container(
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                sizedBox,
                                pw.Text(':', style: style),
                                pw.SizedBox(height: 332),
                                pw.Text(':', style: style),
                              ]),
                        ),
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(getStatus, style: style),
                              sizedBox,
                              pw.Text('$getTanggal $getJam', style: style),
                              sizedBox,
                              pw.Text(getOutlet, style: style),
                              sizedBox,
                              pw.Text(getNama, style: style),
                              sizedBox,
                              pw.Text(getEmail, style: style),
                              sizedBox,
                              pw.Text('$getBerat kg', style: style),
                              sizedBox,
                              pw.Image((netImage),
                                  fit: pw.BoxFit.cover,
                                  height: 340,
                                  width: 340),
                              sizedBox,
                              pw.Text('Rp.$getHarga',
                                  style: pw.TextStyle(fontSize: 17)),
                            ]),
                      ]),
                ),
              ]);
        }));
    return pdf.save();
  }
}
