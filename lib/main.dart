import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_ce/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web/web.dart' as web;

import 'package:line_converter/page/home.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/provider/theme.dart';
import 'package:line_converter/page/join.dart';
import 'package:line_converter/page/roll_call.dart';
import 'package:line_converter/page/settings.dart';

ThemeProvider themeProvider = ThemeProvider();

const opts = FirebaseOptions(
  apiKey: "AIzaSyBrNfABqMoBVsbekhMjIP0z4i4swkqRzlM",
  authDomain: "dulcet-cat-359804.firebaseapp.com",
  projectId: "dulcet-cat-359804",
  storageBucket: "dulcet-cat-359804.appspot.com",
  messagingSenderId: "751966961116",
  appId: "1:751966961116:web:661c61fe7cf1fa23176319"
);

void main() async {
  print("isRunningWithWasm");
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) { // Disable context menu if is web
  // func(event) {
  //   event.preventDefault();
  // }
  
  // web.document.oncontextmenu.add( func.toJS );
    // html.document.body!.addEventListener('contextmenu', (event) => event.preventDefault());
  }

  print("isRunningWithWasm");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]);

  // await hive.initFlutter();
  await Firebase.initializeApp(options: opts);
  await FireStore.instance.inititalze();
  await themeProvider.fetch(); // Initialize theme mode

  // await dbManager.initialize(); // Initialize sqlite database
  const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
  print(isRunningWithWasm);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int page = 0;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => themeProvider,
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      
      return MaterialApp(
        title: "車表轉換",
        home: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            body: Builder(
              builder: (context) {
                switch (page) {
                  case 0: return const HomePage();
                  case 1: return const RollCall();
                  case 2: return const Placeholder();
                }
                return const Text("How did you get here???");
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: page,
              items: const [
                BottomNavigationBarItem(
                  label: "車表",
                  icon: Icon(Icons.local_taxi)
                ),
                BottomNavigationBarItem(
                  label: "點名",
                  icon: Icon(Icons.person)
                ),
                BottomNavigationBarItem(
                  label: "檢查",
                  icon: Icon(Icons.check_box_outlined)
                )
              ],
              onTap: (value) => setState(() => page = value),
            )
          )
        ),
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