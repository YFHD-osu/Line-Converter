import 'package:testwrite/testwrite.dart' as testwrite;

String cString = r'''
1車回24067
奮力，秋田，黃粉，葉妹
2車回14227
李義雄，蘇珠，蕭足，素英
3車回14446
駿凱，榮坤，福祥，陳愛
4車回25441
經國，張錦，如山，阿秀
5車回25991
婉明，秀蘭，必康，坤明
6車回25998
桂枝，玉媚，淑英，秀鳳
7車回24065
學炳，素喜，秀梅，洪鍊
8車回25998
玲嫥，彩玉
9車回25991
淑純，永德，阿梅
10車回24065
黃義雄，夏枝
''';

String orderString = r'''
10、9、3、2、1、4、6、7、5
''';

void main(List<String> arguments) {
  processString(cString, orderString);
}

dynamic processString(String cString, String orderString) async {
  cString.replaceAll(" ", "");
  orderString.replaceAll(" ", "");

  List<String> carList = cString.split('\n');
  List<dynamic> orderList = orderString.split('、');

  Map<String, dynamic> processDatabase = {};
  processDatabase['carOrder'] = <int>[];

  List<dynamic> tmpList = [];
  List<dynamic> tmpList2 = [];

  try {
    for (int i = 0; i < orderList.length; i++) {
      tmpList.add(int.tryParse(orderList[i])!);
    }
  } catch (error) {
    print('請只輸入數字訊息: $error');
    return 3;
  }
  processDatabase['carOrder'] = tmpList;

  for (int i = 0; i < (carList.length - 1); i += 2) {
    tmpList = carList[i].split("車回");
    processDatabase[tmpList[0]] = {'carID': tmpList[1]};
    tmpList2 = carList[i + 1].split("，");
    processDatabase[tmpList[0]]['person'] = tmpList2;
  }

  print(processDatabase);

  return processDatabase;
}
