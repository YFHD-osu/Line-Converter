import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:line_converter/Page/DataPage/mode_switch.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key,
    required this.heroTag,
    required this.showType
  });
  final String heroTag;
  final ShowType showType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 60, width: double.infinity,
      margin: const EdgeInsets.fromLTRB(10,10,10,0),
      child: Hero(
        tag: heroTag,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Ink.image(
                  height: 60,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width - 20,
                  image: showType == ShowType.morning ? 
                    const AssetImage('assets/img_breakfast.jpg'):
                    const AssetImage('assets/img_cyclingbmx.jpg'),
                )
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_rounded)
              ),
              Center(child: Text('詳細資訊', style: theme.textTheme.titleLarge))
            ],
          )
        )
      )
    );
  }
}