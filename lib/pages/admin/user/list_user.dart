import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(title: Text('user')),
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
          return Container(
            decoration: BoxDecoration(),
            child: Container(
              height: sizeHeight * 0.08,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1)),
                color: Colors.white,
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
                  Container(
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
                                        content: Container(
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
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                editRole(thisUser['list_email'],
                                                    valueRole);
                                                Navigator.pop(context);
                                              },
                                              child: Text('yes'))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Hapus akun'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Batal')),
                                          TextButton(
                                              onPressed: () {
                                                delete(thisUser['list_email']);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Hapus'))
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete))
                        ]),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future editRole(String email, String role) async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'role': role,
    });
  }

  Future delete(String email) async {
    await FirebaseFirestore.instance.collection('users').doc(email).delete();
  }
}
