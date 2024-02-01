import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const opts = FirebaseOptions(
    apiKey: "AIzaSyBrNfABqMoBVsbekhMjIP0z4i4swkqRzlM",
    authDomain: "dulcet-cat-359804.firebaseapp.com",
    projectId: "dulcet-cat-359804",
    storageBucket: "dulcet-cat-359804.appspot.com",
    messagingSenderId: "751966961116",
    appId: "1:751966961116:web:661c61fe7cf1fa23176319"
  );
  await Firebase.initializeApp(options: opts);

  final resp = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "test@gmail.com", password: "123456");
  final uid = resp.user!.uid;
  debugPrint(uid.toString());
  debugPrint("A");
  final ref = FirebaseFirestore.instance.collection('collectionPath');
  debugPrint("B");
  var querySnapshot = await ref.get();
  debugPrint("C");
  debugPrint(querySnapshot.docs.toString());
  debugPrint("D");
  // final r = await dbc.doc("bzxnFzvOTHT3CgiticOe").get();

}