import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_converter/page/join.dart';
import 'package:line_converter/page/data_view.dart';
import 'package:line_converter/page/settings.dart';
import 'package:line_converter/core/typing.dart';

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
  Widget _appBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.background,
      backgroundColor: theme.colorScheme.background.withOpacity(0.75),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            height: 40, width: 40,
            clipBehavior: Clip.hardEdge,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red
            ),
            child: Image.asset("assets/logo.png", fit: BoxFit.fitHeight)
          ),
          Text("車表轉換", style: theme.textTheme.titleMedium),
        ]
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => JoinPage()))
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingPage())),
        )
      ],
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(color: Colors.transparent))
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _appBar()
        ),
        body: const SizedBox.expand(
          child: Column(
            children: [
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.all(5),
                child: SizedBox(
                  width: double.infinity,
                  child: ModeSwitch()
                )
              ),
              Expanded(child: DataView())
            ]
          )
        )
      )
    );
  }
}

enum ShowType {morning, evening}

const Map<ShowType, Color> skyColors = <ShowType, Color>{
  ShowType.morning: Colors.green,
  ShowType.evening: Colors.green
};

class ModeSwitch extends StatefulWidget {
  final VoidCallback? onChange;

  const ModeSwitch({super.key, this.onChange});

  @override
  State<ModeSwitch> createState() => ModeSwitchState();
}

class ModeSwitchState extends State<ModeSwitch> {
  ShowType selected = ShowType.morning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CupertinoSlidingSegmentedControl<ShowType>(
      groupValue: selected,
      thumbColor: skyColors[selected]!,
      backgroundColor: theme.inputDecorationTheme.fillColor!,
      onValueChanged: (ShowType? value) {
        if (value != null) {
          setState(() {selected = value;});
          widget.onChange?.call();
        }
      },
      children: const <ShowType, Widget>{
        ShowType.morning: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '早班車', style: TextStyle(color: Colors.white)
          )
        ),
        ShowType.evening: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '晚班車', style: TextStyle(color: Colors.white)
          )
        )
      }
    );
  }
}

class IndexTile extends StatelessWidget {
  final CarData data;
  final List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

  IndexTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            SizedBox(
              height: 100,
              child: Ink.image(
                fit: BoxFit.fitWidth,
                image: const AssetImage('assets/img_breakfast.jpg')
              )
            ),
            Container(
              padding: const EdgeInsets.only(right: 5, left: 5),
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15)
                )
              ),
              child: Text(
                '${data.addTime.year}年${data.addTime.month}月${data.addTime.day}日 (${weekString[data.addTime.weekday]})',
                style: Theme.of(context).textTheme.labelLarge),
            )
          ]
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DataViewPage(data: [])))
      )
    );
  }
}

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<CarData> data = [
    CarData(
      type: MessageType.morning,
      time: Time(),
      order: 1,
      serial: Serial(),
      addTime: DateTime.now(),
      passenger: Passenger(),
      orderList: []
    )
  ];

  Widget _empty() {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.size.height - 190,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inbox_rounded, size: 300),
          Text('尚無資料')
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return _empty();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return IndexTile(data: data[index]);
        }
      )
    );
  }
}