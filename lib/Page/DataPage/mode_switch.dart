import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum ShowType {morning, evening}

const Map<ShowType, Color> skyColors = <ShowType, Color>{
  ShowType.morning: Colors.green,
  ShowType.evening: Colors.green
};

class ModeSwitch extends StatefulWidget {
  const ModeSwitch({
    super.key, 
    required this.onChange,
    this.initValue
  });

  final ShowType? initValue; 

  @override
  State<ModeSwitch> createState() => ModeSwitchState();

  final VoidCallback? onChange;
}

class ModeSwitchState extends State<ModeSwitch> {
  late ShowType selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initValue ?? ShowType.morning;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: CupertinoSlidingSegmentedControl<ShowType>(
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
        },
      )
    );
  }
}