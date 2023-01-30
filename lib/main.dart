import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'provider/ThemeProvider.dart';
import 'Page/SettingsPage.dart';
import 'Page/JoinPage.dart';
import 'Page/DataPage.dart';

class ErrorBoxControllerObject {
  double height ;
  String errorLore;
  Color color;
  ErrorBoxControllerObject (this.height, this.errorLore, this.color);
}

PageController pageController = PageController(initialPage: 0,);
ErrorBoxControllerObject errorBoxController = ErrorBoxControllerObject(0, "", Colors.red.shade50);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs.getInt('themeMode') ?? 0, ));
}

class MyApp extends StatelessWidget {
  int themeCode;
  MyApp(this.themeCode, {Key? key}) : super(key: key){
    themeCode = themeCode;
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(themeCode),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      return MaterialApp(
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQueryData.copyWith(textScaleFactor: 1),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: ThemeDatas.lightTheme,
        darkTheme: ThemeDatas.darkTheme,
        home: const App(),
      );
    },
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0; //Set initially page to 0

  BoxDecoration activeDecoration = BoxDecoration(
    color: Colors.green[200],
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(15))
  ); //Active BottomNavigationBarItem style

  List<Widget> widgetOptions = <Widget>[
    JoinPage(errorBoxController: errorBoxController),
    const DataPage(),
    const SettingPage(),
  ]; //All page in NavigationBar

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  } //Handle tap item event

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: Center(child: widgetOptions.elementAt(_selectedIndex)),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const SizedBox(child: Icon(Icons.add)),
                label: '加入',
                activeIcon: Container(
                  width: 50,
                  height: 26,
                  decoration: activeDecoration,
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.checklist_outlined),
                label: '顯示',
                activeIcon: Container(
                  width: 50,
                  height: 26,
                  decoration: activeDecoration,
                  child: const Icon(
                    Icons.checklist_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: '設定',
                activeIcon: Container(
                  width: 50,
                  height: 26,
                  decoration: activeDecoration,
                  child: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green[800],
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        )
      )
    );
  }
}