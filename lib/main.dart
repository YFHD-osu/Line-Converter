import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_line_message_converter/Pages/afternoonPage.dart';
import 'provider/themeProvider.dart';
import 'Pages/settingsPage.dart';
import 'Pages/morningPage.dart';
import 'Pages/afternoonPage.dart';

var pageController = PageController(
  initialPage: 0,
);

class ErrorBoxControllerObject {
  double height ;
  String errorLore;
  Color color;
  ErrorBoxControllerObject (this.height, this.errorLore, this.color);
}

var morningErrorBoxController = ErrorBoxControllerObject(0, "", Colors.red.shade50);
var afternoonErrorBoxController = ErrorBoxControllerObject(0, "", Colors.red.shade50);

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

      return MaterialApp(
        themeMode: themeProvider.themeMode,
        theme: ThemeDatas.lightTheme,
        darkTheme: ThemeDatas.darkTheme,
        home: App(),
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
  var activeDecoration = BoxDecoration(
    color: Colors.green[200],
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.all(Radius.circular(15))
  );

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    PageView(
      onPageChanged: (index) {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
      controller: pageController,

      children: [
        MorningParserPage(errorBoxController: morningErrorBoxController),
        AfternoonParserPage(errorBoxController: afternoonErrorBoxController),
      ],
    ),
    Text('data'),
    SettingPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.add),
            label: '加入',
            activeIcon: Container(
              width: 50,
              height: 30,
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
              height: 30,
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
              height: 30,
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
    );
  }
}


/*
class CustomRoundedTileButton extends StatelessWidget {
  const CustomRoundedTileButton({Key? key, this.onTap, required this.icon, required this.label, this.endWidget}) : super(key: key);

  final void Function()? onTap;
  final IconData icon;
  final String label;
  final Widget? endWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(900),
          child: Card(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(900)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 16),
                    Center(
                      child: Text(
                        label,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (endWidget != null) endWidget!
                  ],
                ),
              )
          ),
        )
    );
  }
}
*/





