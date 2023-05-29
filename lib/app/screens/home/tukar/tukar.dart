import 'package:aplikasi_sampah/app/constant/fontStyle.dart';
import 'package:aplikasi_sampah/app/constant/style.dart';
// import 'package:aplikasi_sampah/app/screens/auth/auth_controller.dart';
import 'package:aplikasi_sampah/app/screens/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../routes/links.dart';
import '../../../constant/color.dart';
import 'package:get/get.dart';
// import 'detail_produk.dart';

class TukarPoinView extends StatefulWidget {
  const TukarPoinView({super.key});
  @override
  State<TukarPoinView> createState() => _TukarPoinView();
}

class _TukarPoinView extends State<TukarPoinView> {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final Stream<QuerySnapshot> _produkStream = FirebaseFirestore.instance
      .collection('produk')
      .orderBy('poin', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // final Stream<DocumentSnapshot> userStream =
    //     users.doc(auth.currentUser!.email).snapshots();
    // final TukarController  tukarC = Get.put(TukarController());
    // final AuthController authC = Get.put(AuthController());
    final poin =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
            title: const Text("Tukar Poin", style: appFontTitlePage),
            centerTitle: true,
            backgroundColor: colorPrimary,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: colorBackground)),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RiwayatTukarView(),
                        ));
                  },
                  icon: const Icon(Icons.history_rounded))
            ]),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.5,
                                color: colorPrimary,
                                style: BorderStyle.solid),
                            boxShadow: [boxShadow],
                            gradient: const LinearGradient(
                                colors: [colorAccent, colorAccent2]),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("Poin terkumpul",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Satoshi",
                                      fontWeight: FontWeight.w500,
                                      color: colorPrimary)),
                              Text(poin["poin"].toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontFamily: "Satoshi",
                                      fontWeight: FontWeight.w600,
                                      color: colorPrimary)),
                            ])),
                    const SizedBox(height: 32),
                    const Text("Produk",
                        style: TextStyle(
                            fontFamily: "Satoshi",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: colorPrimary)),
                    const SizedBox(height: 18),
                    StreamBuilder<QuerySnapshot>(
                        stream: _produkStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return Container(
                                  height: 102,
                                  width: Get.width,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: boxDecoration,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(data['nama'],
                                                style: appFontHeding2a),
                                            const SizedBox(height: 8),
                                            Text("${data['poin']} Poin",
                                                style: appFontHeding1a)
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Get.toNamed(
                                                AppLinks.TUKAR_POIN_PRODUK,
                                                arguments: data);
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios_rounded),
                                          color: colorPrimary,
                                        )
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          );
                        })
                  ],
                ),
              )),
        ));
  }
}
