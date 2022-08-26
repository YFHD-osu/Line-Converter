import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:async/async.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _getFile (String floder ,String filename) async {
  final path = await _localPath;
  return File('$path/$floder/$filename.txt');
}

void writeData (Map dataBase) async {
  var file;

  if (dataBase['carOrder'] == null){final file = await _getFile('morningData', 'asd');}
  else{ final file = await _getFile('afternoonData', 'asd');}

  file.writeAsString(json.encode(dataBase));
}
Future<int> readCounter(String floder, String filename) async {
  try {
    final file = await await _getFile(floder, filename);
    // Read the file
    final contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0
    return 0;
  }
}

void listFiles() async {
  final dir = Directory(await _localPath);
  final List<FileSystemEntity> entities = await dir.list().toList();
  print(entities);
}



Future<String?> _myFuture() async {
  await Future.delayed(const Duration(seconds: 5));
  return 'Future completed';
}

// keep a reference to CancelableOperation
CancelableOperation? _myCancelableFuture;

// This is the result returned by the future
String? _text;

// Help you know whether the app is "loading" or not
bool _isLoading = false;

// This function is called when the "start" button is pressed
void _getData() async {
    _isLoading = true;
    _myCancelableFuture = CancelableOperation.fromFuture(_myFuture(), onCancel: () => 'Future has been canceld',
  );

  final value = await _myCancelableFuture?.value;
  // update the UI
    _text = value;
    _isLoading = false;
}

// this function is called when the "cancel" button is tapped
void _cancelFuture() async {
  final result = await _myCancelableFuture?.cancel();
  _text = result;
  _isLoading = false;
}