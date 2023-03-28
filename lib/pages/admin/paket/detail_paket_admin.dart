import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:londri/pages/admin/paket/edit_paket.dart';
import 'package:londri/service/pdf_service.dart';

class DetailPaketAdmin extends StatefulWidget {
  DetailPaketAdmin(
    this.itemId, {
    super.key,
  }) {
    _reference = FirebaseFirestore.instance.collection('paket').doc(itemId);
    _futureData = _reference.snapshots();
  }

  final String itemId;
  late DocumentReference _reference;
  late Stream<DocumentSnapshot> _futureData;

  @override
  State<DetailPaketAdmin> createState() => _DetailPaketAdminState();
}

class _DetailPaketAdminState extends State<DetailPaketAdmin> {
  late String initialNama;
  late String initialEmail;
  late String initialBerat;
  late String initialHarga;
  late String initialOutlet;
  late String initialStatus;
  late String initialPoto;

  Future getInitial() async {
    var doc = await FirebaseFirestore.instance
        .collection('paket')
        .doc(widget.itemId)
        .get();
    var getNama = doc.get('nama_client');
    var getEmail = doc.get('email');
    var getBerat = doc.get('berat');
    var getHarga = doc.get('harga');
    var getOutlet = doc.get('outlet');
    var getStatus = doc.get('status');
    var getPoto = doc.get('poto');

    setState(() {
      initialNama = getNama;
      initialEmail = getEmail;
      initialBerat = getBerat;
      initialHarga = getHarga;
      initialOutlet = getOutlet;
      initialStatus = getStatus;
      initialPoto = getPoto;
    });
  }

  @override
  void initState() {
    getInitial();
    super.initState();
  }

  logPrint(String s) {
    print(s);
  }

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;

    double sizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Detail Paket',
        ),
        backgroundColor: Color(0xFF67bde1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        actions: [
          //print pdf
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PdfPreviewPage()));
            },
            icon: const Icon(
              Icons.file_download_outlined,
              color: Colors.black,
            ),
          ),
          //edit paket
          IconButton(
            onPressed: () {
              logPrint(initialOutlet);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditPaket(
                            initialNama: initialNama,
                            initialEmail: initialEmail,
                            initialBerat: initialBerat,
                            initialHarga: initialHarga,
                            initialOutlet: initialOutlet,
                            initialStatus: initialStatus,
                            initialPoto: initialPoto,
                            itemId: widget.itemId,
                          )));
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            ),
          ),
          //delete paket
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hapus Paket'),
                      content: const Text(
                        'Paket tidak dapat dipulihkan',
                        style: TextStyle(color: Colors.red),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Batal',
                                style: TextStyle(color: Colors.blue))),
                        TextButton(
                            onPressed: () {
                              widget._reference.delete();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Hapus',
                                style: TextStyle(color: Colors.red)))
                      ],
                    );
                  });
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: widget._futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data!;
            Map data = documentSnapshot.data() as Map;

            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: sizeWidth * 0.90,
                  child: Column(
                    children: [
                      //detail transaksi
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xFFdef0f2),
                          child: Container(
                            width: sizeWidth * 0.90,
                            height: sizeHeight * 0.19,
                            margin: EdgeInsets.all(8),
                            color: Color(0xFFdef0f2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Detail Transaksi',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: sizeHeight * 0.02,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: sizeHeight * 0.13,
                                    width: sizeWidth,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //judul detail transaksi
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Text('Status Transaksi'),
                                            Text('Tanggal Transaksi'),
                                            Text('Outlet'),
                                          ],
                                        ),
                                        //isi detail transaksi
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${data['status']}',
                                              style: TextStyle(
                                                color:
                                                    data['status'] == 'Proses'
                                                        ? Colors.yellow
                                                        : data['status'] ==
                                                                'Selesai'
                                                            ? Colors.green
                                                            : data['status'] ==
                                                                    'Diambil'
                                                                ? Colors.blue
                                                                : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${data['tanggal']} ${data['jam']}',
                                            ),
                                            Text(
                                              '${data['outlet']}',
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 0.02,
                      ),
                      //detail client
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFdef0f2),
                        child: Container(
                          width: sizeWidth,
                          height: sizeHeight * 0.12,
                          margin: EdgeInsets.all(8),
                          color: Color(0xFFdef0f2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detail Client',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: sizeHeight * 0.015,
                              ),
                              SizedBox(
                                width: sizeWidth,
                                height: sizeHeight * 0.07,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //judul detail client
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: const [
                                          Text('Nama Client'),
                                          Text('Email'),
                                        ],
                                      ),
                                      //isi detail client
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('${data['nama_client']}'),
                                          // Text('${data['email']}'),
                                          Text(data['email']),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 0.02,
                      ),
                      //Detail Laundry
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFdef0f2),
                        child: Container(
                          width: sizeWidth,
                          height: sizeHeight * 0.60,
                          margin: EdgeInsets.all(8),
                          color: Color(0xFFdef0f2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Detail Laundry',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: sizeHeight * 0.02,
                              ),
                              SizedBox(
                                width: sizeWidth,
                                height: sizeHeight * 0.54,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: sizeWidth,
                                      height: sizeHeight * 0.03,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //judul detail laundry
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: const [
                                              Text('Berat'),
                                            ],
                                          ),
                                          //isi detail laundry
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text('${data['berat']} kg'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sizeHeight * 0.02,
                                    ),
                                    const Text('Foto paket'),
                                    SizedBox(
                                      height: sizeHeight * 0.01,
                                    ),
                                    Center(
                                      child: Container(
                                        width: sizeWidth * 0.80,
                                        height: sizeHeight * 0.40,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: Image(
                                          image: NetworkImage(data['poto']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: sizeHeight * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total Harga',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        Text('Rp.${data['harga']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
