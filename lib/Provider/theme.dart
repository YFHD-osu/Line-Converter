import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;
  Box? _box;
  
  Future<ThemeMode> fetch() async {
    _box ??= await Hive.openBox('theme');
    final index = int.parse(await _box!.get("themeMode", defaultValue: "0"));
    theme = ThemeMode.values[index];
    return theme;
  }

  Future<void> toggle(ThemeMode themeMode) async {
    _box!.put("themeMode", themeMode.index.toString());
    theme = themeMode;
    notifyListeners();
  }
}


class ThemePack {
  static final dark = ThemeData(
    useMaterial3: true,
    // scaffoldBackgroundColor: Colors.grey[1000],
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white),
      labelMedium: TextStyle(color: Colors.white),
      labelLarge: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isCollapsed: true,
      fillColor: const Color.fromRGBO(44, 44, 46, 1),
      contentPadding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      hintStyle: const TextStyle(fontSize: 18),
      labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.grey, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade800 
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark, // The overall brightness of this color scheme.
      background: Colors.black, // A color that typically appears behind scrollable content.
      primary: Colors.white, // The color displayed most frequently across your app’s screens and components. (Floating button)
      onPrimary: Colors.white, // A color that's clearly legible when drawn on primary. (App bar)
      onBackground: Colors.white,
      surface: Colors.green, // Status bar
      onSurface: Colors.white, // Icons color
      error: Colors.grey.shade300, 
      onError: Colors.grey.shade300,
      secondary: Colors.green, 
      onSecondary: Colors.green,
      primaryContainer: const Color.fromRGBO(28, 28, 30, 1)
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      tileColor: const Color.fromRGBO(28, 28, 30, 1),
      shape: RoundedRectangleBorder( //<-- SEE HERE
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 18),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)
      )
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        )
      )
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) => 
        states.contains(MaterialState.disabled) ? Colors.grey.shade100 : Colors.white),
      trackColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.selected) ? Colors.green : Colors.grey))
  );

  static final light = ThemeData(
    useMaterial3: true,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: const Color.fromRGBO(242, 242, 247, 1),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Colors.black),
      labelMedium: TextStyle(color: Colors.black),
      labelLarge: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      isCollapsed: true,
      fillColor: const Color.fromRGBO(227, 227, 233, 1),
      hintStyle: const TextStyle(color: Colors.grey,fontSize: 18),
      labelStyle: const TextStyle(color: Colors.black, fontSize: 18),
      contentPadding: const EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade200 
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark, // The overall brightness of this color scheme.
      background: Color.fromRGBO(242, 242, 247, 1), // A color that typically appears behind scrollable content.
      primary: Colors.black, // The color displayed most frequently across your app’s screens and components. (Floating button)
      onPrimary: Colors.black, // A color that's clearly legible when drawn on primary. (App bar)
      onBackground: Colors.black,
      surface: Colors.green, // Status bar
      onSurface: Colors.black, // Icons color
      error: Color.fromRGBO(242, 242, 247, 1), 
      onError: Color.fromRGBO(242, 242, 247, 1), 
      secondary: Colors.green, 
      onSecondary: Colors.green,
      primaryContainer: Colors.white
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.black,
      tileColor: Colors.white,
      shape: RoundedRectangleBorder( //<-- SEE HERE
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 18),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)
      )
    ),
    iconTheme: const IconThemeData(
      color: Colors.black
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 10)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
        )
      )
    ),
    switchTheme: SwitchThemeData(
      // thumbColor: MaterialStateProperty.all(primary),
      trackColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? Colors.green : Colors.grey)
    )
  );
}