import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:londri/auth/login_page.dart';
import 'package:londri/pages/admin/paket/tambah_paket.dart';
import 'package:londri/pages/user/detail_paket_user.dart';
import 'package:londri/service/auth_service.dart';

import 'detail_paket_kasir.dart';

class KasirHome extends StatefulWidget {
  const KasirHome({super.key});

  @override
  State<KasirHome> createState() => _KasirHomeState();
}

class _KasirHomeState extends State<KasirHome> {
  @override
  void initState() {
    _streamData = _referencePaket.snapshots();
    super.initState();
  }

  late Stream<QuerySnapshot> _streamData;
  List parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List listPaket = listDocs
        .map((e) => {
              'id': e.id,
              'list_nama_client': e['nama_client'],
              'list_email': e['email'],
              'list_status': e['status'],
              'list_tanggal': e['tanggal'],
              'list_harga': e['harga'],
              'list_outlet': e['outlet'],
              'list_poto': e['poto'],
            })
        .toList();
    return listPaket;
  }

  final Query _referencePaket = FirebaseFirestore.instance.collection('paket');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Home'),
        backgroundColor: Color(0xFF67bde1),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamData,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            List paket = parseData(snapshot.data!);
            return listview(paket);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF67bde1),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPaket()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView listview(List paketItems) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: paketItems.length,
        itemBuilder: (context, index) {
          Map thisPaket = paketItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPaketKasir(
                            thisPaket['id'],
                          )));
            },
            child: Container(
                decoration: const BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: sizeHeight * 0.030),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2,
                        child: Container(
                          height: sizeHeight * 0.25,
                          width: sizeWidth * 0.80,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                            // color: Color(0xFF208BD8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: sizeHeight * 0.010,
                                        left: sizeWidth * 0.03,
                                        right: sizeWidth * 0.02),
                                    child: Text(
                                      thisPaket['list_tanggal'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeWidth * 0.038,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: sizeHeight * 0.010,
                                        left: sizeWidth * 0.03,
                                        right: sizeWidth * 0.02),
                                    child: Container(
                                      width: sizeWidth * 0.18,
                                      height: sizeHeight * 0.025,
                                      decoration: BoxDecoration(
                                          color: thisPaket['list_status'] ==
                                                  'Proses'
                                              ? Colors.yellow
                                              : thisPaket['list_status'] ==
                                                      'Selesai'
                                                  ? Colors.green
                                                  : thisPaket['list_status'] ==
                                                          'Diambil'
                                                      ? Colors.blue
                                                      : Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Center(
                                        child: Text(
                                          thisPaket['list_status'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sizeWidth * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: sizeWidth * 0.03),
                                    height: sizeHeight * 0.15,
                                    width: sizeWidth * 0.30,
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: Image(
                                      image:
                                          NetworkImage(thisPaket['list_poto']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.08,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: sizeHeight * 0.15,
                                      width: sizeWidth * 0.30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(thisPaket['list_nama_client']),
                                          Text(thisPaket['list_email']),
                                          Text(thisPaket['list_outlet']),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: sizeWidth * 0.48,
                                  height: sizeHeight * 0.025,
                                  margin: EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFdef0f2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Total harga Rp.${thisPaket['list_harga']}',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
