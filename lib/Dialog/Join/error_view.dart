import 'package:flutter/material.dart';
import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Dialog/Join/top_button_view.dart';

Widget error(BuildContext context, List<ParseException> errors) { 
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopButtonRow(
          cancel: () => Navigator.of(context).pop(),
          confirm: null,
          context: context,
          title: '轉換時發生錯誤'
        ),
        SizedBox(
          width: mediaQuery.size.width,
          child: Row(
            children: [
              const Icon(Icons.error, size: 100),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(text: '轉換過程中發生以下錯誤\n', style: TextStyle(fontSize: 30)),
                    TextSpan(text: '請依提示訊息修正後再重新轉換', style: TextStyle(fontSize: 20)),
                  ]
                )
              )
            ],
          )
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: errors.map((ParseException index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 5, right: 5),
                      leading: FlutterLogo(),
                      title: Text(index.message),
                      subtitle: Text(index.description)
                    )
                  )
                );
              }).toList()
            )
          )
        )
      ]
    );
  }