import 'package:flutter/material.dart';
import 'package:line_converter/Page/JoinPage/join_page.dart';
import 'package:line_converter/Page/DataPage/data_page.dart';
import 'package:line_converter/Page/SettingsPage/settings_page.dart';

class NavigationItem extends BottomNavigationBarItem{
  static BoxDecoration activeDecoration = BoxDecoration(
    color: Colors.green[200],
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(15))
  ); //Active BottomNavigationBarItem style

  NavigationItem({required icon, required super.label}) : 
  super(
    icon: Icon(icon),
    activeIcon: Container(
      width: 50,
      height: 25,
      decoration: activeDecoration,
      child: Icon(icon, color: Colors.black)
    )
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Set initially page to 0
  int _selectedIndex = 0; 

  //Handle tap item event
  void _onItemTapped(int index) => setState(() => _selectedIndex = index); 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: [const JoinPage(), const DataPage(), const SettingPage()].elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 60.0,
          items: <NavigationItem>[
            NavigationItem(label: '加入', icon: Icons.add),
            NavigationItem(label: '顯示', icon: Icons.checklist_outlined),
            NavigationItem(label: '設定', icon: Icons.settings)
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        )
      )
    );
  }
}