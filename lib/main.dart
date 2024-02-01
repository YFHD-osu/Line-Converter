import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_html/html.dart' as html;

import 'package:line_converter/page/home.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/provider/theme.dart';
ThemeProvider themeProvider = ThemeProvider();

const opts = FirebaseOptions(
  apiKey: "AIzaSyBrNfABqMoBVsbekhMjIP0z4i4swkqRzlM",
  authDomain: "dulcet-cat-359804.firebaseapp.com",
  projectId: "dulcet-cat-359804",
  storageBucket: "dulcet-cat-359804.appspot.com",
  messagingSenderId: "751966961116",
  appId: "1:751966961116:web:661c61fe7cf1fa23176319"
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) { // Disable context menu if is web
    html.document.onContextMenu.listen((event) => event.preventDefault());
    html.document.body!.addEventListener('contextmenu', (event) => event.preventDefault());
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]);

  await Hive.initFlutter();
  await Firebase.initializeApp(options: opts);
  await FireStore.instance.inititalze();
  await themeProvider.fetch(); // Initialize theme mode

  // await dbManager.initialize(); // Initialize sqlite database
  runApp(const MyApp());

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
          title: "車表轉換",
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