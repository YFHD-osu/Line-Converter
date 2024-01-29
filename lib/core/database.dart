import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:path/path.dart';
import 'package:line_converter/core/typing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStore {
  FireStore._();
  static FireStore? _instance;
  static FireStore get instance {
    _instance ??= FireStore._();
    return _instance!;
  }

  UserCredential? user;

  final iv = IV.fromUtf8("8PzGKSMLuqSm0MVb");
  final key = Key.fromUtf8("xUhHPVSWs2nDjg2XY3XZ82DE75lbjNTG");
  final authApi = FirebaseAuth.instance;

  Future<bool> storeEmailPasswd(String email, String passwd) async {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt("$email::$passwd", iv: iv);
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString("login", encrypted.base64);
  }

  Future<List<String>?> getEmailPasswd() async {
    final encrypter = Encrypter(AES(key));
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("login");
    if (data == null) return null;
    final decrypt = encrypter.decrypt(Encrypted.fromBase64(data), iv: iv);
    return decrypt.split("::");
  }

  Future inititalze() async {
    // print(await storeEmailPasswd("test@gmail.com", "123456"));
    print(await getEmailPasswd());
    return;
    // user = await auth.signInWithEmailAndPassword(email: login!.first, password: login.last);
    final token = await authApi.currentUser?.getIdToken();
    print(user?.user?.uid);
  }


}
/*
class DataManager {
  late final Database db;
  late final DatabaseFactory databaseFactory;

  Future initialize() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit(); // Init ffi loader if needed.
      databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    } else {
      final String databasesPath = await getDatabasesPath();
      final String path = join(databasesPath, 'data.db');
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('''CREATE TABLE MorningData ( id INTEGER PRIMARY KEY, addTime TEXT, comeTimeData TEXT, backTimeData TEXT, comeSerialData TEXT, backSerialData TEXT, comePassengerData TEXT, backPassengerData TEXT)''');
        await db.execute('''CREATE TABLE EveningData ( id INTEGER PRIMARY KEY, orderList TEXT, addTime TEXT, backSerialData TEXT, backPassengerData TEXT)''');
      });
    }
  }

  Future insertMorning({required List<CarData> data}) async {

    Map<String, String> 
      comeTimeData={}, backTimeData={},
      comeSerialData={}, backSerialData={},
      comePassengerData={}, backPassengerData={};

    for (CarData item in data) {
      comeTimeData.addAll({item.order.toString(): item.time.morning??"-1"});
      backTimeData.addAll({item.order.toString(): item.time.evening??"-1"});
      comeSerialData.addAll({item.order.toString(): item.serial.morning.toString()});
      backSerialData.addAll({item.order.toString(): item.serial.evening.toString()});
      comePassengerData.addAll({item.order.toString(): jsonEncode(item.passenger.come)});
      backPassengerData.addAll({item.order.toString(): jsonEncode(item.passenger.back)});
    }

    await db.insert('MorningData', <String, Object?>{
      'addTime': data.first.addTime.toIso8601String(),
      'comeTimeData': jsonEncode(comeTimeData),
      'backTimeData': jsonEncode(backTimeData),
      'comeSerialData': jsonEncode(comeSerialData),
      'backSerialData': jsonEncode(backSerialData),
      'comePassengerData': jsonEncode(comePassengerData),
      'backPassengerData': jsonEncode(backPassengerData)
    });
  }

  Future<List<Map<String, Object?>>> fetchMorning() async {
    return await db.query('MorningData');
  }

  List<CarData> convertMorningCarData(Map<String, Object?> data) 
    => MorningToCarData().convert(data);

  Future deleteMorning(int id) async {
    await db.delete('MorningData', where: 'id = $id');
  }

  Future deleteAllMorning() async {
    await db.execute('delete from MorningData');
  }

  Future insertEvening({required List<CarData> data}) async {
    Map<String, String> 
      backSerialData={},
      backPassengerData={};

    for (CarData item in data) {
      backSerialData.addAll({item.order.toString(): item.serial.evening.toString()});
      backPassengerData.addAll({item.order.toString(): jsonEncode(item.passenger.back)});
    }

    await db.insert('EveningData', <String, Object?>{
      'addTime': data.first.addTime.toIso8601String(),
      'orderList': jsonEncode(data.first.orderList),
      'backSerialData': jsonEncode(backSerialData),
      'backPassengerData': jsonEncode(backPassengerData)
    });
  }

  Future<List<Map<String, Object?>>> fetchEvening() async {
    return await db.query('EveningData');
  }

  List<CarData> convertEveningCarData(Map<String, Object?> data) 
    => EveningToCarData().convert(data);

  Future deleteEvening(int id) async {
    await db.delete('EveningData', where: 'id = $id');
  }

  Future deleteAllEvening() async {
    await db.execute('delete from EveningData');
  }

  Future dispose() async {
    await db.close();
  }
}

class MorningToCarData {
  List<int> getOrders(Object? context) => 
    (jsonDecode(context as String) as Map<String, dynamic>).keys.map((key) => int.parse(key)).toList();
  
  Map<String, dynamic> getValue(Object? context) =>
    (jsonDecode(context as String) as Map<String, dynamic>);

  List<String> getPassenger(String context) {
    final List<dynamic>? list = json.decode(context);
    if (list == null) return []; 
    return list.cast<String>().toList();
  }

  List<int> fetchAllIndex(Map<String, Object?> context) {
    final List<int> result = 
    getOrders(context['comeTimeData']) +
    getOrders(context['backTimeData']) +
    getOrders(context['comeSerialData']) +
    getOrders(context['backSerialData']) +
    getOrders(context['comePassengerData']) +
    getOrders(context['backPassengerData']);

    return result.toSet().toList();
  }

  List<CarData> convert(Map<String, Object?> data) {
    
    final allIndex = fetchAllIndex(data);

    return allIndex.map((int index) => 
      CarData.fromMorningDB(
        order: index,
        comeSerialData: int.tryParse(getValue(data['comeSerialData'])['$index']),
        backSerialData: int.tryParse(getValue(data['backSerialData'])['$index']),
        comeTimeData: getValue(data['comeTimeData'])['$index'],
        backTimeData: getValue(data['backTimeData'])['$index'],
        comePassengerData: getPassenger(getValue(data['comePassengerData'])['$index']),
        backPassengerData: getPassenger(getValue(data['backPassengerData'])['$index']),
        addTime: DateTime.parse(data['addTime'] as String)
      )
    ).toList();
  }
}

class EveningToCarData {
  List<int> getOrders(Object? context) => 
    (jsonDecode(context as String) as Map<String, dynamic>).keys.map((key) => int.parse(key)).toList();

  Map<String, dynamic> getValue(Object? context) =>
    (jsonDecode(context as String) as Map<String, dynamic>);
  
  List<String> getPassenger(String context) {
    final List<dynamic>? list = json.decode(context);
    if (list == null) return []; 
    return list.cast<String>().toList();
  }

  List<CarData> convert(Map<String, Object?> data) {
    final orderList = (jsonDecode(data['orderList'] as String) as List).map((e) => int.parse('$e')).toList();
    
    return orderList.map((int index) => 
      CarData.fromEveningDB(
        order: index,
        backSerialData: int.tryParse(getValue(data['backSerialData'])['$index']),
        backPassengerData: getPassenger(getValue(data['backPassengerData'])['$index']),
        addTime: DateTime.parse(data['addTime'] as String)
      )
    ).toList();
  } 
}

DataManager dbManager = DataManager();*/