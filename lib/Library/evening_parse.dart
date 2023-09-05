import 'dart:convert';
import 'package:line_converter/Library/typing.dart';

class EveningProc {
  late String carIDMessage;
  late String personMessage;

  EveningProc({
    required this.carIDMessage,
    required this.personMessage
  });

  List<ParseException> errors = [];
  List<CarData> result = [];

  List<CarData> parse() {
    switch2Correct();

    final orderList = getOrderList();
    if (orderList.contains(-1)) {
      errors.add(ParseException(message: carIDMessage, description: "車表順序中包含非阿拉伯數字"));
    }

    final List<int> personIndexRange = RegExp(r'\d{1,}車').allMatches(personMessage)
    .map((RegExpMatch match) => match.start)
    .toList() + [personMessage.length];

    final List<String> personMessages = [for (int i=0 ; i<personIndexRange.length-1 ; i++) 
      personMessage.substring(personIndexRange[i], personIndexRange[i+1]).replaceAll("\n", "")
    ];

    for (String msg in personMessages) {parsePerson(msg, orderList);}
    return result;
  }

  void parsePerson(String message, List<int> orderList) {
    String? heading = RegExp(r'\d+?車(來|回|)\d+').firstMatch(
      message
      .replaceAll(const Utf8Decoder().convert([13]), '')
      .replaceAll(" ", '')
    )?.group(0);

    int? tmpCarOrder = int.tryParse(
      (RegExp(r'\d+?車').firstMatch(heading??'')?.group(0)??'x')
      .replaceAll('車', '')
    );

    int? tmpCarId = int.tryParse(
      (RegExp(r'車.?\d{2,}').firstMatch(heading??'')?.group(0) ?? 'x')
      .replaceAll(RegExp(r'(車|來|回)'), '')
    );

    List<String> tmpPassenger = 
      message
      .replaceAll(" ", '')
      .replaceAll(RegExp(r'\d+?車(來|回|)\d+'), '')
      .replaceAll(const Utf8Decoder().convert([13]), '')
      .split(RegExp(r'(，|。|、|,|\.)')); 

    if (tmpCarOrder == null) {
      errors.add(ParseException(message: message, description: '無法取得車輛順序'));
      return;
    }

    if (tmpCarId == null) {
      errors.add(ParseException(message: message, description: '無法取得車輛代號'));
      return;
    }

    if (tmpPassenger.isEmpty) {
      errors.add(ParseException(message: message, description: '無法取得該車的乘客'));
      return;
    }

    result.add(CarData().fromEvening(tmpCarOrder, tmpCarId, tmpPassenger, orderList));

  }

  List<int> getOrderList() {
    final exp = RegExp(r'(,|\.|，|、)');

    return carIDMessage.split(exp).map((String index) 
      => int.tryParse(index)??-1).toList();
  }

  void switch2Correct() { // Swap two message if they are wrong
    final exp = RegExp(r'(,|\.|，|、|\d| )');
    if (personMessage.replaceAll(exp, "").isEmpty) {
      String cMsg = carIDMessage;
      String pMsg = personMessage;
      personMessage = cMsg;
      carIDMessage = pMsg;
    }
  }

}