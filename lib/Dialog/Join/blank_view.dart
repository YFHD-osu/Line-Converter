import 'package:flutter/material.dart';
import 'package:line_converter/Dialog/Join/top_button_view.dart';

Widget empty(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      TopButtonRow(
        cancel: () => Navigator.of(context).pop(),
        confirm: null,
        context: context,
        title: '轉換失敗'
      ),
      const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.all_inbox_outlined, size: 300),
              Text('空空如也'),
              Text('未發現任何可轉換的訊息')
            ]
          )
        )
      )
    ]
  );
}