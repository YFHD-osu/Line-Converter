import 'package:flutter_line_message_converter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Library/StringPorcesser.dart';
import '../Dialog/Information.dart';
import '../Dialog/Process.dart';
import 'dart:ui' as ui;

var personTextBoxController = TextEditingController();
var carTextBoxController =  TextEditingController();
ScrollController childScrollController = ScrollController();
double carTextBoxHeight = 0.0;
double personTextBoxHeight = 0.0;
bool carTextExitVisibile = false;
bool personTextExitVisibile = false;
bool isMorningMode = true;

class CarTextBox extends StatefulWidget {
  const CarTextBox({Key? key}) : super(key: key,);

  @override
  State<CarTextBox> createState() => _CarTextBoxState();
}

//Upper text box
class _CarTextBoxState extends State<CarTextBox> {
  final carTextKey = GlobalKey();
  final personTextKey = GlobalKey();

  @override
  Widget build(BuildContext context,) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: carTextExitVisibile ? carTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            height: carTextExitVisibile ? carTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
            child: TextField(
              key: carTextKey,
              enableSuggestions: false,
              controller: carTextBoxController,
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
                errorBoxController.height = 0;
                Future<void> changeHeight () async {
                  double lastHeight = 1.0;
                  bool isFirstStart = true;
                  while(true){
                    await Future.delayed(const Duration(milliseconds: 50));
                    // print("$lastHeight -> ${MediaQuery.of(context).viewInsets.bottom}");
                    if (lastHeight == 0.0 && !(isFirstStart)) {
                      carTextExitVisibile = false;
                      personTextExitVisibile = false;
                      FocusScope.of(context).unfocus();
                      setState(() {});
                      return;
                    }
                    lastHeight = MediaQuery.of(context).viewInsets.bottom;
                    isFirstStart = (lastHeight != 0) ? false : isFirstStart;
                    if (carTextExitVisibile){
                      setState(() {
                        carTextBoxHeight =MediaQuery.of(context).size.height
                          - MediaQuery.of(context).viewInsets.bottom
                          - MediaQueryData.fromWindow(ui.window).padding.bottom
                          - MediaQueryData.fromWindow(ui.window).padding.top
                          - 14;
                        //Scrollable.ensureVisible(carTextKey.currentContext!, duration: const Duration(milliseconds: 80), curve: Curves.easeInOut);
                        Future.delayed(const Duration(milliseconds: 50)).then((value) => childScrollController.animateTo(73, duration: const Duration(milliseconds: 100), curve: Curves.ease));
                      });
                    }else {return;}
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
            milliseconds: 300,
          ),
          alignment: Alignment.bottomRight,
          height: carTextExitVisibile ? carTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
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
                    Clipboard.getData(Clipboard.kTextPlain).then((value){carTextBoxController.text = value!.text ?? '';});
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
                    carTextBoxController.text = '';
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

class PersonTextBox extends StatefulWidget {
  const PersonTextBox({Key? key}) : super(key: key);
  @override
  State<PersonTextBox> createState() => _PersonTextBoxState();
}

//Lower text box
class _PersonTextBoxState extends State<PersonTextBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          height: personTextExitVisibile ? personTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
          curve: Curves.fastOutSlowIn,
          child: SizedBox(
            height: personTextExitVisibile ? personTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
            child: TextField(
              enableSuggestions: false,
              controller: personTextBoxController,
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
                errorBoxController.height = 0;
                Future<void> changeHeight () async {
                  double lastHeight = 1.0;
                  bool isFirstStart = true;
                  double topHeight = (MediaQuery.of(context).size.height-280)/2 + 83;
                  while(true) {
                    await Future.delayed(const Duration(milliseconds: 50));
                    if (lastHeight == 0.0 && !(isFirstStart)) {
                      carTextExitVisibile = false;
                      personTextExitVisibile = false;
                      FocusScope.of(context).unfocus();
                      childScrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.ease);
                      return;
                    }
                    lastHeight = MediaQuery.of(context).viewInsets.bottom;
                    isFirstStart = (lastHeight > 5.0) ? false : isFirstStart;
                    if (personTextExitVisibile) {
                      setState(() {
                        personTextBoxHeight = MediaQuery.of(context).size.height
                          - MediaQuery.of(context).viewInsets.bottom
                          - MediaQueryData.fromWindow(ui.window).padding.bottom
                          - MediaQueryData.fromWindow(ui.window).padding.top
                          - 14;
                        Future.delayed(const Duration(milliseconds: 100)).then((value) =>
                          childScrollController.animateTo(topHeight, duration: const Duration(milliseconds: 100), curve: Curves.ease));
                      });
                    } else {
                      return;
                    }
                  }
                }
                changeHeight().then((value) => setState(() => {
                Future.delayed(const Duration(milliseconds: 50)).then((value) => childScrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.ease))}));

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
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.bottomRight,
            height: personTextExitVisibile ? personTextBoxHeight : (MediaQuery.of(context).size.height-280)/2,
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
                        print(MediaQueryData.fromWindow(ui.window).padding);
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
                      personTextBoxController.text = value!.text ?? '';
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
                      personTextBoxController.text = '';
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

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key ,required this.errorBoxController}) : super(key: key,);
  final ErrorBoxControllerObject errorBoxController;
  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> with WidgetsBindingObserver{
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
    if (isBackground) FocusScope.of(context).unfocus();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 2,
        child: SingleChildScrollView(
          physics: (carTextExitVisibile || personTextExitVisibile) ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics() ,
          controller: childScrollController,
          child: Column(
            children: [
              Stack(
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
                      child: Text(isMorningMode ? '早上車表轉換' : '下午車表轉換', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                    )
                  ),
                  SizedBox(
                    height: 75,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        iconSize: 40,
                        icon: const Icon(Icons.repeat),
                        onPressed: () {
                          isMorningMode = !isMorningMode;
                          setState(() {});
                        },
                      ),
                    )
                  )
                ],
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
                                  style: TextStyle(fontSize: 15),
                                ),
                                onPressed: () => setState(() => widget.errorBoxController.height = 0),
                              )
                          ),
                        ],
                      )
                  )
              ),
              const CarTextBox(),
              const PersonTextBox(),
              Container(
                margin: EdgeInsets.fromLTRB(20, 5, 20, personTextExitVisibile ? personTextBoxHeight : 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green[500],
                      minimumSize: const Size(700, 50)
                  ),
                  onPressed: () async {
                    late var result;
                    if (isMorningMode){
                      result = await processStringMorning(personTextBoxController.text, carTextBoxController.text);
                    }else {result = await processStringAfternoon(personTextBoxController.text, carTextBoxController.text);}

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
                      var showDataObject = ShowDataClass(result, context);
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
        ),
      )
    );

  }
}