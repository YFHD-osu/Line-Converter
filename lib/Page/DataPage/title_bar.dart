import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 0))
    );
  }
}