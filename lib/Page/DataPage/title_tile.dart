import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/page/DataPage/mode_switch.dart';

class TitleTile extends StatefulWidget {
  const TitleTile({
    super.key,
    required this.index,
    required this.items,
    required this.listKey,
    required this.showType,
    required this.onDismissed
  });

  final int index;
  final ShowType showType;
  final VoidCallback? onDismissed;
  final List<Map<String, Object?>> items;
  final GlobalKey<AnimatedListState> listKey; 

  @override
  State<TitleTile> createState() => _TitleTileState();
}

class _TitleTileState extends State<TitleTile> {
  @override
  Widget build(BuildContext context) {
    final item = widget.items[widget.index];

    return Hero(
      tag: item['addTime'] as String,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(15),
          child: Dismissible(
            key: Key(item['addTime'] as String),
            onDismissed: (direction) {
              widget.items.removeAt(widget.index);
              if (widget.showType == ShowType.morning) {
                //TODO: dbManager.deleteMorning(item['id']as int);
              } else {
                //TODO: dbManager.deleteEvening(item['id']as int);
              }
              widget.listKey.currentState!.removeItem(widget.index, (_, animation) => const SizedBox());
              widget.onDismissed?.call();
              setState(() {});
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 10),
              child: const Text("刪除", style: TextStyle(fontSize: 24)),
            ),
            direction: DismissDirection.endToStart,
            child: const SizedBox() // IndexTile(data: item, showType: widget.showType)
          )
        )
      )
    );
  }
}