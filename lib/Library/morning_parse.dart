import 'dart:convert';
import 'package:line_converter/Library/typing.dart';

class MorningProc {
  late String carIDMessage;
  late String personMessage;
  final RegExp splitExp = RegExp(r'(，|。|、|,|\.)');

  MorningProc({
    required this.personMessage,
    required this.carIDMessage
  });

  Map<int, CarSerialData> serial = {};
  Map<int, PassengerData> passenger = {};
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

    for (String msg in serialMessages) {parseSerial(msg);}
    for (String msg in passengerMessages) {parsePassenger(msg);}

    return getAllOrder().map((int key) => CarData().fromMorning(serial[key]!, passenger[key]!)).toList();
  }

  List<int> getAllOrder() {
    List<int> result = [];

    passenger.forEach((key, value) {
      if (!result.contains(key)) result.add(key);
    });

    serial.forEach((key, value) {
      if (!result.contains(key)) result.add(key);
    });

    return result.where((int key) => (passenger.containsKey(key) && serial.containsKey(key))).toList();
  }
  // List<CarData> merge() {
  //   Map<int, CarData> data = {};

  //   car.forEach((CarSerialData index) { 
  //     bool isExist = data.containsKey(index.order);
  //     if (isExist) data[index.order]!.fromCarId(index);
  //     else data.addAll({index.order : CarData().fromCarId(index)});
  //   });
    
  //   people.forEach((PassengerData index) { 
  //     bool isExist = data.containsKey(index.order);
  //     if (isExist) data[index.order]!.fromPerson(index);
  //     else data.addAll({index.order : CarData().fromPerson(index)});
  //   });
    
  //   List<CarData> result = [];
  //   data.forEach((key, value) => result.add(value));
  //   return result;
  // }

  void parseSerial(String message) {
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

    int? tmpOrder;
    Serial? tmpSerial;

    if (fullHasMatch){
      tmpOrder = int.tryParse(RegExp(r'\d+?車').firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
      int? serialResult = int.tryParse(RegExp(r'車\d+').firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
      tmpSerial = Serial(morning: serialResult, evening: serialResult);
      // tmpSerial = (tmpSerial.isReliable()) ? tmpSerial : null;

    } else if (sepHasMatch) {
      final RegExp serialExp = RegExp(r'(上|下)午?\d{3,}');
      final List<String> matches = serialExp.allMatches(message).map((match) => match.group(0)!).toList(); // Get two car serial

      tmpSerial = Serial().fromStrings(matches);
      final RegExp orderExp = RegExp(r'\d+?車');
      tmpOrder = int.tryParse(orderExp.firstMatch(message)?.group(0)?.replaceAll('車', '') ?? 'x');
    }
    // print("${tmpOrder}車Serial:${tmpSerial}");

    if (tmpSerial != null && tmpOrder != null) {
      serial.addAll({tmpOrder: CarSerialData(order: tmpOrder, serial: tmpSerial)}); }
    else {
      errors.add(ParseException(message: message, description: '未知原因導致無法解析字串')); }
  }

  void parsePassenger(String message) {
    // Analyze car type is Come or Back
    bool isCome = message.contains('來');
    bool isBack = message.contains('回');
    
    RegExp headingExp = RegExp(r'\d+?(車(來|回)?|(來|回))\d{0,2}:?\d{0,2}');

    // Cannot get main message structure
    if (!headingExp.hasMatch(message)) {
      errors.add(ParseException(message: message,description: '無法辨別車輛編號'));
      return;
    }

    // If '來' and '回' are both or not in message
    if (isCome == isBack) {
      errors.add(ParseException(message: message,description: '無法辨別車輛來回類型'));
      return;
    }

    int? tmpOrder = int.tryParse(RegExp(r'\d+').firstMatch(message.split('車').first)?.group(0) ?? 'x');
    String? tmpTime = RegExp(r'\d{1,2}:\d{1,2}').firstMatch(message)?.group(0);
    List<String> tmpPassenger = message
      .split(headingExp).last
      .replaceAll(const Utf8Decoder().convert([13]), '')
      .split(splitExp);
    
    if (tmpOrder == null) {
      errors.add(ParseException(message: message,description: '無法辨別車輛順序'));
      return;
    }

    late PassengerData object;

    if (passenger.containsKey(tmpOrder)) {
      object = passenger[tmpOrder]!;}
    else {
      object = PassengerData(order: tmpOrder, passenger: Passenger(), time: Time());
      passenger.addAll({tmpOrder: object});
    }

    PassengerData? result = object.combine(
      PassengerData(
        order: tmpOrder,
        passenger: Passenger(
          morning: (isCome) ? tmpPassenger : null,
          evening: (isBack) ? tmpPassenger : null
        ), 
        time: Time(
          morning: (isCome) ? tmpTime : null,
          evening: (isBack) ? tmpTime : null
        )
    ));

    if (result == null) errors.add(ParseException(message: message,description: '訊息中有部分資訊衝突'));

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