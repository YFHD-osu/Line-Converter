import 'package:flutter/material.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({super.key, 
    required this.title,
    required this.onTap,
  });
  final String title;
  final VoidCallback onTap;

  @override
  State<ControlButton> createState() => ControlButtonState();
}

class ControlButtonState extends State<ControlButton> {
  bool isOn = true; 

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close, color: Colors.white,);
    },
  );

  final MaterialStateProperty<MaterialColor?> switchBorder = 
      MaterialStateProperty.resolveWith(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const MaterialColor(0xFFFFFFFF, {});
      }
      return const MaterialColor(0xFFF, {});
    },
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(10,5,10,5),
      child: Row(
        children: [
          Switch(
            // This bool value toggles the switch.
            value: isOn,
            thumbIcon: thumbIcon,
            trackOutlineColor: switchBorder,
            activeColor: const Color.fromRGBO(56, 142, 60, 1),
            activeTrackColor: Colors.green.shade300,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            onChanged: (bool value) async {
              setState(() => isOn = value);
              widget.onTap.call();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 3.5),
            child: Text(widget.title, style: theme.textTheme.labelLarge!)
          )
        ],
      )
    );
  }
}