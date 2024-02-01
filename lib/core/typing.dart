enum MessageType {morning, evening}

class ParseException {
  final String message, description;

  ParseException({
    required this.message,
    required this.description,
  });
}

class Time{
  late String? morning, evening;

  Time({this.morning, this.evening});

  factory Time.fromType(bool isCome, String? time) {
    switch(isCome) {
      case true: return Time(morning: time);
      case false: return Time(evening: time);
    }
  }

  factory Time.fromMap(Map res) {
    return Time(
      morning: res["morning"],
      evening: res["evening"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "morning": morning,
      "evening": evening
    };
  }
}

class Serial{
  int? morning;
  int? evening;

  Serial({this.morning, this.evening});

  factory Serial.fromStrings(List<String> context) {
    final RegExp intExp = RegExp(r'\d{3,}');
    
    int? morning, evening;
    if (context.length > 1 || context.toString().contains('上') || context.toString().contains('下')) {
      for (String index in context) {
        String? serialString = intExp.firstMatch(index)?.group(0) ?? 'x';
        if (index.contains('上')) {
          morning = int.tryParse(serialString); }

        else if (index.contains('下')) {
          evening = int.tryParse(serialString); }
      }

    } else {
      morning = evening = int.tryParse(context.first.split('車').last);
    }

    return Serial(morning: morning, evening: evening);
  }

  factory Serial.both(int serial) {
    return Serial(morning: serial, evening: serial);
  }

  factory Serial.fromType(MessageType type, int serial) {
    switch (type) {
      case MessageType.morning: return Serial(morning: serial);
      case MessageType.evening: return Serial(evening: serial);
    }
  }

  factory Serial.fromMap(Map res) {
    return Serial(
      morning: res["morning"],
      evening: res["evening"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "morning": morning,
      "evening": evening 
    };
  }
}

class CarData {
  int order;
  Time time;
  Serial serial;
  MessageType type;
  DateTime addTime;
  Passenger passenger;
  List<int> orderList;

  CarData({
    required this.type,
    required this.time,
    required this.order, 
    required this.serial, 
    required this.addTime, 
    required this.passenger,
    required this.orderList
  });

  factory CarData.fromMorning(CarSerialData serialData, PassengerData passengerData) {
    return CarData(
      order: serialData.order,
      time: passengerData.time,
      serial: serialData.serial,
      addTime: DateTime.now(),
      type: MessageType.morning,
      passenger: passengerData.pax,
      orderList: [serialData.order]
    );
  }

  factory CarData.fromEvening(int order, int serial, List<String> pax, List<int> orderList) {
    return CarData(
      type: MessageType.evening,
      time: Time(),
      order: order,
      serial: Serial(evening: serial),
      addTime: DateTime.now(), 
      passenger: Passenger(back: pax.map((e) => e.replaceAll(" ", "")).toList()), 
      orderList: orderList
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type.index,
      "time": time.toMap(),
      "order": order,
      "serial": serial.toMap(),
      "addTime": addTime.millisecondsSinceEpoch,
      "passenger": passenger.toMap(),
      "orderList": orderList
    };
  }

  factory CarData.fromMap(Map res) {
    return CarData(
      type: MessageType.values[res["type"]],
      time: Time.fromMap(res["time"]),
      order: res["order"],
      serial: Serial.fromMap(res["serial"]),
      addTime: DateTime.fromMillisecondsSinceEpoch(res["addTime"]),
      passenger: Passenger.fromMap(res["passenger"]),
      orderList: (res["orderList"] as List).map((e) => int.parse(e)).toList()
    );
  }

  factory CarData.fromMorningDB({
    required int order,
    required int? comeSerialData,
    required int? backSerialData,
    required String? comeTimeData,
    required String? backTimeData,
    required List<String>? comePax,
    required List<String>? backPax,
    required DateTime addTime
  }) {
    return CarData(
      order: order,
      time: Time(
        morning: comeTimeData,
        evening: backTimeData
      ),
      serial: Serial(
        morning: comeSerialData,
        evening: backSerialData
      ),
      addTime: addTime,
      type: MessageType.morning,
      passenger: Passenger(
        come: comePax?.map((e) => e.replaceAll(" ", "")).toList(),
        back: backPax?.map((e) => e.replaceAll(" ", "")).toList()
      ),
      orderList: []
    );
  }

  factory CarData.fromEveningDB({
    required int order,
    required DateTime addTime,
    required int? backSerialData,
    required List<String>? backPax,
  }) {
    return CarData(
      order: order,
      time: Time(evening: ""),
      serial: Serial(evening: backSerialData),
      addTime: addTime,
      type: MessageType.evening,
      passenger: Passenger(back: backPax?.map((e) => e.replaceAll(" ", "")).toList()),
      orderList: []
    );
  }

  void mergePax({required bool isCome, List<String>? pax}) {
    if (isCome) {
      passenger.come ??= pax?.map((e) => e.replaceAll(" ", "")).toList();
    } else {
      passenger.back ??= pax?.map((e) => e.replaceAll(" ", "")).toList();
    }
  }
}

class Passenger{
  List<String>? come, back;
  Passenger({this.come, this.back});

  factory Passenger.fromType(bool isCome, List<String> pax) {
    switch(isCome) {
      case true: 
        return Passenger(come: pax.map((e) => e.replaceAll(" ", "")).toList());
      case false: 
        return Passenger(back: pax.map((e) => e.replaceAll(" ", "")).toList());
    }
  }

  factory Passenger.fromMap(Map res) {
    final result = Passenger(
      come: (res["come"] as List?)?.map((e) => e.toString()).toList(),
      back: (res["back"] as List?)?.map((e) => e.toString()).toList()
    );
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      "come": come,
      "back": back
    };
  }
}

class PassengerData {
  int order;
  Time time;
  Passenger pax;

  PassengerData({
    required this.order,
    required this.pax,
    required this.time
  });

  PassengerData combine(PassengerData data) {
    if (data.order != order) throw Exception("Try to combine with two different order");
    pax.come = data.pax.come??pax.come;
    pax.back = data.pax.back??pax.back;
    return this;
  }
}

class CarSerialData {
  int order;
  Serial serial;

  CarSerialData({required this.order, required this.serial});
}
