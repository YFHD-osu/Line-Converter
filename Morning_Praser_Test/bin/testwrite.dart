import 'dart:async';
import 'package:testwrite/testwrite.dart' as testwrite;
import 'package:gsheets/gsheets.dart';
import 'dart:io';

const _spreadsheetId = '17U7FXfIGVBtZGPb-Ndw0W3HPCx9ZBvLh-o1e_QNdlCw';//

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "dulcet-cat-359804",
  "private_key_id": "0cbbe61fea5972d008484037f5533ef1ee79e210",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOHLYPtG/xKuBG\nPF2ATjSdoeD79qMWb7TeYIuXpnOLB1U9azOi4JOQeVDcKbPYBT0g9v7C4aBGtuKR\nxiRJB2dLMaOZiBS7LzepMo8T7CgjQU+QaLmYTZeKmovf9tQP03vDFkaBrYN03Pkt\n5g/HB6tjUIdtwnCJC1oQvKOu3JkOGu8DXTZiRrMh/cxDYfxBl9jUDnGVyGhaw4I9\nz0+DXLFm7K+JUUEwm+UZpBm7OQx/kzgcd7cp6m8QBRSW5pys+bYs6KiBxsjZwCMb\nJ2Nahtpz/YJpmiqP0Bt2CTIiKja/kA9KxNp0ThxVb0pqdjNlgPnsG+2gE43BO42a\njMZT74vJAgMBAAECggEAAM96Spe3virtF9ZouoNUNjx3nhxrQ404slkoPPZRscqO\nsL+i3XFk0yaCK8nal0jDlt7k9vVpKm4Eq3SsGg3P5hFLZrEMywTVnLI1f550zlkV\nS+jFgtsac4tfbaGF778x10oKolVOCFMbUO1jKX6wholZOi32DR8aZ9w+CCCw72Fb\nUsWxOjzVa8FNTMqFDlH1Lel2ScIyWgUbNlOtAejink6rx3cwEjuW70dXPyzksmCj\n4WbHn7Rud8eMJXpMMhgEB35fP+n5z84dARremoW/mw8p3zohDLaIzu1RyFt4zfu3\n2eyMdhry2fviiaJrlBjrtDOzGdfzNEsQbqmBDYLRYwKBgQDxzWjLmPAx7hYaluO4\n4t2Y+6uuXkK9c5gc270h/Vbq88SRKnDrkFpcyTEepynXTAAggE4EoigjQ5xUxfcc\nyq2ue6N1rtezbAeB9m443Yt8hpyZbaaNiBnU3TPnt8BzY44ehQcsW3AC10ItlnSF\nCqzgBy4z+BlaP5JMkI8bufltHwKBgQDaNtVS6kIU7tc/iec4Gt1RKRu78cziau/C\niAfpY/TClT2wXVHYChekqGPBpMIlu7vDoEZ7HRyfoXqa1igmYwfcEp9bRPOHSqET\nkLtxOfmNAcYbW+nNRIYsgkFdA/BoNaO7SRGjHbmvRAalgE32KQ9Ohahh/sAKI1G1\nvN3c2kOCFwKBgQCivSimvowKTr85rgwdxzJ1YAywEmjAsSfTZGDqm2MARogpW3Mc\nV885W39frgoPCOuc9D2OCMUS1tJEi+hAzHgQUs40yjQKYc67vWt5gkH60W5cJNxP\nrSYVibsBXT59aqegCtBFHlVI1C+KFxTc5c5sCOkjuPr3Lon8Vd67PnOM6QKBgH7K\nA3MU1+aPzBOIDgfkXBmvOAUg/rnEBqFSJr6uLGXvDxPtdQOBAbHTgXrfP0trZDLL\naohYJux9h951doivW768N0lxq8o9S5AxtSeZ1uzeTfxRkGyLVyZ/XHkuM75pBERq\ntUvAlsZGUVJSVXok61blhCvEOFLrqKtfHM4ZJ8ZrAoGAY1BKb/83fJowpdZ4w2OY\nrTyNZr1xPmnDu+omwaOhT8GXGXtF9kzcNEbD14eRxjYCpc4qwk/tyx8g2XzJ/lKn\nWJ1RcZ0oHvP9Q4r+5Opw3dmnlsMcM/ekLD21rD+Q058YxVXvnOdl4b3VZyV/UbOT\n8LVfFWkHPnB3QoBCC2JygmI=\n-----END PRIVATE KEY-----\n",
  "client_email": "yfhd-sheets-client@dulcet-cat-359804.iam.gserviceaccount.com",
  "client_id": "115151941743082732398",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/yfhd-sheets-client%40dulcet-cat-359804.iam.gserviceaccount.com"
}
''';

String pM = r'''
  1車來7:35
  葉妹，玲嫥，阿甘，吳麵
  1車回
  秋田，黃粉，秀梅，葉妹
  2車來7:40
  素英，蕭足，金印，介淦
  2車回
  張錦，介淦，蕭足，素英
  3車來7:35
  照君，秀蘭，秀梅，福祥
  3車回
  榮坤，福祥，秀蘭，照君
  4車來7:30
  秀鳳，淑英，玉媚，廖萬
  4車回
  廖萬，玉媚，淑英，秀鳳
  5車來7:45
  玉蘭，如山，祥元，張錦
  5車回
  祥元，如山，阿秀，玉蘭
  6車來7:50
  駿凱，李義雄，榮坤，黃粉
  6車回
  學炳，李義雄，金印，坤明
  7車來8:15
  秋田，奮力
  7車回
  阿梅，玲嫥，吳麵
  8車來8:20
  學炳，黃義雄
  8車回
  瑞芳，淑純，黃義雄
  9車回
  駿凱，阿甘，奮力
  ''';

  String cM = r'''
  1車24067
  2車25441
  3車14446
  4車25998
  5車24090
  6車上午24338
         下午14227
  7車上午24067
         下午25998
  8車上午24090
         下午14227
  9車下午14446
  ''';

void main() async {
  Map dataBase = await processStringMorning(pM, cM);
  dataBase = {'asdadasd':8874589};

  print('initStarted');

  try{
    final gSheets = GSheets(_credentials);
    final spreadSheet = await gSheets.spreadsheet(_spreadsheetId);
    var sheet = spreadSheet.worksheetByTitle('test');
    print('init Complete !');

    
    List<List<dynamic>> uploadList = await uploadMorning(dataBase, 1, '2022/8/28');
    print(uploadList);

    await sheet!.values.insertColumns(1, uploadList, fromRow: 1);
    print('uploadComplete!');
    
  }
  on FormatException catch (e) {
    print('憑證不完整');
  }
  on GSheetsException catch (e) {
    if (e.toString().indexOf('The caller does not have permission') > 0){print('表單權限不足');}
    else if (e.toString().indexOf('Requested entity was not found') > 0){print('找不到表單');}
    else {print(e.toString());}
  }
  catch(e) {print(e);}
    

  
  
  // return;
  // await processString(pM, cM);
}

Future<List<List<dynamic>>> uploadMorning (Map dataBase, int spaceCount, String dateTime) async {
  /*
  spaceCount = 表單之間隔多遠
  dateTime   = 今日日期字串
  sheetPosition = 表單左上角的座標 [x,y]
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
        for(int repeat=0 ; repeat<=3 ; repeat++) {tmpList0.add('$key車\n${dataBase[key]["Come_ID"]}');} //4格高的車號和ID
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
        for(int index=0 ; index<=3 ; index++){tmpList1.add(dataBase[key]['Come_Person'][index]);}
      }
    }
    uploadList.add(tmpList1);

  }

  for(int i=1 ; i<=spaceCount ; i++) {uploadList.add(['','','']);}

  for(int i=10; i<=12 ; i++){
    List tmpList0 = [];
    List tmpList1 = [];
    
    tmpList0.add(dateTime);
    for (int k=i; k<=i+6 ; k+=3){
      String key = (k).toString();

      if (dataBase[key] == null) {
        for(int repeat=0 ; repeat<=3 ; repeat++){tmpList0.add('');} //找不到這班車? 沒事填個空
      }
      else{
        for(int repeat=0 ; repeat<=3 ; repeat++) {tmpList0.add('$key車\n${dataBase[key]["Come_ID"]}');} //4格高的車號和ID
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
        for(int index=0 ; index<4 ; index++){tmpList1.add(dataBase[key]['Come_Person'][index]);}
      }
    }
    uploadList.add(tmpList1);

  }

  return uploadList;
}

Future<dynamic> processStringMorning (String personMessage, String carMessage) async {
  if (personMessage == "" || carMessage == "") return 1;

  Map<String, Map<String, dynamic>> processDatabase = {};

  personMessage = personMessage.replaceAll(" ", "");
  carMessage = carMessage.replaceAll(" ", "");
  List<String> tmpData;
  List tmpList;

  List<String> carIdList = carMessage.split("\n");
  List<String> personCarList = personMessage.split("\n");
  carIdList.add("");

  int i = 0;
  try {
    while (true) {
      if (i > carIdList.length - 1) {
        break;
      }
      tmpData = carIdList[i].split("車");
      //print(i)
      if (carIdList[i].contains("午")) {
        if ((!(carIdList[i + 1].contains("車")) && (carIdList[i + 1] != ""))) {
          processDatabase[tmpData[0]] = {
            "Come_ID": tmpData[1].split("午")[1],
            "Leave_ID": carIdList[i + 1].split("午")[1]
          };
          i += 2;
        }
        else {
          /* processDatabase[tmpData[0]] =
          {"Come_ID": null, "Leave_ID": tmpData[1].split("午")[1]}; */
          i += 1;
        }
      }
      else {
        if (tmpData[0] != "") {
          processDatabase[tmpData[0]] =
          {"Come_ID": tmpData[1], "Leave_ID": tmpData[1]};
        }
        i += 1;
      }
    }

    personCarList.removeWhere((element) => element == "");

    i = 0;

    while (true) {
      if (i >= (personCarList.length - 1)) {
        break;
      }
      if (personCarList[i].contains("車")) {
        tmpData = personCarList[i].split("車");
        tmpList = [];

        List tmpPersonCarList = personCarList[i + 1].split("，");
        for (int l = 0; l < tmpPersonCarList.length; l++) {
          tmpList.add(tmpPersonCarList[l]);
        }

        if (tmpList.length < 4) {
          for (int k = 0; k <= (4 - tmpList.length); k++) {
            tmpList.add('---');
          }
        }

        if (tmpData[1].contains("來"))
          processDatabase[tmpData[0]]!["Come_Person"] = tmpList;
        /* if (tmpData[1].contains("回"))
          processDatabase[tmpData[0]]!["Leave_Person"] = tmpList; */

        i += 2;
      } else
        i += 1;
    }
  }
  catch(error){
    return 2;
  }

  return processDatabase;
}