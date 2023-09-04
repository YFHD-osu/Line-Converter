import 'package:flutter/material.dart';

class PassengerList extends StatefulWidget {
  const PassengerList({super.key, 
    required this.data, 
    required this.headingText,
    required this.highlight,
    required this.show
  });
  final bool show;
  final String highlight;
  final List<String>? data;
  final String headingText;

  @override
  State<PassengerList> createState() => _PassengerListState();
}

class _PassengerListState extends State<PassengerList> {
  Container getTextContainer(String text) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(' $text ', style: TextStyle(
        color: widget.highlight.contains(text) ? Colors.green[500] : theme.textTheme.labelLarge?.color,
        fontSize: theme.textTheme.labelLarge?.fontSize)
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    if (widget.data == null) return Container();
    if (widget.data!.isEmpty) return Container();
    if (!widget.show) return Container();
    
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row( //Generate passengers name in every container
        mainAxisSize: MainAxisSize.max,
        children: [
          getTextContainer(widget.headingText),
          const SizedBox(width: 5),
          Container(
            height: 38,
            width: mediaQuery.size.width - 75,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.data!.length,
              itemBuilder: (context, index) => getTextContainer(widget.data![index]),
              separatorBuilder: (context, index) => const SizedBox(width: 5),
            )
          )
        ]
      )
    );
  }
}