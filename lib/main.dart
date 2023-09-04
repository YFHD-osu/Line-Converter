import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:line_converter/Provider/theme.dart';
import 'package:line_converter/Page/HomePage/home_page.dart';
import 'package:line_converter/Library/data_manager.dart';

ThemeProvider themeProvider = ThemeProvider();

void main() async{
  await themeProvider.fetch(); // Initialize theme mode from shared_preference
  await dbManager.initialize(); // Initialize sqlite database
  
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
  Widget build(BuildContext context) => ChangeNotifierProvider(
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
            data: mediaQueryData.copyWith(textScaleFactor: 1),
            child: child!,
          );
        }
      );
    }
  );
}