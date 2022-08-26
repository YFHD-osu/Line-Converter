import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_message_converter/main.dart';
import '../stringPorcesser.dart';
import 'informationDialog.dart';
import '../dataManager.dart';

var morningPersonTextBoxController = TextEditingController();
var morningCarTextBoxController = TextEditingController();

class ProgressBarControllerClass {
  double height;
  String lore;

  ProgressBarControllerClass(this.height, this.lore){
    height = height;
    lore = lore;
  }
}

var progressBarController = ProgressBarControllerClass(40, "");

class MorningPersonTextBox extends StatefulWidget {
  const MorningPersonTextBox({Key? key}) : super(key: key);

  @override
  State<MorningPersonTextBox> createState() => _MorningPersonTextBoxState();
}

class _MorningPersonTextBoxState extends State<MorningPersonTextBox> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height/2 -120,
          child: TextField(
            controller: morningPersonTextBoxController,
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "輸入車次、人名等訊息串",
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
            ),
          ),
        ),

        Positioned(
          right: 20,
          bottom: 15,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              morningPersonTextBoxController.text = value!.text ?? ' ';
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

class MorningCarTextBox extends StatefulWidget {
  const MorningCarTextBox({Key? key}) : super(key: key,);

  @override
  State<MorningCarTextBox> createState() => _MorningCarTextBoxState();
}

class _MorningCarTextBoxState extends State<MorningCarTextBox> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          height: MediaQuery.of(context).size.height/2 -120,
          child: TextField(
            controller: morningCarTextBoxController,
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "輸入車次、車號等訊息串",
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              filled: true,
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 15,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              morningCarTextBoxController.text = value!.text ?? ' ';
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

class MorningParserPage extends StatefulWidget {

  const MorningParserPage({Key? key ,required this.errorBoxController}) : super(key: key,);

  final ErrorBoxControllerObject errorBoxController;

  @override
  State<MorningParserPage> createState() => _MorningParserPageState();
}

class _MorningParserPageState extends State<MorningParserPage> {

  double testValue = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){FocusScope.of(context).unfocus();},
      child: SingleChildScrollView(
          child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).viewPadding.top,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: const Center(
                      child: Text('早班車表轉換',
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: 35,
                        ),
                      )
                  ),
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
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(
                    milliseconds: 500,
                  ),
                  height: progressBarController.height,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(progressBarController.lore ,
                              style: TextStyle(
                                  color: Colors.blue[500],
                                  fontSize: 21,
                                  backgroundColor: Colors.blue[50]
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 50,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: Colors.blue[500],
                                    fixedSize: const Size.fromWidth(30)
                                ),
                                child: Text('取消',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15, color: Colors.blue[800]),),
                                  onPressed: () {
                                    setState(() {
                                      testValue += 0.1;

                                      progressBarController.height = 40;
                                    });
                                  },
                              )
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 37, 15, 0),
                            child: LinearProgressIndicator(
                              value: testValue,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                          )

                        ],
                      )
                  )
                ),
                MorningCarTextBox(),
                MorningPersonTextBox(),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 20),
                        primary: Colors.white,
                        backgroundColor: Colors.green[500]
                    ),
                    onPressed: () async {
                      var result = await processStringMorning(morningPersonTextBoxController.text, morningCarTextBoxController.text);
                      setState(() {
                        widget.errorBoxController.height = 0;
                      });
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
                        switch(endCode){
                          case 1:
                            break;
                          case 2:


                        }
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
