import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_message_converter/main.dart';
import '../stringPorcesser.dart';
import 'informationDialog.dart';
import '../dataManager.dart';
import '../gsheet.dart';
import 'processDialog.dart';
import 'package:async/async.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';


var afternoonOrderTextBoxController = TextEditingController();
var afternoonCarTextBoxController =  TextEditingController();

class AfternoonCarTextBox extends StatefulWidget {
  const AfternoonCarTextBox({Key? key}) : super(key: key,);
  @override
  State<AfternoonCarTextBox> createState() => _AfternoonCarTextBoxState();
}

class _AfternoonCarTextBoxState extends State<AfternoonCarTextBox> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: MediaQuery.of(context).size.height/2 -120,
          child: TextField(
            controller: afternoonCarTextBoxController,
            style: const TextStyle(fontSize: 18),
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "輸入車次、人名等訊息串",
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height/2 -120,
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.fromLTRB(0, 0, 17, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              afternoonCarTextBoxController.text = value!.text ?? ' ';
            });
            },
            child: const Text('貼上剪貼簿', style: TextStyle(color: Colors.white, fontSize: 18)
            ),
          ),
        ),
      ],
    );
  }
}

class AfternoonOrderTextBox extends StatefulWidget {
  const AfternoonOrderTextBox({Key? key}) : super(key: key);

  @override
  State<AfternoonOrderTextBox> createState() => _AfternoonOrderTextBoxState();
}

class _AfternoonOrderTextBoxState extends State<AfternoonOrderTextBox> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: MediaQuery.of(context).size.height/2 -120,
          child: TextField(
            controller: afternoonOrderTextBoxController,
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "輸入車次順序訊息串",
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
            ),
          ),
        ),

        Container(
          height: MediaQuery.of(context).size.height/2 -120,
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.fromLTRB(0, 0, 17, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              afternoonOrderTextBoxController.text = value!.text ?? ' ';
            });
            },
            child: const Text('貼上剪貼簿',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )
            ),
          ),
        ),
      ],
    );
  }
}

class AfternoonParserPage extends StatefulWidget {
  const AfternoonParserPage({Key? key ,required this.errorBoxController}) : super(key: key,);

  final ErrorBoxControllerObject errorBoxController;

  @override
  State<AfternoonParserPage> createState() => _AfternoonParserPageState();
}

class _AfternoonParserPageState extends State<AfternoonParserPage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: SingleChildScrollView(
          child: Column(
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
                  child: Text('下午車表轉換', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                )
              ),
              AnimatedContainer(
                curve: Curves.easeInOut,
                duration: const Duration(
                  milliseconds: 500,
                ),
                height: widget.errorBoxController.height,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: widget.errorBoxController.color,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(widget.errorBoxController.errorLore ,
                            style: TextStyle(
                                color: Colors.red[500],
                                fontSize: 21,
                                backgroundColor: Colors.red[50]
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.red[500],
                                  fixedSize: const Size.fromWidth(30)
                              ),
                              child: const Text('\u{274C}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15
                                ),),
                              onPressed: () {
                                setState(() {
                                  widget.errorBoxController.height = 0;
                                });
                              },
                            )
                        ),
                      ],
                    )
                  )
              ),
              AfternoonCarTextBox(),
              AfternoonOrderTextBox(),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.white,
                    backgroundColor: Colors.green[500]
                  ),
                  onPressed: () async {
                    var result = await processStringAfternoon(afternoonCarTextBoxController.text, afternoonOrderTextBoxController.text);
                    setState(() {widget.errorBoxController.height = 0;});
                    if (!mounted) return;
                    if (result.runtimeType == int){
                      setState(() {
                        switch (result){
                          case 1:
                            widget.errorBoxController.errorLore = "兩個訊息欄位都為必填!";
                            widget.errorBoxController.height = 35;
                            break;
                          case 2:
                            widget.errorBoxController.errorLore = "請檢查資訊是否完整或貼反!";
                            widget.errorBoxController.height = 35;
                            break;
                        }
                      });
                    }
                    else{
                      var showDataObject = showDataClass(result, context);
                      var endCode = await showDataObject.showData();

                      /* Code Lore:
                          0 = 啥都不做
                          1 = 上傳船單
                          2 = 儲存到本機
                          3 = 樣樣都來
                       */
                      if (endCode == 0 || endCode == null) {return;}

                      var processDataObject = processDialogClass(context, endCode, result);
                      processDataObject.showProcessDialog();

                    }
                  },
                  child: const Text('開始轉換',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )
                  ),
                ),
              ),
            ]
          )
      ),
    );
  }
}
