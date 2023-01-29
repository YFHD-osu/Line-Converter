import 'package:flutter/material.dart';
import 'dart:async';
import '../gsheet.dart';
import '../dataManager.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:gsheets/gsheets.dart';

class ProgressBarController {
  double value ;
  double height = 55;
  bool isStop = false;
  String lore;
  Color? color = Colors.green[500];

  ProgressBarController(this.value, this.height, this.lore, this.color){
    value = value;
    height = height;
    isStop = false;
    lore = lore;
    color = color;
  }
}

class processDialogClass {
  double processPersent = 0;
  var context;
  var endCode;
  var dataBase;

  processDialogClass(this.context, this.endCode, this.dataBase ) {
    context = context;
    endCode = endCode;
    dataBase = dataBase;
  }

  showProcessDialog() async {
    final _localProgressbarController = ProgressBarController((endCode == 2 || endCode == 3)? 0 : 1, (endCode == 2 || endCode == 3) ? 48 : 0, '已完成: 0%', Colors.green[500]);
    final _uploadProgressbarController = ProgressBarController((endCode == 1 || endCode == 3) ? 0 : 1, (endCode == 1 || endCode == 3) ? 48 : 0, '已完成: 0%', Colors.green[500]);

    final GlobalKey _dialogKey = GlobalKey();

    switch(endCode){
      case 1:
        uploadMorningData(_dialogKey, _uploadProgressbarController, dataBase).then((value) {

          if (value == 0 || value == -1) {return;}
          _uploadProgressbarController.value = 1.0;
          _uploadProgressbarController.color = Colors.red[500];
          switch(value){
            case 1:
              _uploadProgressbarController.lore = '憑證不完整';
              break;
            case 2:
              _uploadProgressbarController.lore = '表單權限不足';
              break;
            case 3:
              _uploadProgressbarController.lore = '找不到表單';
              break;
            case 4:
              _uploadProgressbarController.lore = '找人囉(E-Parse)';
              break;
            }
          }
        );
        break;
      case 2:
        try{
          writeFile(dataBase);
        }catch(error){
          print(error);
          _localProgressbarController.lore = "失敗";
          _localProgressbarController.value = 1;
          break;
        }
        _localProgressbarController.value = 1;
        _localProgressbarController.lore = "成功";
        break;
      case 3:
        uploadMorningData(_dialogKey, _uploadProgressbarController, dataBase);
        writeFile(dataBase);
        _localProgressbarController.value = 1;

    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          key: _dialogKey,
          builder: (context, setState){
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 118 + _uploadProgressbarController.height/4*5 + _localProgressbarController.height/4*5,
                width: MediaQuery.of(context).size.width,
                margin: const  EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text('作業中', style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Container( //關閉按鈕
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                          child: TextButton(
                              onPressed: (_localProgressbarController.value == 1 && _uploadProgressbarController.value == 1) ? null : () async {
                                _uploadProgressbarController.isStop = true;
                                Navigator.pop(context, 0);
                                },
                              child: Text('停止', style: TextStyle(color: !(_localProgressbarController.value == 1 && _uploadProgressbarController.value == 1)? Colors.red[500] : Colors.grey[500], fontSize: 20, fontWeight: FontWeight.bold ))
                          ),
                        ),
                        Container( //完成按鈕
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                          child: TextButton(
                              onPressed: !(_localProgressbarController.value == 1.0 && _uploadProgressbarController.value == 1.0) ? null : () {
                                Navigator.pop(context, 0);
                                },
                              child: Text('完成', style: TextStyle(color: (_localProgressbarController.value == 1 && _uploadProgressbarController.value == 1)? Colors.green[500] : Colors.grey[500], fontSize: 20, fontWeight: FontWeight.bold ))
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).scaffoldBackgroundColor
                      ),
                      child: Center(
                        child: Text('執行進度',style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                      ),
                    ),

                     SizedBox(height: 10),

                     Column(
                        children: [
                          Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                width: MediaQuery.of(context).size.width - 20,
                                height: _localProgressbarController.height,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.save, size: 40),
                                              Container(
                                                  child: Text('儲存至本機',style: Theme.of(context).textTheme.titleMedium,)
                                              ),
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            margin: EdgeInsets.fromLTRB(0, 10, 10, 8),
                                            child: Text(_localProgressbarController.lore ,style: Theme.of(context).textTheme.labelMedium),
                                          )
                                        ],
                                      ),
                                    ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    child: LinearProgressIndicator(
                                      color: _localProgressbarController.color,
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      value: _localProgressbarController.value,
                                      semanticsLabel: 'Linear progress indicator',
                                      )
                                    )
                                  ],
                                )
                                ),
                              ),

                        SizedBox(height: (_localProgressbarController.height == 0) ? 0 : 10),

                        Material(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: MediaQuery.of(context).size.width - 20,
                            height: _uploadProgressbarController.height,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.upload_rounded, size: 40),
                                          Text('上傳至Google',style: Theme.of(context).textTheme.titleMedium,)
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.bottomRight,
                                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 8),
                                        child: Text(_uploadProgressbarController.lore,style: Theme.of(context).textTheme.labelMedium)
                                      )
                                    ],
                                  ),
                                ),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: LinearProgressIndicator(
                                color: _uploadProgressbarController.color,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                value: _uploadProgressbarController.value,
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                        SizedBox(height: (_uploadProgressbarController.height == 0) ? 0 : 5)
                    ],
                  ),
                //const SizedBox(height: 0),
                ],
              )
            ),
          );
        }
      );
    },
  ).then((value) {
    endCode = value;
  }
  );
  return endCode;

}

}

/*
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
 */