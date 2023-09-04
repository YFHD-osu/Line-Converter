import 'package:flutter/material.dart';

class Titlebar extends StatelessWidget {
  const Titlebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Center(child: Text('上傳設定', style: Theme.of(context).textTheme.titleLarge))
          )
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 16, 0, 10),
          child: Material(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            color: Theme.of(context).inputDecorationTheme.fillColor,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded)
            ),
          )
        )
      ]
    );
  }
}