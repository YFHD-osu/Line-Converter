import 'dart:convert';
import 'package:line_converter/core/typing.dart';

class MainPraser {
  late final String personMessage;
  late final String carIDMessage;

  MainPraser({
    required this.personMessage,
    required this.carIDMessage
  });

  MessageType determine() {
    final exp = RegExp(r'(,|\.|，|、|\d| )');
    if (personMessage.replaceAll(exp, "").isEmpty || carIDMessage.replaceAll(exp, "").isEmpty ) {
      return MessageType.evening;
    }
    return MessageType.morning;
  }

  (List<CarData>, List<ParseException>) parse () {
    switch (determine()) {
      case MessageType.morning: {
        final result = MorningProc(personMessage: personMessage, carIDMessage: carIDMessage);
        return (result.parse(), result.errors);
      }
      case MessageType.evening: {
        final result = EveningProc(personMessage: personMessage, carIDMessage: carIDMessage);
        return (result.parse(), result.errors);
      }
    }
  }
}

class MorningProc {
  late String carIDMessage;
  late String personMessage;
  final RegExp splitExp = RegExp(r'(，|。|、|,|\.)');

  MorningProc({
    required this.personMessage,
    required this.carIDMessage
  });

  Map<int, CarData> dataMap = {}; 

  List<ParseException> errors = [];
  
  List<ParseException> getErrors () => errors;

  List<CarData> parse() {
    switch2Correct();

    final List<int> passengerIndexRange = RegExp(r'\d{0,}?車(回|來)?').allMatches(personMessage)
    .map((RegExpMatch match) => match.start)
    .toList() + [personMessage.length];

    final List<int> serialIndexRange = RegExp(r'\d{1,}車').allMatches(carIDMessage)
    .map((RegExpMatch match) => match.start)
    .toList() + [carIDMessage.length];

    final List<String> passengerMessages = [for (int i=0 ; i<passengerIndexRange.length-1 ; i++) 
      personMessage.substring(passengerIndexRange[i], passengerIndexRange[i+1]).replaceAll("\n", "")
    ];

    final List<String> serialMessages = [for (int i=0 ; i<serialIndexRange.length-1 ; i++) 
      carIDMessage.substring(serialIndexRange[i], serialIndexRange[i+1]).replaceAll("\n", "")
    ];

    for (String msg in serialMessages) {_parseSerial(msg);}
    for (String msg in passengerMessages) {_parsePassenger(msg);}

    return dataMap.values.toList();
  }

  void _parseSerial(String message) {
    message = message.replaceAll(" ", "");
    final RegExp fullCarID = RegExp(r'\d{1,}車\d{3,}');
    final RegExp sepCarID = RegExp(r'(上|下)午?\d{3,}');
    final bool fullHasMatch = fullCarID.hasMatch(message);
    final bool sepHasMatch = sepCarID.hasMatch(message);
    
    // While "1車123456" and "上午654321" both detected
    if (fullHasMatch && sepHasMatch) {
      errors.add(ParseException(message: message, description: "同時偵測到上午、下午表達式與通用表達式"));
      return;
    }

    if (!(fullHasMatch || sepHasMatch)) {
      errors.add(ParseException(message: message, description: "無法偵測上午、下午格式"));
      return;
    }

    /* While "上午123456" and "下午654321" didn't appear together
    if (!fullHasMatch && sepCarID.allMatches(message).length != 2) {
      bool isMorning = message.contains('上'); 
      errors.add(ParseException(message: message, description: "缺乏相關${isMorning ? '下午' : '上午'}變數"));
      return;
    }*/
    
    // While car order wasn't found
    if (RegExp(r'車').allMatches(message).length != 1) {
      errors.add(ParseException(message: message, description: "無法取得車輛代號"));
      return;
    }
    
    int? order; 
    Serial serial;
    if (fullHasMatch){ // 1車1234567
      order = int.tryParse(RegExp(r'\d+?車').firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
      final serialInt = int.tryParse(RegExp(r'車\d+').firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
      serial = Serial.both(serialInt??-1);
      if (serialInt == null) {
        errors.add(ParseException(message: message, description: '無法解析該班車的序號')); 
        return;
      } else if (order == null) {
        errors.add(ParseException(message: message, description: '無法解析該班車為第幾車'));
        return;
      }

    } else { // 1車 上123524 下213124
      final RegExp orderExp = RegExp(r'\d+?車');
      final RegExp serialExp = RegExp(r'(上|下)午?\d{3,}');
      final List<String> matches = serialExp.allMatches(message).map((match) => match.group(0)!).toList(); // Get two car serial
      order = int.tryParse(orderExp.firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
      serial = Serial.fromStrings(matches);
      if (matches.isEmpty) {
        errors.add(ParseException(message: message, description: '無法取得該班車的序號')); 
        return;
      } else if (order == null) {
        errors.add(ParseException(message: message, description: '無法解析該班車為第幾車'));
        return;
      }
    }
    
    if (dataMap.keys.contains(order)) {
      errors.add(ParseException(message: message, description: '第$order車被重複定義')); 
      return;
    }

    dataMap.addAll({order: CarData(
      type: MessageType.morning,
      time: Time(),
      order: order,
      serial: serial,
      addTime: DateTime.now(),
      passenger: Passenger(),
      orderList: []
    )});
    // print("${tmpOrder}車Serial:${tmpSerial}");
  }

  void _parsePassenger(String message) {
    // Analyze car type is Come or Back
    bool isCome = message.contains('車來');
    bool isBack = message.contains('車回');
    RegExp headingExp = RegExp(r'\d+?(車(來|回)?|(來|回))\d{0,2}:?\d{0,2}');

    if (!headingExp.hasMatch(message)) { // Cannot get main message structure
      errors.add(ParseException(message: message,description: '無法辨別車輛編號'));
      return;
    }

    if (isCome == isBack) { // If '來' and '回' are both or not in message
      errors.add(ParseException(message: message,description: '無法辨別車輛來回類型'));
      return;
    }

    final int? order = int.tryParse(RegExp(r'\d+').firstMatch(message.split('車').first)?.group(0) ?? 'x');
    final String? time = RegExp(r'\d{1,2}:\d{1,2}').firstMatch(message)?.group(0);
    final List<String> pax = message
      .split(headingExp).last
      .replaceAll(const Utf8Decoder().convert([13]), '')
      .split(splitExp);
    
    if (order == null) {
      errors.add(ParseException(message: message,description: '無法辨別車輛順序'));
      return;
    }
    
    dataMap[order] ??= CarData(
      order: order,
      type: (isCome) ? MessageType.morning : MessageType.evening, 
      time: Time.fromType(isCome, time), 
      serial: Serial(), 
      addTime: DateTime.now(), 
      passenger: Passenger.fromType(isCome, pax), 
      orderList: [],
    );

    dataMap[order]!.mergePax(isCome: isCome, data: pax);
    return;
  }

  void switch2Correct() { // Swap two message if they are wrong
    if (RegExp(r'\d{0,}?車(回|來)?').hasMatch(carIDMessage) && 
        RegExp(r'(\d{0,})?車?(上午|下午)?\d{3,}').hasMatch(personMessage)
    ) {
      String cMsg = carIDMessage;
      String pMsg = personMessage;
      personMessage = cMsg;
      carIDMessage = pMsg;
    }
  }

}

class EveningProc {
  late String carIDMessage;
  late String personMessage;

  EveningProc({
    required this.carIDMessage,
    required this.personMessage
  });

  List<CarData> result = [];
  List<ParseException> errors = [];

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

    result.add(CarData.fromEvening(tmpCarOrder, tmpCarId, tmpPassenger, orderList));

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