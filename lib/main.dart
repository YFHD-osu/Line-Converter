import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:line_converter/core/database.dart';
import 'package:line_converter/provider/theme.dart';
// import 'package:line_converter/Library/data_manager.dart';
import 'package:line_converter/Page/home.dart';
ThemeProvider themeProvider = ThemeProvider();

void main() async{
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
  await FireStore.instance.inititalze();

  final resp = await FirebaseAuth.instance.signInWithEmailAndPassword(email: "test@gmail.com", password: "123456");
  final ref = FirebaseFirestore.instance.collection('userdata');
  var querySnapshot = ref.doc(resp.user!.uid);
  print(querySnapshot.get);
  
  await themeProvider.fetch(); // Initialize theme mode from shared_preference
  // await dbManager.initialize(); // Initialize sqlite database
  runApp(const MyApp());

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  /*SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => 
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        
        return MaterialApp(
          home: const HomePage(),
          theme: ThemePack.light,
          darkTheme: ThemePack.dark,
          themeMode: themeProvider.theme,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData,
              child: child!,
            );
          }
        );
      }
    );
  }