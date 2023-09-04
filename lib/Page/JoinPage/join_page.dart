import 'package:flutter/material.dart';
import 'package:line_converter/Dialog/Join/process_dialog.dart';
import 'package:line_converter/Page/JoinPage/text_box.dart';

final TextBox personTextBox = TextBox(
  tag: 'person',
  hintText: '輸入人名訊息串',
);

final TextBox carTextBox = TextBox(
  tag: 'car',
  hintText: "輸入車號訊息串",
);

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key,);

  
  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          height: 60,
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Text('車表轉換', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
          )
        ),
        personTextBox,
        carTextBox,
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[500],
              minimumSize: const Size(700, 50)
            ),
            child: const Text('執行轉換', style: TextStyle(fontSize: 20)),
            onPressed: () {
              final animationController = AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 200)
              );
              final dialog = DataViewDialog(
                context: context,
                animation: animationController,
                person: personTextBox.controller,
                car: carTextBox.controller
              );
              dialog.parse();
              return;
            }
          ),
        ),
      ]
    );
  }
}