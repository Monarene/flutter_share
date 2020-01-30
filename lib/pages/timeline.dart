import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    //createUser();
    //updateUser();
    deleteUser();
    super.initState();
  }

  /* getUsers() async {
    final QuerySnapshot snapshot = await usersRef.getDocuments();
  }

  getUsersById() async {
    final String id = "cko0TYixL1CfHVyKWq30";
    DocumentSnapshot docs = await usersRef.document(id).get();
    print(docs.data);
    print(docs.exists);
  } */

  createUser() {
    usersRef
        .document("asdfasdf")
        .setData({"username": "Jeff", "postCount": 0, "isAdmin": false});
  }

  updateUser() async {
    final DocumentSnapshot doc =
        await usersRef.document("cko0TYixL1CfHVyKWq30").get();
    if (doc.exists) {
      doc.reference
          .updateData({"username": "John", "postCount": 3, "isAdmin": false});
    }
  }

  deleteUser() async {
    final DocumentSnapshot doc = await usersRef.document("asdfasdf").get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> children = snapshot.data.documents
              .map((doc) => Text(doc['username']))
              .toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}
