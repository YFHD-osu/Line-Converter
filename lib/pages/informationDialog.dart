import 'package:flutter/material.dart';

//copy by https://stackoverflow.com/questions/57131978/how-to-animate-alert-dialog-position-in-flutter buttonControlClass {



class buttonControlClass{
  var _decorationShape;
  var _status;

  buttonControlClass(var context) {
    _decorationShape = BorderSide(width: 0, style: BorderStyle.solid, color: Theme.of(context).scaffoldBackgroundColor);
    _status = false;
  }

  void toggle(var context){
    switch (_status){
      case true:
        _status = false;
        _decorationShape = BorderSide(width: 0, style: BorderStyle.solid, color: Theme.of(context).scaffoldBackgroundColor);
        break;
      case false:
        _status = true;
        _decorationShape = BorderSide(width: 3, style: BorderStyle.solid, color: Colors.green.shade500);
        break;
    }
  }
}

List<Widget> GetWidgetList (Map dataBase, var context) {
  List<Widget> previewData = [];
  List<int> carOrder = [];

  if(dataBase['carOrder'] == null){
    for (int i=1; i<= dataBase.length; i++){
      carOrder.add(i);
    }
  }else {carOrder = dataBase['carOrder'];}

  for(int i=1; i<= carOrder.length; i++){
    String key = i.toString();

    previewData.add(
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              child: Text('|$key車| ${dataBase[key]['Come_ID']} ', style: Theme.of(context).textTheme.labelLarge),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(15, 10, 5, 0),
            ),
            Container(
              child: Text('|乘客| ${dataBase[key]['Come_Person']}', style: Theme.of(context).textTheme.labelMedium),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(15, 0, 5, 10),
            ),
          ],
        ),
      )
    );
  }
  return previewData;
}

class showDataClass {
  Map dataBase;
  var context;

  showDataClass(this.dataBase, this.context) {
    this.dataBase = dataBase;
    this.context = context;
    var previewData = GetWidgetList(dataBase, context);

    var saveLocal = buttonControlClass(context);
    var uploadGoogle = buttonControlClass(context);
  }


  showData() async {
    var endCode;

    var previewData = GetWidgetList(dataBase, context);

    var saveLocal = buttonControlClass(context);
    var uploadGoogle = buttonControlClass(context);

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
            builder: (context, setState){
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewPadding.top - 50,
                    width: MediaQuery.of(context).size.width,
                    margin: const  EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text('轉換成功', style: Theme.of(context).textTheme.bodyMedium),
                            ),
                            Container( //關閉按鈕
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 0);
                                  },
                                  child: Text('關閉', style: TextStyle(color: Colors.green[500], fontSize: 20, fontWeight: FontWeight.bold ))
                              ),
                            ),
                            Container( //執行按鈕
                              alignment: Alignment.topRight,
                              margin: EdgeInsets.fromLTRB(0, 5, 5, 0),
                              child: TextButton(
                                  onPressed: !(saveLocal._status || uploadGoogle._status) ? null : (){
                                    if(uploadGoogle._status == true && saveLocal._status == false) {Navigator.pop(context, 1);}
                                    else if (uploadGoogle._status == false && saveLocal._status == true) {Navigator.pop(context, 2);}
                                    else {Navigator.pop(context, 3);}
                                  },
                                  child: Text('執行', style: (saveLocal._status || uploadGoogle._status) ? TextStyle(color: Colors.green[500], fontSize: 20, fontWeight: FontWeight.bold ) : TextStyle(color: Colors.grey[500], fontSize: 20, fontWeight: FontWeight.bold ))
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Column(
                          children: [
                            Row(
                              children: [
                                AnimatedContainer( // 儲存至本機開關
                                    duration: Duration(milliseconds: 200),
                                    width: MediaQuery.of(context).size.width/2 - 15,
                                    height: MediaQuery.of(context).size.width/2 -15,
                                    margin: EdgeInsets.fromLTRB(10, 5, 5, 10),
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: saveLocal._decorationShape,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        )
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(13),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              saveLocal.toggle(context);
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  const Center(child: Icon(Icons.save, size: 135,)),
                                                  Center(child: Text('儲存到本機', style: Theme.of(context).textTheme.titleMedium))
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    )
                                ),
                                AnimatedContainer( // 上傳至表單開關
                                    duration: Duration(milliseconds: 200),
                                    width: MediaQuery.of(context).size.width/2 - 15,
                                    height: MediaQuery.of(context).size.width/2 -15,
                                    margin: EdgeInsets.fromLTRB(5, 5, 10, 10),
                                    decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: uploadGoogle._decorationShape,
                                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                        )
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(13),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              uploadGoogle.toggle(context);
                                            });
                                          },
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  const Center(child: Icon(Icons.cloud_upload, size: 135,)),
                                                  Center(child: Text('上傳至表單', style: Theme.of(context).textTheme.titleMedium))
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    )
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: Center(
                            child: Text('資料預覽',style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                            child: Material(
                              color: Theme.of(context).inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(15),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: SingleChildScrollView(
                                child: Column(children: previewData),
                              ),
                            )

                        ),
                        const SizedBox(height: 10)
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
