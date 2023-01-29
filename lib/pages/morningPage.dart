import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_message_converter/main.dart';
import '../stringPorcesser.dart';
import 'informationDialog.dart';
import 'processDialog.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

var morningPersonTextBoxController = TextEditingController();
var morningCarTextBoxController = TextEditingController();
ScrollController childScrollController = ScrollController();
double carTextBoxHeight = 0.0;
double personTextBoxHeight = 0.0;
bool carTextExitVisibile = false;
bool personTextExitVisibile = false;

class MorningCarTextBox extends StatefulWidget {
  const MorningCarTextBox({Key? key}) : super(key: key,);
  @override
  State<MorningCarTextBox> createState() => _MorningCarTextBoxState();

}

//Upper text box
class _MorningCarTextBoxState extends State<MorningCarTextBox> {

  @override
  Widget build(BuildContext context,) {
    carTextBoxHeight = carTextBoxHeight == 0 ? MediaQuery.of(context).size.height/2-170 : carTextBoxHeight;
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: carTextBoxHeight,
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            height: carTextBoxHeight,
            child: TextField(
              controller: morningCarTextBoxController,
              style: const TextStyle(
                fontSize: 18,
              ),
              maxLines: 999,
              decoration: InputDecoration(
                hintText: "輸入車次、車號等訊息串",
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                )
              ),
              onTap: () async {
                carTextExitVisibile = true;
                Future<void> changeHeight () async {
                  double lastHeight = MediaQuery.of(context).viewInsets.bottom;
                  while(true){
                    await Future.delayed(const Duration(milliseconds: 50));
                    print("$lastHeight -> ${MediaQuery.of(context).viewInsets.bottom}");
                    if (lastHeight == MediaQuery.of(context).viewInsets.bottom && lastHeight > 50.0) {return;}
                    lastHeight = MediaQuery.of(context).viewInsets.bottom;
                    setState(() {
                      carTextBoxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - 40;
                      Future.delayed(const Duration(milliseconds: 100)).then((value) => childScrollController.animateTo(70, duration: const Duration(milliseconds: 100), curve: Curves.ease));
                    });
                  }
                }
                changeHeight();

              },
              onEditingComplete: () {
                carTextExitVisibile = false;
                setState(() {});
              }
            )
          )
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(
            milliseconds: 99,
          ),
          alignment: Alignment.bottomRight,
          height: carTextBoxHeight,
          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IgnorePointer(
                ignoring: !carTextExitVisibile,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: carTextExitVisibile ? 1.0 : 0.0,
                  curve: Curves.linear,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[500],
                    ),
                    onPressed: () { //Disfocus keyboard
                      FocusScope.of(context).unfocus();
                      carTextExitVisibile = false;
                      carTextBoxHeight = MediaQuery.of(context).size.height/2-170;
                      setState(() {});
                    },
                    child: const Icon(Icons.transit_enterexit_rounded)
                  )
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[500],
                ),
                onPressed: () { //Get clipboard data
                  Clipboard.getData(Clipboard.kTextPlain).then((value){
                    morningCarTextBoxController.text = value!.text ?? '';
                  }
                  );
                },
                child: const Icon(Icons.paste_outlined)
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[500],
                ),
                onPressed: () { //Get clipboard data
                  morningCarTextBoxController.text = '';
                },
                child: const Icon(Icons.delete_sweep_sharp, size: 24)
              ),
            ]
          )
        )
      ],
    );
  }
}

class MorningPersonTextBox extends StatefulWidget {
  const MorningPersonTextBox({Key? key}) : super(key: key);
  @override
  State<MorningPersonTextBox> createState() => _MorningPersonTextBoxState();
}

//Lower text box
class _MorningPersonTextBoxState extends State<MorningPersonTextBox> {

  @override
  Widget build(BuildContext context) {
    personTextBoxHeight = personTextBoxHeight == 0 ? MediaQuery.of(context).size.height/2-170 : personTextBoxHeight;
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: personTextBoxHeight,
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            height: personTextBoxHeight,
            child: TextField(
              controller: morningPersonTextBoxController,
              style: const TextStyle(
                fontSize: 18,
              ),
              maxLines: 999,
              decoration: InputDecoration(
                  hintText: "輸入人名、車號等訊息串",
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  )
              ),
              onTap: () async {
                personTextExitVisibile = true;
                Future<void> changeHeight () async {
                  double lastHeight = MediaQuery.of(context).viewInsets.bottom;
                  while(true){
                    await Future.delayed(const Duration(milliseconds: 50));
                    print("$lastHeight -> ${MediaQuery.of(context).viewInsets.bottom}");
                    if (lastHeight == MediaQuery.of(context).viewInsets.bottom && lastHeight > 50.0) {return;}
                    lastHeight = MediaQuery.of(context).viewInsets.bottom;
                    setState(() {
                      personTextBoxHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - 40;
                      Future.delayed(const Duration(milliseconds: 100)).then((value) => childScrollController.animateTo(400, duration: const Duration(milliseconds: 100), curve: Curves.ease));
                      print(personTextBoxHeight);
                    });
                  }
                }
                changeHeight();

              },
              onEditingComplete: () {
                personTextExitVisibile = false;
                setState(() {});
              }
            )
          )
        ),
        AnimatedContainer(
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 99),
          alignment: Alignment.bottomRight,
          height: personTextBoxHeight,
          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IgnorePointer(
                ignoring: !personTextExitVisibile,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: personTextExitVisibile ? 1.0 : 0.0,
                  curve: Curves.linear,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[500],
                    ),
                    onPressed: () { //Disfocus keyboard
                      FocusScope.of(context).unfocus();
                      personTextExitVisibile = false;
                      personTextBoxHeight = MediaQuery.of(context).size.height/2-170;
                      setState(() {});
                    },
                    child: const Icon(Icons.transit_enterexit_rounded)
                  )
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[500],
                ),
                onPressed: () { //Get clipboard data
                  Clipboard.getData(Clipboard.kTextPlain).then((value){
                    morningPersonTextBoxController.text = value!.text ?? '';
                  }
                  );
                },
                child: const Icon(Icons.paste_outlined)
              ),
              const SizedBox(width: 10),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red[500],
                ),
                onPressed: () { //Get clipboard data
                  morningPersonTextBoxController.text = '';
                },
                child: const Icon(Icons.delete_sweep_sharp, size: 24)
              ),
            ]
          )
        )
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

class _MorningParserPageState extends State<MorningParserPage> with WidgetsBindingObserver{

  // disfocous keyboard on app is in background
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: carTextExitVisibile ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics() ,
      controller: childScrollController,
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
              child: Text('早上車表轉換', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            )
          ),
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(
              milliseconds: 500,
            ),
            height: widget.errorBoxController.height,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: widget.errorBoxController.color,
                borderRadius: const BorderRadius.all(Radius.circular(15))
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
                          foregroundColor: Colors.red[500],
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
          const MorningCarTextBox(),
          const MorningPersonTextBox(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 5, 20, personTextExitVisibile ? personTextBoxHeight : 0),
            child: TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[500],
                  minimumSize: const Size(700, 50)
              ),
              onPressed: () async {
                var result = await processStringMorning(morningPersonTextBoxController.text, morningCarTextBoxController.text);
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
                    fontSize: 20,
                  )
              ),
            ),
          ),
        ]
      )
    );
  }
}
