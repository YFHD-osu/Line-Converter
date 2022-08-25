Future<dynamic> processStringAfternoon (String personMessage, String carMessage) async {
  Map<String, Map<String, dynamic>> processDatabase = {};

  if(personMessage == "" || carMessage == ""){
    return 1;
  }

  personMessage = personMessage.replaceAll(" ", "");
  carMessage = carMessage.replaceAll(" ", "");
  List<String> tmpData;
  List tmpList;


  List<String> carIdList = carMessage.split("\n");
  List<String> personCarList = personMessage.split("\n");
  carIdList.add("");

  try {
    int i = 0;
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
          processDatabase[tmpData[0]] =
          {"Come_ID": null, "Leave_ID": tmpData[1].split("午")[1]};
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
    // Start from line 86 in main.py
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
  }catch(error){
    return 2;
  }
  print(processDatabase);

  return processDatabase;
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
    // Start from line 86 in main.py
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