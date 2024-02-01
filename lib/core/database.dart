import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:line_converter/core/typing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:line_converter/core/extension.dart';

class PrefsCache extends ChangeNotifier{
  String sheetTitle, credential, sheetID, highlight;

  String? get clientEmail => jsonDecode(credential)["client_email"] as String?;

  PrefsCache({
    required this.credential,
    required this.sheetTitle,
    required this.sheetID,
    required this.highlight
  });

  factory PrefsCache.fromMap(Map res) {
    return PrefsCache(
      sheetTitle: res["sheet"]?["sheetTitle"]??"",
      credential: res["sheet"]?["credential"]??"",
      sheetID:  res["sheet"]?["sheetID"]??"",
      highlight: res["sheet"]?["highlight"]??"",
    );
  }

  PrefsCache setMap(Map res) {
    sheetTitle= res["sheet"]?["sheetTitle"]??"";
    credential= res["sheet"]?["credential"]??"";
    sheetID= res["sheet"]?["sheetID"]??"";
    highlight = res["sheet"]?["highlight"]??"";
    notifyListeners();
    return this;
  }

  Map<String, dynamic> toMap() {
    return {
      "sheetTitle": sheetTitle,
      "credential": credential,
      "sheetID": sheetID,
      "highlight": highlight
    };
  }
}

class AuthResponse {
  final bool success;
  final String? description;

  AuthResponse({required this.success, this.description});
}

class DataDocs {
  final int id;
  final List<CarData> data;
  final DateTime timestamps;

  DataDocs({required this.id, required this.data, required this.timestamps});
  
  factory DataDocs.fromMap(Map res) {
    final result = DataDocs(
      id: res["id"],
      data: (jsonDecode(res["data"]) as List).map((e) => CarData.fromMap(e)).toList(),
      timestamps: DateTime.fromMillisecondsSinceEpoch(res["timestamp"])
    );
    return result;
  }
}

class FireStore {
  FireStore._();
  static FireStore? _instance;
  static FireStore get instance {
    _instance ??= FireStore._();
    return _instance!;
  }

  PrefsCache prefs = PrefsCache.fromMap({});
  CollectionReference? _ref;
  UserCredential? _credential;

  final authApi = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  late final Box _box;

  bool get loggedIn => !(_credential == null || _ref == null);
  String? get username => _credential?.user?.displayName;
  String? get email => _credential?.user?.email;
  String get imageUrl => _credential?.user?.photoURL??"https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg";

  Future<void> storeEmailPasswd(String email, String passwd) async {
    await _box.put("secret", "$email::$passwd");
  }

  Future<List<String>?> getEmailPasswd() async =>
    (await _box.get("secret") as String?)?.split("::");

  Future inititalze() async {
    final property = await DeviceInfoPlugin().getMap();
    _box = await Hive.openBox('login', 
      encryptionCipher: HiveAesCipher(property.values.join("%").codeUnits.sublist(1, 33)));
    final lastStored = await getEmailPasswd();
    if (lastStored?.isNotEmpty??false) {
      await login(lastStored!.first, lastStored.last, false);
    }
    return;
  }

  Future<AuthResponse> login(String email, String passwd, bool saveInfo) async {
    final emailExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailExp.hasMatch(email)) return AuthResponse(success: false, description: "帳號為無效的電子郵件信箱");
    if (passwd.length < 6 || passwd.isEmpty) return AuthResponse(success: false, description: "帳號或密碼有誤");
    try {
      _credential = await authApi.signInWithEmailAndPassword(email: email, password: passwd);
    } on Exception catch (e) {
      return AuthResponse(success: false, description: e.toString());
    }
    try {
      final ref = FirebaseFirestore.instance.collection("userdata");
      await ref.doc(_credential!.user!.uid).get();
      if (saveInfo) storeEmailPasswd(email, passwd);
      _ref = ref;
    } catch (e) {
      return AuthResponse(success: false, description: e.toString());
    }
    getPrefs();
    // print(querySnapshot);
    return AuthResponse(success: true);
  }

  Future<AuthResponse> register(
    String username,
    String email,
    String passwd,
    String? photoUrl,
    bool? saveInfo
  ) async {
    final emailExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (username.isEmpty) return AuthResponse(success: false, description: "使用者名稱不可為空");
    if (!emailExp.hasMatch(email)) return AuthResponse(success: false, description: "帳號為無效的電子郵件信箱");
    if (passwd.length < 6) return AuthResponse(success: false, description: "密碼至少為6位元的字串");
    try {
      _credential = await authApi.createUserWithEmailAndPassword(email: email, password: passwd);
      _credential!.user!.updateDisplayName(username);
    } catch (e) {
      final description = e.toString();
      if (description.contains("email-already-in-use")) {
        return AuthResponse(success: false, description: "電子郵件已經被註冊過了");
      } else if (description.contains("missing-password")) {
        return AuthResponse(success: false, description: "請提供密碼");
      } else if (description.contains("weak-password")) {
        return AuthResponse(success: false, description: "密碼至少包含六位元以上");
      }
      return AuthResponse(success: false, description: e.toString());
    }

    return login(email, passwd, saveInfo??false);    
  }

  Future addData(List<CarData> context) async {
    if (!loggedIn) return;
    final data = jsonEncode(context.map((e) => e.toMap()).toList());
    final root = _ref!.doc(_credential!.user!.uid);

    final type = context.first.type.name;
    final loaded = await root.collection(type).get();
    final lastId = loaded.docs.isEmpty ? 0 : loaded.docs.last.data()["id"]+1??0;
    await root.collection(type).doc("$lastId").set({
      "data": data,
      "id": lastId,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<List<DataDocs>> getData(MessageType type) async {
    if (!loggedIn) return [];
    final root = _ref!.doc(_credential!.user!.uid);
    final response = await root.collection(type.name).get();
    final docsList = response.docs;
    final jsonList = docsList.map((docs) => docs.data()).toList();
    return jsonList.map((docs) => DataDocs.fromMap(docs)).toList().reversed.toList();
  }

  Future<PrefsCache> getPrefs() async {
    if (!loggedIn) throw Exception("NOT LOGGINED");
    final root = _ref!.doc(_credential!.user!.uid);
    final response = await root.collection("prefs").get();
    var dataMap = { for (var e in response.docs) e.id: e.data() };
    
    return prefs.setMap(dataMap);
  }

  Future setPrefs(PrefsCache? prefs) async {
    if (!loggedIn) return;
    final root = _ref!.doc(_credential!.user!.uid);
    return await root.collection("prefs").doc("sheet").set((prefs??this.prefs).toMap());
  }

  Future<void> logout() async {
    _ref = null;
    _credential = null;
    await _box.delete("secret");
    await authApi.signOut();
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