import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:londri/pages/admin/paket/detail_paket_admin.dart';

import '../../../utils.dart';

class EditPaket extends StatefulWidget {
  EditPaket(
      {required this.initialBerat,
      required this.initialEmail,
      required this.initialHarga,
      required this.initialNama,
      required this.itemId,
      required this.initialOutlet,
      required this.initialStatus,
      required this.initialPoto,
      super.key});

  final String initialNama;
  final String initialEmail;
  final String initialBerat;
  final String initialHarga;
  String initialOutlet;
  String initialStatus;
  String initialPoto;
  final String itemId;

  @override
  State<EditPaket> createState() => _EditPaketState();
}

TextEditingController namaClientC = TextEditingController();
TextEditingController emailC = TextEditingController();
TextEditingController hargaC = TextEditingController();
TextEditingController beratC = TextEditingController();

final String tgl = DateFormat.d().format(DateTime.now());
final String bulan = DateFormat.yMMMM().format(DateTime.now());
final String jam = DateFormat.Hm().format(DateTime.now());

final String tanggal = '$tgl $bulan';

class _EditPaketState extends State<EditPaket> {
  List? outlet;
  final List status = [
    'Proses',
    'Selesai',
    'Diambil',
    'Dibatalkan',
  ];

  @override
  void initState() {
    getoutlet();
    namaClientC.text = widget.initialNama;
    emailC.text = widget.initialEmail;
    beratC.text = widget.initialBerat;
    hargaC.text = widget.initialHarga;
    super.initState();
  }

  Future getoutlet() async {
    var doc = await FirebaseFirestore.instance
        .collection('outlet')
        .doc('outlet')
        .get();
    var _getOutlet = doc.get('outlet');
    setState(() {
      outlet = _getOutlet;
    });
  }

  String imageUrl = '';
  File? _image;

  final _formKey = GlobalKey<FormState>();

  bool namaValidate = false;
  bool emailValidate = false;
  bool hargaValidate = false;
  bool beratValidate = false;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Paket'),
      ),
      body: Center(
        child: SizedBox(
          height: sizeHeight,
          width: sizeWidth * 0.83,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: sizeHeight * 0.03,
                  ),
                  //nama client
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: namaClientC,
                    maxLength: 25,
                    decoration: InputDecoration(
                        errorText:
                            namaValidate ? 'Nama tidak boleh kosong' : null,
                        hintText: 'Nama Client',
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  //email
                  TextFormField(
                    controller: emailC,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 40,
                    decoration: InputDecoration(
                        errorText:
                            emailValidate ? 'Email tidak boleh kosong' : null,
                        hintText: 'Email Client',
                        prefixIcon: Icon(
                          Icons.alternate_email,
                        ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  //berat
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: beratC,
                    maxLength: 3,
                    decoration: InputDecoration(
                        errorText:
                            beratValidate ? 'Berat tidak boleh kosong' : null,
                        hintText: 'Berat',
                        prefixIcon: Icon(Icons.scale),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  //harga
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: hargaC,
                    maxLength: 8,
                    decoration: InputDecoration(
                        errorText:
                            hargaValidate ? 'Harga tidak boleh kosong' : null,
                        hintText: 'Harga',
                        prefixIcon: Icon(Icons.attach_money_rounded),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  ),
                  //outlet
                  DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Icon(
                            Icons.house,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            'Pilih Outlet',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                        ],
                      ),
                      value: widget.initialOutlet,
                      items: outlet!
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Silahkan pilih outlet';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.initialOutlet = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 60,
                        padding: EdgeInsets.only(right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.list,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                  const SizedBox(height: 23),
                  //status
                  DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      isExpanded: true,
                      hint: Row(
                        children: const [
                          Icon(
                            Icons.check_box,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            'Status Paket',
                            style:
                                TextStyle(fontSize: 15, color: Colors.black54),
                          ),
                        ],
                      ),
                      value: widget.initialStatus,
                      items: status
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Silahkan pilih status paket';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        widget.initialStatus = value.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        height: 60,
                        padding: EdgeInsets.only(right: 10),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.list,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )),
                  const SizedBox(height: 25),
                  //poto
                  GestureDetector(
                    onTap: () async {
                      if (emailC.text.isEmpty) {
                        setState(() {
                          emailValidate = true;
                        });
                        return;
                      }

                      //pick image from gallery
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.camera, imageQuality: 15);

                      if (file == null) {
                        return;
                      } else {
                        setState(() {
                          _image = File(file.path);
                        });
                      }

                      //upload image to firebase storage
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImage =
                          referenceRoot.child(emailC.text);
                      Reference referenceImageToUpload =
                          referenceDirImage.child(
                              DateTime.now().millisecondsSinceEpoch.toString());
                      try {
                        await referenceImageToUpload.putFile(File(file.path));

                        widget.initialPoto =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (e) {
                        Utils.showSnackBar(e.toString(), Colors.red);
                      }
                    },
                    child: Container(
                      width: sizeWidth * 0.70,
                      height: sizeHeight * 0.35,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54)),
                      child: _image == null
                          ? Image(
                              image: NetworkImage(widget.initialPoto),
                              fit: BoxFit.cover,
                            )
                          : Image.file(_image!, fit: BoxFit.cover),
                      // : Image(image: NetworkImage(imageUrl)),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          namaClientC.text.isEmpty
                              ? namaValidate = true
                              : namaValidate = false;
                          emailC.text.isEmpty
                              ? emailValidate = true
                              : emailValidate = false;
                          hargaC.text.isEmpty
                              ? hargaValidate = true
                              : hargaValidate = false;
                        });
                        if (namaValidate == true) return;
                        if (emailValidate == true) return;
                        if (hargaValidate == true) return;

                        final isValid = _formKey.currentState!.validate();
                        if (!isValid) {
                          return;
                        }

                        if (widget.initialPoto == '') {
                          Utils.showSnackBar(
                              "Silahkan tambahkan foto paket", Colors.red);
                          return;
                        }
                        addPaket();
                        emailC.text = '';
                        hargaC.text = '';
                        namaClientC.text = '';
                        Navigator.pop(context);
                      },
                      child: Text('Edit Paket'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future addPaket() async {
    FirebaseFirestore.instance.collection('paket').doc(widget.itemId).set({
      'email': emailC.text.trim(),
      'harga': hargaC.text,
      'berat': beratC.text,
      'nama_client': namaClientC.text,
      'outlet': widget.initialOutlet,
      'status': widget.initialStatus,
      'tanggal': tanggal,
      'jam': '$jam WIB',
      'poto': widget.initialPoto,
    });
  }
}
