import 'package:gsheets/gsheets.dart';
import 'dart:io';


const _credentials = r'''
{
  "type": "service_account",
  "project_id": "",
  "private_key_id": "",
  "private_key": "",
  "client_email": "",
  "client_id": "",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": ""
}
''';

Future<String> get _localPath async {
  final directory = '.\\certificate\\';

  return directory;
}

Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

void main() async {
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
  
  await processString(pM, cM);
}

Future<Map> processString (String personMessage, String carMessage) async {
  Map<String, dynamic> processDatabase = {};

  personMessage = personMessage.replaceAll(" ", "");
  carMessage = carMessage.replaceAll(" ", "");
  List<String> tmpData;
  List tmpList;


  List<String> carIdList = carMessage.split("\n");
  List personCarList = personMessage.split("\n");
  carIdList.add("");

  try {
    int i = 0;
    while (true) {
      if (i > carIdList.length - 1) {
        // print(":!");
        break;
      }
      tmpData = carIdList[i].split("車");
      //print(i)
      if (carIdList[i].contains("午")) {
        if (!(carIdList[i+1].contains("車") == true && carIdList[i+1] != "")) {
          processDatabase[tmpData[0]] = {"Come_ID": tmpData[1].split("午")[1],"Leave_ID": carIdList[i+1].split("午")[1]};
          i += 2;
        }
        else{
          processDatabase[tmpData[0]] = {"Come_ID": null, "Leave_ID": tmpData[1].split("午")[1]};
          i += 1;
        }
      }
      else{
        if(tmpData[0] != ""){
          processDatabase[tmpData[0]] = {"Come_ID": tmpData[1], "Leave_ID": tmpData[1]};
        }
        i += 1;
      }

      personCarList.removeWhere((element) => element == "");
      i = 0;
      // Start from line 86 in main.py
      while(true){
        if (i > (personCarList.length - 1)) break ;
        if (personCarList.contains("車")) {
          tmpData = personCarList[i].split("車");
          tmpList = [];
          for(int i=0; i < personCarList[i+1].split("，").length ; i++){
            tmpList.add([personCarList[i+1].split("，")[i]]);
            if (tmpList.length < 4) {
              for(int k=0 ; k <= (4-tmpList.length) ; k++){
                tmpList.add(['---']);
              }
              if (tmpData[1].contains("來")) processDatabase[tmpData[0]]["Come_Person"] - tmpList;
              if (tmpData[1].contains("回")) processDatabase[tmpData[0]]["Leave_Person"] - tmpList;
            }
          }
        } else i += 2;
      }
    }
  }
  catch (error) {
      print(error);
  }
  print(processDatabase);

  return {};
}
