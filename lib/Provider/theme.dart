import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode theme = ThemeMode.system;
  
  Future<ThemeMode> fetch() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int index = prefs.getInt('themeMode') ?? 0;
    theme = ThemeMode.values[index];
    return theme;
  }

  Future<void> toggle(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', themeMode.index);
    theme = themeMode;
    notifyListeners();
  }
}

class ThemePack {
  static final dark = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.grey[1000],
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
      labelSmall: TextStyle(color: Colors.white, fontSize: 15.0, height: 0),
      labelMedium: TextStyle(color: Colors.white, fontSize: 20.0, height: 0),
      labelLarge: TextStyle(color: Colors.white, fontSize: 25.0, height: 0),
      titleLarge: TextStyle(color: Colors.white, fontSize: 40.0, height: 0),
      titleMedium: TextStyle(color: Colors.white, fontSize: 30, height: 0),
      titleSmall: TextStyle(color: Colors.white, fontSize: 25, height: 0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey.shade800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.grey.shade800 
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.dark, // The overall brightness of this color scheme.
      background: Colors.grey.shade900, // A color that typically appears behind scrollable content.
      primary: Colors.white, // The color displayed most frequently across your app’s screens and components. (Floating button)
      onPrimary: Colors.white, // A color that's clearly legible when drawn on primary. (App bar)
      onBackground: Colors.white,
      surface: Colors.green, // Status bar
      onSurface: Colors.white, // Icons color
      error: Colors.grey.shade300, 
      onError: Colors.grey.shade300, 
      secondary: Colors.green, 
      onSecondary: Colors.green
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      tileColor: Colors.grey.shade800,
      selectedTileColor: Colors.grey.shade800,
      selectedColor: Colors.grey.shade800,
      shape: RoundedRectangleBorder( //<-- SEE HERE
        borderRadius: BorderRadius.circular(10)
      )
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(fontSize: 18),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)
      )
    )
    
  );

  static final light = ThemeData(
    useMaterial3: true,
    backgroundColor: Colors.grey[50],
    scaffoldBackgroundColor: Colors.grey[200],
    brightness: Brightness.light,
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(color: Colors.black, fontSize: 15.0),
      labelMedium: TextStyle(color: Colors.black, fontSize: 20.0),
      labelLarge: TextStyle(color: Colors.black, fontSize: 25.0),
      titleLarge: TextStyle(color: Colors.black, fontSize: 40.0),
      titleMedium: TextStyle(color: Colors.black, fontSize: 30),
      titleSmall: TextStyle(color: Colors.black, fontSize: 25),
    ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
      )
    ),

    colorScheme: const ColorScheme.light(),
    
  );

}