import 'dart:async';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'dart:convert';
import 'pages/processDialog.dart';

void saveCredentials (String _credentials) {
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  encryptedSharedPreferences.setString('credentials', _credentials).then((bool success) {
    if (success) {print('success');}
    else {print('fail');}
  });
}

Future<String> readDatas (String key) async {
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  String returnValue = await encryptedSharedPreferences.getString(key);
  return returnValue;
}

Future<int> uploadMorningData(GlobalKey _dialogKey, var status, Map dataBase) async {

  final List weekString = ['', '一', '二', '三', '四', '五', '六', '日', '一'];
  DateTime now = DateTime.now();
  now = now.add(const Duration(days: 1));
  String dateTime = "${now.year}年${now.month}月${now.day}日 (${weekString[now.weekday]})";

  try{
    List<List<dynamic>> uploadList = (dataBase['carOrder'] == null) ? await uploadListMorning(dataBase, 1 ,dateTime) : await uploadListMorning(dataBase, 1 ,dateTime);
    if (status.isStop) {return -1;}

    if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {_dialogKey.currentState!.setState(() { status.value = 0.25; status.lore = "完成: 25%"; } );}
    final gSheets = GSheets(json.decode(await readDatas('certificate')));
    if (status.isStop) {return -1;}

    if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {_dialogKey.currentState!.setState(() { status.value = 0.50; status.lore = "完成: 50%";} );}
    final spreadSheet = await gSheets.spreadsheet(await readDatas('sheetID'));
    if (status.isStop) {return -1;}

    if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {_dialogKey.currentState!.setState(() { status.value = 0.75; status.lore = "完成: 75%";} );}
    var sheet = spreadSheet.worksheetByTitle(await readDatas('morningWorkspaceTitle'));

    if (status.isStop) {return -1;}
    if (_dialogKey.currentState != null && _dialogKey.currentState!.mounted) {_dialogKey.currentState!.setState(() { status.value = 1.0; status.lore = "完成: 100%";} );
    }
    await sheet!.values.insertColumns(1, uploadList, fromRow: 1);
  }

  on FormatException catch (e) {return 1;} //'憑證不完整'
  on GSheetsException catch (e) {
    if (e.toString().indexOf('The caller does not have permission') > 0){return 2;} //'表單權限不足'
    else if (e.toString().indexOf('Requested entity was not found') > 0){return 3;} //'找不到表單'
    else if (e.toString().indexOf('Range') > 0){return 4;}                          //'找人囉(E-Parse)'
    else {return 5;}  //'找人囉(E-Unknow)'
  }

  return 0;
}

/*
Future<String?> _myFuture() async {
  await Future.delayed(const Duration(seconds: 5));
  return 'Future completed';
}

// keep a reference to CancelableOperation
CancelableOperation? _myCancelableFuture;

// This is the result returned by the future
String? _text;

// Help you know whether the app is "loading" or not
bool _isLoading = false;

// This function is called when the "start" button is pressed
void _getData() async {
  _isLoading = true;
  _myCancelableFuture = CancelableOperation.fromFuture(_myFuture(), onCancel: () => 'Future has been canceld',
  );

  final value = await _myCancelableFuture?.value;
  // update the UI
  _text = value;
  _isLoading = false;
}

// this function is called when the "cancel" button is tapped
void _cancelFuture() async {
  final result = await _myCancelableFuture?.cancel();
  _text = result;
  _isLoading = false;
}

 */


Future<List<List<dynamic>>> uploadListMorning (Map dataBase, int spaceCount, String dateTime) async {
  /*
  spaceCount = 表單之間隔多遠
  dateTime   = 今日日期字串
  */

  List<List<dynamic>> uploadList = [];

  for(int i=1; i<=3 ; i++){
    List tmpList0 = [];
    List tmpList1 = [];

    tmpList0.add(dateTime);
    for (int k=i; k<=i+6 ; k+=3){
      String key = (k).toString();

      if (dataBase[key] == null) {
        for(int repeat=0 ; repeat<=3 ; repeat++){tmpList0.add('');} //找不到這班車? 沒事填個空
      }
      else{
        for(int repeat=0 ; repeat<=3 ; repeat++) {tmpList0.add('$key車\n${dataBase[key]["carID"]}');} //4格高的車號和ID
      }
    }
    uploadList.add(tmpList0);

    tmpList1.add(dateTime);
    for (int j=i; j<=i+6 ; j+=3){
      String key = (j).toString();
      if(dataBase[key] == null) {
        for(int index=0 ; index<4 ; index++){tmpList1.add('');}
      }
      else{
        for(int index=0 ; index<=3 ; index++){tmpList1.add(dataBase[key]['person'][index]);}
      }
    }
    uploadList.add(tmpList1);

  }

  for(int i=1 ; i<=spaceCount ; i++) {uploadList.add(['','','']);}

  for(int i=10; i<=12 ; i++){
    List tmpList0 = [];
    List tmpList1 = [];

    tmpList0.add(dateTime);
    for (int k=i; k<=i+2 ; k+=3){
      String key = (k).toString();

      if (dataBase[key] == null) {
        for(int repeat=0 ; repeat<=3 ; repeat++){tmpList0.add('');} //找不到這班車? 沒事填個空
      }
      else{
        for(int repeat=0 ; repeat<=3 ; repeat++) {tmpList0.add('$key車\n${dataBase[key]["carID"]}');} //4格高的車號和ID
      }
    }
    uploadList.add(tmpList0);

    tmpList1.add(dateTime);
    for (int j=i; j<=i+2 ; j+=3){
      String key = (j).toString();
      if(dataBase[key] == null) {
        for(int index=0 ; index<4 ; index++){tmpList1.add('');}
      }
      else{
        for(int index=0 ; index<4 ; index++){tmpList1.add(dataBase[key]['person'][index]);}
      }
    }
    uploadList.add(tmpList1);

  }

  return uploadList;
}

