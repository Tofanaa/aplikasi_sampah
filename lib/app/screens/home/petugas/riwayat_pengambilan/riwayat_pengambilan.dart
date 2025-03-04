// ignore_for_file: avoid_print

import 'package:aplikasi_sampah/app/constant/fontStyle.dart';
import 'package:aplikasi_sampah/app/constant/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/color.dart';
import 'detail_riwayat_pengambilan.dart';
import 'riwayat_pengambilan_controller.dart';

class RiwayatPengambilan extends GetView<RiwayatPengambilanController> {
  RiwayatPengambilan({super.key});

  final Stream<QuerySnapshot> _transaksiSampahStream = FirebaseFirestore
      .instance
      .collection('transaksiSampah')
      .where('status', whereIn: ['Diterima', 'Ditolak'])
      .orderBy('confirmTime', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          title: const Text("Riwayat Pengambilan", style: appFontTitlePage),
          centerTitle: true,
          backgroundColor: colorPrimary,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: colorBackground)),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: _transaksiSampahStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: colorPrimary));
                      } else if (snapshot.connectionState ==
                              ConnectionState.active ||
                          snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else if (snapshot.hasData) {
                          return ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DetailPengambilanView(),
                                            settings: RouteSettings(
                                                arguments: data)));
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.all(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: boxDecorationInput,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Nama Warga",
                                                  style: appFontFormInput),
                                              const SizedBox(height: 4),
                                              Text(data['nama'],
                                                  style: appFontHeding3b),
                                              const SizedBox(height: 8),
                                              const Text("Tanggal",
                                                  style: appFontFormInput),
                                              const SizedBox(height: 4),
                                              Text(data['tanggal'],
                                                  style: appFontHeding3b),
                                              const SizedBox(height: 8),
                                              data['status'] == 'Ditolak'
                                                  ? const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Organik",
                                                            style:
                                                                appFontFormInput),
                                                        SizedBox(width: 8),
                                                        Text("-",
                                                            style:
                                                                appFontHeding3b),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text("Organik",
                                                            style:
                                                                appFontFormInput),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                            data['jumlahOrganik']
                                                                .toStringAsFixed(1),
                                                            style:
                                                                appFontHeding3b),
                                                      ],
                                                    ),
                                              const SizedBox(height: 8),
                                              data['status'] == 'Ditolak'
                                                  ? const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("Anorganik",
                                                            style:
                                                                appFontFormInput),
                                                        SizedBox(width: 8),
                                                        Text("-",
                                                            style:
                                                                appFontHeding3b),
                                                      ],
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text("Anorganik",
                                                            style:
                                                                appFontFormInput),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                            data['jumlahAnorganik']
                                                                .toStringAsFixed(1),
                                                            style:
                                                                appFontHeding3b),
                                                      ],
                                                    )
                                            ],
                                          ),
                                          data['status'] == 'Ditolak'
                                              ? Text(data['status'],
                                                  style: appFontHeding3c)
                                              : Text(data['status'],
                                                  style: appFontHeding3b)
                                        ],
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          );
                        } else {
                          return const Center(
                              child: Text('Tidak ada riwayat',
                                  style: appFontHeding2));
                        }
                      } else {
                        return Text('State: ${snapshot.connectionState}');
                      }
                    }))));
  }
}
