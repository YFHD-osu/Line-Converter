import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier {
  int darkMode;
  var themeMode;

  ThemeProvider (this.darkMode) {
    List<ThemeMode> tMs = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    themeMode = tMs[darkMode];
  }

  Future<void> toggleTheme(int themeCode) async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch(themeCode){
      case 0:
        themeMode = ThemeMode.system;
        await prefs.setInt('themeMode', 0);
        break;
      case 1:
        themeMode = ThemeMode.light;
        await prefs.setInt('themeMode', 1);
        break;
      case 2 :
        themeMode = ThemeMode.dark;
        await prefs.setInt('themeMode', 2);
        break;
    }
    // themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class ThemeDatas {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
      labelSmall: TextStyle(color: Colors.white, fontSize: 15.0),
      labelMedium: TextStyle(color: Colors.white, fontSize: 20.0),
      labelLarge: TextStyle(color: Colors.white, fontSize: 25.0),
      titleLarge: TextStyle(color: Colors.white, fontSize: 40.0),
      titleMedium: TextStyle(color: Colors.white, fontSize: 30),
      titleSmall: TextStyle(color: Colors.white, fontSize: 25),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.green),
        )
      ),

    colorScheme: const ColorScheme.dark(),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
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
    useMaterial3: true,
  );

}