import 'package:line_converter/core/typing.dart';
import 'package:line_converter/core/parser.dart';

String message1 = '''
車來7:35
  1葉妹，玲嫥，彩玉，阿甘
  1車回
  秋田，黃粉，秀梅，葉妹
  2車來7:40
  素英，秀蘭，蕭足，淑英
  2車回
  婉明，介淦，蕭足，素英
  :35
  照君，金印、福祥，吳麵
  3車回
  福祥，秀蘭，照君，陳愛
  4車來7:45
  玉蘭，張錦，經國，介淦
  4車回
  經國，張錦，阿秀，玉蘭
  5車來7:50
  駿凱，秀梅，玉媚
  5車回
  廖萬，玉媚。淑英，秀鳳
  6車來7:50
  廖萬，夏枝、李義雄，黃粉
  6車回
  學炳，李義雄。金印 坤明
  7車來8:15
  秋田.奮力
  7車回
  阿梅，玲嫥。彩玉
  8車來8:20
  學炳，黃義雄
  8車回
  黃義雄，瑞芳，淑純，吳麵
  9車回
  夏枝，駿凱，阿甘，奮力
''';

String message2 = '''
  1車24067
  2車上午25998
        下午10372
  3車14446
  4車24090
  5車上午24338
        下午25998
  6車25441
  7車25998
  8車上午24067
        下午24090
  9車下午25441
    
''';

void main() {
  final data = MorningProc(
    personMessage: message1,
    carIDMessage: message2
  );
  List<CarData> result = data.parse();

  // Pretty print all results
  result.forEach((element) {
    print("車輛順序: ${element.order}");
    print("早車輛編號: ${element.serial.morning} 時間: ${element.time.morning}");
    print("晚車輛編號: ${element.serial.evening} 時間: ${element.time.evening}");
    print("來乘客: ${element.passenger.come}");
    print("回乘客: ${element.passenger.back}");
  });
  data.errors.forEach((element) {print("${element.description}: ${element.message}"); });
}