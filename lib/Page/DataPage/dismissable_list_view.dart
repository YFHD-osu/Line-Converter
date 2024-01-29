import 'package:flutter/material.dart';
import 'package:line_converter/page/DataPage/title_tile.dart';
import 'package:line_converter/page/DataPage/mode_switch.dart';

class DismissableListView extends StatefulWidget {
  DismissableListView({super.key, 
    required this.items, 
    required this.showType,
    this.onDismissed 
  });

  final ShowType showType;
  final VoidCallback? onDismissed;
  List<Map<String, Object?>> items;

  @override
  State<DismissableListView> createState() => _DismissableListViewState();
}

class _DismissableListViewState extends State<DismissableListView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  void update() {
    for (int i=0; i<widget.items.length ; i++) {
      listKey.currentState?.insertItem(0, duration: const Duration(milliseconds:100));
    }
  }

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (listKey.currentState?.widget.initialItemCount == 0) update();

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      alignment: Alignment.bottomCenter,
      child: Material(
        color: theme.scaffoldBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedList(
          key: listKey,
          initialItemCount: widget.items.length,
          itemBuilder: (_, index, animation) => TitleTile(
            listKey: listKey, onDismissed: widget.onDismissed,
            index: index, items: widget.items, showType: widget.showType
          )
        )
      )
    );
  }
}

