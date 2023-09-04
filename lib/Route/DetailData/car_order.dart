import 'package:flutter/material.dart';

class CarOrder extends StatelessWidget {
  const CarOrder({super.key, required this.order});
  final int order;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 7, 3),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_taxi_outlined, size: 27),
          const SizedBox(width: 3),
          Text('$order', style: theme.textTheme.labelLarge!.copyWith(height: 0))
        ]
      )
    );
  }
}