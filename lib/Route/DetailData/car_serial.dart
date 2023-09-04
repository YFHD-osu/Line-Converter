import 'package:flutter/material.dart';

class CarSerial extends StatelessWidget {
  const CarSerial({super.key, required this.serial, required this.icon});
  final int? serial;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (serial == null) return Container();
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 25),
          const SizedBox(width: 3),
          Text('$serial', style: theme.textTheme.labelLarge)
        ]
      )
    );
  }
}