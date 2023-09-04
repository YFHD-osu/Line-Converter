enum MessageType {morning, evening}

class ParseException {
  late final String message;
  late final String description;

  ParseException({
    required this.message,
    required this.description,
  });
}

class CarData {
  late int order;
  late Time time;
  late Serial serial;
  late DateTime addTime;
  late MessageType type;
  late Passenger passenger;
  late List<int> orderList;

  CarData fromMorning(CarSerialData serialData, PassengerData passengerData) {
    addTime = DateTime.now();
    order = serialData.order;
    time = passengerData.time;
    type = MessageType.morning;
    serial = serialData.serial;
    passenger = passengerData.passenger;

    return this;
  }

  CarData fromEvening(int order, int serial, List<String> passenger, List<int> orderList) {
    this.order = order;
    addTime = DateTime.now();
    type = MessageType.evening;
    this.serial = Serial(evening: serial);
    this.passenger = Passenger(evening: passenger);
    this.orderList = orderList;
    return this;
  }

  CarData fromMorningDataBase({
    required int order,
    required int? comeSerialData,
    required int? backSerialData,
    required String? comeTimeData,
    required String? backTimeData,
    required List<String>? comePassengerData,
    required List<String>? backPassengerData,
    required DateTime addTime
  }) {
    this.order = order;
    this.addTime = addTime;

    time = Time(
      morning: comeTimeData,
      evening: backTimeData
    );
    serial = Serial(
      morning: comeSerialData,
      evening: backSerialData
    );
    passenger = Passenger(
      morning: comePassengerData,
      evening: backPassengerData
    );

    return this;
  }

  CarData fromEveningDataBase({
    required int order,
    required DateTime addTime,
    required int? backSerialData,
    required List<String>? backPassengerData,
  }) {
    this.order = order;
    this.addTime = addTime;

    serial = Serial(
      evening: backSerialData
    );
    passenger = Passenger(
      evening: backPassengerData
    );

    return this;
  }
  
  /*CarData fromCarId(CarSerialData context) {
    print('$order -> ${context.order}');
    if (order != context.order) throw Error();
    errors += context.errors;
    
    if ((morningID != null) && context.morningID != morningID){ 
      errors.add(ParseException(
        message: context.message ?? "",
        description: '偵測到重複的早上車號ID',
      ));
    } else morningID = context.morningID;

    if ((eveningID != null) && context.eveningID != eveningID){ 
      errors.add(ParseException(
        message: context.message ?? "",
        description: '偵測到重複的下午車號ID',
      ));

    } else eveningID = context.eveningID;
    
    return this;
  }

  CarData fromPerson(PassengerData context) {
    if (order != context.order) throw Error();
    comePassenger += context.comePassenger;
    backPassenger += context.backPassenger;
    errors += context.errors;

    if (context.type == PassengerType.come) {
      morningTime = context.time;
    } else if (context.type == PassengerType.back) {
      eveningTime = context.time;
    }
    return this;
  }*/

}

class Time{
  late String? morning, evening;

  Time({
    this.morning,
    this.evening
  });
}

class Serial{
  int? morning;
  int? evening;

  Serial({
    this.morning,
    this.evening
  });

  Serial? fromStrings(List<String> context) {
    final RegExp intExp = RegExp(r'\d{3,}');
    
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

    return this;
  }

  bool isReliable() => (morning!=null) && (evening!=null);
}

class Passenger{
  List<String>? morning, evening;

  Passenger({
    this.morning,
    this.evening
  });
}

class PassengerData {
  int order;
  Time time;
  Passenger passenger;

  PassengerData({
    required this.order,
    required this.passenger,
    required this.time
  });

  PassengerData? combine(PassengerData context) {
    if (context.order != order) { return null; }

    final bool ctxMorningPassenger = context.passenger.morning == null;
    final bool ctxEveningPassenger = context.passenger.evening == null;
    final bool thisMorningPassenger = passenger.morning == null;
    final bool thisEveningPassenger = passenger.evening == null;

    final bool ctxMorningTime = context.time.morning == null;
    final bool ctxEveningTime = context.time.evening == null;
    final bool thisMorningTime = time.morning == null;
    final bool thisEveningTime = time.evening == null;

    if (!ctxMorningPassenger && !thisMorningPassenger) { return null; } 
    
    if (!ctxEveningPassenger && !thisEveningPassenger) { return null; }

    if (!ctxMorningTime && !thisMorningTime) { return null; }
    
    if (!ctxEveningTime && !thisEveningTime) { return null; }

    passenger.morning = (!ctxMorningPassenger && thisMorningPassenger) ? context.passenger.morning : passenger.morning;
    passenger.evening = (!ctxEveningPassenger && thisEveningPassenger) ? context.passenger.evening : passenger.evening;
    
    time.morning = (!ctxMorningTime && thisMorningTime) ? context.time.morning : time.morning;
    time.evening = (!ctxEveningPassenger && thisEveningTime) ? context.time.evening : time.evening;
    return this;
  }
}

class CarSerialData {
  int order;
  Serial serial;

  CarSerialData({
    required this.order,
    required this.serial
  });
}
