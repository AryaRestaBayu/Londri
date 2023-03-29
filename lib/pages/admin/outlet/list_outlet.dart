import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:londri/utils.dart';

class ListOutlet extends StatefulWidget {
  const ListOutlet({super.key});

  @override
  State<ListOutlet> createState() => _ListOutletState();
}

TextEditingController editC = TextEditingController();
TextEditingController tambahC = TextEditingController();

class _ListOutletState extends State<ListOutlet> {
  @override
  void initState() {
    _streamData = _referenceOutlet.snapshots();
    super.initState();
  }

  late Stream<QuerySnapshot> _streamData;

  List parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List listOutlet = listDocs
        .map((e) => {
              'id': e.id,
              'list_outlet': e['nama_outlet'],
            })
        .toList();

    return listOutlet;
  }

  final Query _referenceOutlet = FirebaseFirestore.instance
      .collection('outlet')
      .where('nama_outlet', isNotEqualTo: 'Outlet Tidak Tersedia');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('list outlet'),
        backgroundColor: Color(0xFF67bde1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamData,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            List outlet = parseData(snapshot.data!);
            return listview(outlet);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF67bde1),
        onPressed: () {
          showDialog(
              //floating action button list outlet
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Tambah Outlet'),
                  content: TextFormField(
                    controller: tambahC,
                    textInputAction: TextInputAction.next,
                    maxLength: 25,
                    decoration: const InputDecoration(
                        hintText: 'Nama Outlet',
                        prefixIcon: Icon(
                          Icons.home_outlined,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Batal',
                            style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () {
                          tambah(tambahC.text);
                          tambahC.text = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Tambah',
                            style: TextStyle(color: Colors.blue)))
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView listview(List outletItem) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: outletItem.length,
        itemBuilder: (context, index) {
          Map thisOutlet = outletItem[index];
          return Container(
            height: sizeHeight * 0.08,
            margin: EdgeInsets.only(
              top: sizeHeight * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xFFdef0f2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sizeWidth * 0.10),
                  child: Center(
                    child: Text(
                      thisOutlet['list_outlet'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: sizeWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight,
                  width: sizeWidth * 0.40,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //edit outlet
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(thisOutlet['list_outlet']),
                                      content: TextFormField(
                                        controller: editC,
                                        textInputAction: TextInputAction.next,
                                        maxLength: 25,
                                        decoration: const InputDecoration(
                                            hintText: 'Nama Baru Outlet',
                                            prefixIcon: Icon(
                                              Icons.home_outlined,
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)))),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Batal',
                                                style: TextStyle(
                                                    color: Colors.red))),
                                        TextButton(
                                            onPressed: () {
                                              editOutlet(editC.text,
                                                  thisOutlet['list_outlet']);

                                              Navigator.pop(context);
                                              Utils.showSnackBar(
                                                  '${thisOutlet['list_outlet']} diubah menjadi ${editC.text}',
                                                  Colors.blue);
                                              editC.text = '';
                                            },
                                            child: const Text('Ubah',
                                                style: TextStyle(
                                                    color: Colors.blue)))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Hapus ${thisOutlet['list_outlet']}'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Batal',
                                                style: TextStyle(
                                                    color: Colors.blue))),
                                        TextButton(
                                            onPressed: () {
                                              delete(thisOutlet['list_outlet']);
                                              Navigator.pop(context);
                                              Utils.showSnackBar(
                                                  '${thisOutlet['list_outlet']} telah dihapus',
                                                  Colors.red);
                                            },
                                            child: const Text('Hapus',
                                                style: TextStyle(
                                                    color: Colors.red)))
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ]),
                ),
              ],
            ),
          );
        });
  }

  Future delete(String past) async {
    await FirebaseFirestore.instance.collection('outlet').doc(past).delete();
  }

  Future editOutlet(String outlet, String past) async {
    delete(past);
    await FirebaseFirestore.instance.collection('outlet').doc(outlet).set({
      'nama_outlet': outlet,
    });
  }

  Future tambah(String outlet) async {
    await FirebaseFirestore.instance.collection('outlet').doc(outlet).set({
      'nama_outlet': outlet,
    });
    Utils.showSnackBar('$outlet telah ditambahkan', Colors.blue);
  }
}
