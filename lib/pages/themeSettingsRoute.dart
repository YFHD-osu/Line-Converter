import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_line_message_converter/provider/themeProvider.dart';

bool _darkModeCheckBox = false;
bool _lightModeCheckBox = false;
bool _useSystemThemeCheckBox = false;

class ThemeSettingsRoute extends StatefulWidget {
  const ThemeSettingsRoute({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsRoute> createState() => _ThemeSettingsRouteState();
}

class _ThemeSettingsRouteState extends State<ThemeSettingsRoute> {

  @override
  void setCheckBox(int themeCode){
    setState(() {
      switch(themeCode){
        case 0:
          _useSystemThemeCheckBox = true;
          _lightModeCheckBox = false;
          _darkModeCheckBox = false;
          break;
        case 1:
          _useSystemThemeCheckBox = false;
          _lightModeCheckBox = true;
          _darkModeCheckBox = false;
          break;
        case 2:
          _useSystemThemeCheckBox = false;
          _lightModeCheckBox = false;
          _darkModeCheckBox = true;
          break;
        default:
          _useSystemThemeCheckBox = true;
          _lightModeCheckBox = false;
          _darkModeCheckBox = false;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print(prefs.getInt('themeMode'));
      if (prefs.getInt('themeMode') == null){setCheckBox(0);}
      else{setCheckBox(prefs.getInt('themeMode')!);}
    });
  }

  @override
  void setTheme(int themeCode){
    final provider = Provider.of<ThemeProvider>(context, listen: false);
    provider.toggleTheme(themeCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0
      ),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Center(child: Text('佈景主題', style: Theme.of(context).textTheme.titleLarge),)
                    )
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 16, 0, 10),
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_rounded)
                      ),
                    )
                )
              ],
            ),
            Column(
              children: [
                Stack(
                  children: [
                    Container( // 佈景主題按鈕
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 60,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              setCheckBox(0);
                              setTheme(0);
                            },
                            icon: const Icon(Icons.phone_android, size: 32,),
                            label: Text(' 跟隨系統的主題', style: Theme.of(context).textTheme.labelMedium),
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: Theme.of(context).inputDecorationTheme.fillColor,
                              primary: Theme.of(context).inputDecorationTheme.fillColor,
                              onPrimary : Theme.of(context).primaryColor,
                              alignment: Alignment.centerLeft,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)
                              ),
                            )
                        )
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.fromLTRB(0, 13, 15, 0),
                      child: Checkbox(
                        value: _useSystemThemeCheckBox,
                        onChanged: (value) {
                          setCheckBox(0);
                          setTheme(0);
                        },
                        activeColor: Colors.green,
                      ),
                    )
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.width/2 + 30)*11/8,
                      width: MediaQuery.of(context).size.width - 20,
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 15, 5, 10),
                          child: Material(
                            elevation: 8,
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                            borderRadius: BorderRadius.circular(15),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                                onTap: () {
                                  setCheckBox(2);
                                  setTheme(2);
                                },
                                child: Column(
                                  children: [
                                    Ink.image(
                                      image: const AssetImage('assets/darkThemeSample.png'),
                                      height: (MediaQuery.of(context).size.width/2 - 25)*11/8,
                                      width: MediaQuery.of(context).size.width/2 - 25,
                                      fit: BoxFit.fill,
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width/2 - 45,
                                          child: Checkbox(value: _darkModeCheckBox,
                                              checkColor: Colors.white,
                                              activeColor: Colors.green[500],
                                              onChanged: (value) {
                                                setCheckBox(2);
                                                setTheme(2);
                                              }
                                          ),
                                        ),
                                        const Positioned(top: 9, left: 50, child: Text('深色模式', style: TextStyle(fontSize: 20)))
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(5, 15, 20, 10),
                          child: Material(
                            elevation: 8,
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                            borderRadius: BorderRadius.circular(15),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                                onTap: () {
                                  setCheckBox(1);
                                  setTheme(1);
                                },
                                child: Column(
                                  children: [
                                    Ink.image(
                                      image: const AssetImage('assets/lightThemeSample.png'),
                                      height: (MediaQuery.of(context).size.width/2 - 25)*11/8,
                                      width: MediaQuery.of(context).size.width/2 - 25,
                                      fit: BoxFit.fill
                                    ),
                                    const SizedBox(height: 5),
                                    Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width/2 - 45,
                                          child: Checkbox(value: _lightModeCheckBox,
                                              checkColor: Colors.white,
                                              activeColor: Colors.green[500],
                                              onChanged: (value) {
                                                setCheckBox(1);
                                                setTheme(1);
                                              }
                                          ),
                                        ),
                                        const Positioned(top: 9, left: 50, child: Text('淺色模式', style: TextStyle(fontSize: 20)))
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// @override
// void setCheckBox(int themeCode){
//   setState(() {
//     switch(themeCode){
//       case 0:
//         print('object');
//         _useSystemThemeCheckBox = true;
//         _lightModeCheckBox = false;
//         _darkModeCheckBox = false;
//         break;
//       case 1:
//         _useSystemThemeCheckBox = false;
//         _lightModeCheckBox = true;
//         _darkModeCheckBox = false;
//         break;
//       case 2:
//         _useSystemThemeCheckBox = false;
//         _lightModeCheckBox = false;
//         _darkModeCheckBox = true;
//         break;
//       default:
//         _useSystemThemeCheckBox = true;
//         _lightModeCheckBox = false;
//         _darkModeCheckBox = false;
//         break;
//     }
//   });
// }


