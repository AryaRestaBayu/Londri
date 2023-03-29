import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:londri/auth/register_page.dart';
import 'package:londri/auth/register_page_admin.dart';
import 'package:londri/utils.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  void initState() {
    _streamData = _referenceUser.snapshots();
    super.initState();
  }

  late Stream<QuerySnapshot> _streamData;

  List parseData(QuerySnapshot querySnapshot) {
    List<QueryDocumentSnapshot> listDocs = querySnapshot.docs;
    List listUser = listDocs
        .map((e) => {
              'id': e.id,
              'list_email': e['email'],
              'list_role': e['role'],
            })
        .toList();

    return listUser;
  }

  final Query _referenceUser = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
        backgroundColor: Color(0xFF67bde1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _streamData,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }
          if (snapshot.hasData) {
            List user = parseData(snapshot.data!);
            return listview(user);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => RegisterPageAdmin()));
        },
        child: Icon(Icons.person_add_alt),
        backgroundColor: Color(0xFF67bde1),
      ),
    );
  }

  List listRole = [
    'user',
    'kasir',
    'owner',
    'admin',
  ];

  ListView listview(List userItem) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: userItem.length,
        itemBuilder: (context, index) {
          Map thisUser = userItem[index];
          String valueRole = thisUser['list_role'];
          return Padding(
            padding: EdgeInsets.only(
              top: sizeHeight * 0.02,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 2,
              child: Container(
                width: sizeWidth * 0.03,
                height: sizeHeight * 0.08,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFdef0f2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: sizeWidth * 0.10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            thisUser['list_email'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: sizeWidth * 0.038,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            thisUser['list_role'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: sizeWidth * 0.038,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight,
                      width: sizeWidth * 0.40,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(thisUser['list_email']),
                                          content: SizedBox(
                                            height: sizeHeight * 0.09,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //role
                                                DropdownButtonFormField2(
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    ),
                                                    value: valueRole,
                                                    items: listRole
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      valueRole = value!;
                                                    },
                                                    buttonStyleData:
                                                        const ButtonStyleData(
                                                      height: 60,
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                    ),
                                                    iconStyleData:
                                                        const IconStyleData(
                                                      icon: Icon(
                                                        Icons.list,
                                                        color: Colors.black45,
                                                      ),
                                                      iconSize: 30,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Batal',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  editRole(
                                                      thisUser['list_email'],
                                                      valueRole);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ubah'))
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
                                          title: const Text('Hapus akun'),
                                          content: const Text(
                                            'Akun akan dihapus permanen dan tidak dapat dipulihkan',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Batal')),
                                            TextButton(
                                                onPressed: () {
                                                  delete(
                                                      thisUser['list_email']);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
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
              ),
            ),
          );
        });
  }

  Future editRole(String email, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'role': role,
    });
    Utils.showSnackBar('Role $email berubah menjadi $role', Colors.blue);
  }

  Future delete(String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).delete();
    Utils.showSnackBar('Email $email telah dihapus permanen', Colors.red);
  }
}
