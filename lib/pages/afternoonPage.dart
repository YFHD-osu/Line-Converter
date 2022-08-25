import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_message_converter/main.dart';
import '../stringPorcesser.dart';

var afternoonPersonTextBoxController = TextEditingController();
var afternoonCarTextBoxController = TextEditingController();

class AfternoonPersonTextBox extends StatefulWidget {
  const AfternoonPersonTextBox({Key? key}) : super(key: key);

  @override
  State<AfternoonPersonTextBox> createState() => _AfternoonPersonTextBoxState();
}

class _AfternoonPersonTextBoxState extends State<AfternoonPersonTextBox> {
  /*
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    widget.afternoonPersonTextBoxController!.dispose();
    super.dispose();
  }
   */

  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            height: 10 * 24.0,
            child: TextField(
              controller: afternoonPersonTextBoxController,
              style: TextStyle(
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

        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.fromLTRB(0, 200, 20, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              afternoonPersonTextBoxController.text = value!.text ?? ' ';
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

class AfternoonCarTextBox extends StatefulWidget {
  const AfternoonCarTextBox({Key? key}) : super(key: key,);

  @override
  State<AfternoonCarTextBox> createState() => _AfternoonCarTextBoxState();
}

class _AfternoonCarTextBoxState extends State<AfternoonCarTextBox> {
  /*
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    widget.afternoonCarTextBoxController!.dispose();
    super.dispose();
  }
   */

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(12),
          height: 10 * 24.0,
          child: TextField(
            controller: afternoonCarTextBoxController,
            style: TextStyle(
              fontSize: 18,
            ),
            maxLines: 10,
            decoration: InputDecoration(
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              hintText: "輸入車次、車號等訊息串",
              filled: true,
            ),
          ),
        ),

        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.fromLTRB(0, 200, 20, 0),
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              primary: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: () {Clipboard.getData(Clipboard.kTextPlain).then((value){
              afternoonCarTextBoxController.text = value?.text ?? ' ';
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
  const AfternoonParserPage({Key? key , required this.errorBoxController}) : super(key: key,);

  final ErrorBoxControllerObject errorBoxController;

  @override
  State<AfternoonParserPage> createState() => _AfternoonParserPageState();
}

class _AfternoonParserPageState extends State<AfternoonParserPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              child: Text(''),
              height: MediaQuery.of(context).viewPadding.top,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
              child: Center(
                  child: Text('晚班車表轉換',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontSize: 35,
                    ),
                  )
              ),
            ),

            AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(
                  milliseconds: 500,
                ),
                height: widget.errorBoxController.height,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.all(Radius.circular(20))
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
                              child: Text('\u{274C}',
                                textAlign: TextAlign.center,),
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
            AfternoonPersonTextBox(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextButton(
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                    primary: Colors.white,
                    backgroundColor: Colors.green[500]
                ),
                onPressed: () async {
                  var result = await processStringAfternoon(afternoonPersonTextBoxController.text, afternoonCarTextBoxController.text);
                  setState(() {
                    widget.errorBoxController.height = 0;
                  });
                  if (!mounted) return;
                  if (result.runtimeType == int){
                    if (result == 1){
                      setState(() {
                        widget.errorBoxController.errorLore = "兩個訊息欄位都為必填!";
                        widget.errorBoxController.height = 35;
                      });
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
          ],
        ),
      ),
    );
  }
}