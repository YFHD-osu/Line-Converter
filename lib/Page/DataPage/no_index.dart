import 'package:flutter/material.dart';

class NoIndex extends StatelessWidget {
  const NoIndex({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); 
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.size.height - 190,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inbox_rounded, size: 300),
          Text('尚無資料')
        ]
      )
    );
  }
}