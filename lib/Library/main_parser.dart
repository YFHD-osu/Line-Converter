import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Library/morning_parse.dart';

import 'evening_parse.dart';

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