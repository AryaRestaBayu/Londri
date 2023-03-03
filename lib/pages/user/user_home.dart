import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:londri/pages/admin/paket/detail_paket_admin.dart';
import 'package:londri/service/auth_service.dart';

import '../../auth/login_page.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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
            })
        .toList();

    return listPaket;
  }

  final Query _referencePaket = FirebaseFirestore.instance
      .collection('paket')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Home'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
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
                      builder: (context) => DetailPaketAdmin(
                            thisPaket['id'],
                          )));
            },
            child: Container(
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //pengumuman
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: sizeHeight * 0.010, top: sizeHeight * 0.010),
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
                                    child: Text(
                                      thisPaket['list_status'],
                                      style: TextStyle(
                                        color: thisPaket['list_status'] ==
                                                'proses'
                                            ? Colors.yellow
                                            : thisPaket['list_status'] ==
                                                    'selesai'
                                                ? Colors.green
                                                : thisPaket['list_status'] ==
                                                        'diambil'
                                                    ? Colors.blue
                                                    : Colors.red,
                                        fontSize: sizeWidth * 0.043,
                                        fontWeight: FontWeight.bold,
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
                                  ),
                                  SizedBox(
                                    width: sizeWidth * 0.08,
                                  ),
                                  Expanded(
                                    child: Container(
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
                              Padding(
                                padding: EdgeInsets.only(
                                    top: sizeHeight * 0.007,
                                    right: sizeWidth * 0.03,
                                    bottom: sizeHeight * 0.008),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'Total Harga: ' + thisPaket['list_harga'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
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
