import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/constants.dart';

class ImageRetrive extends StatefulWidget {
  final String? userId;
  const ImageRetrive({Key? key, this.userId}) : super(key: key);

  @override
  State<ImageRetrive> createState() => _ImageRetriveState();
}

class _ImageRetriveState extends State<ImageRetrive> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Images")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("shops")
            .doc(currentCategory)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['$currentShopIndex']['images']['0'] != null) {
              return ListView.builder(
                itemCount: snapshot.data['0']['total-images']+1,
                itemBuilder: (BuildContext context, int index) {
                  String url = snapshot.data['0']['images']['$index'];
                  return Image.network(
                    url,
                    height: 300,
                    fit: BoxFit.fitWidth,
                  );
                },
              );
            } else {
              return const Center(
                child: Text("No images found"),
              );
            }
          } else {
            return (const Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}