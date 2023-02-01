import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _getFile (String folder ,String filename) async {
  final dir = Directory('${await _localPath}/$folder');
  if ((await dir.exists()) == false) { await dir.create(recursive: true); }
  final path = await _localPath;
  return File('$path/$folder/$filename');
}

void writeFile (Map dataBase) async {
  DateTime now = DateTime.now();

  var file;
  if (dataBase['carOrder'] == null){
    now = now.add(const Duration(days: 1));
    String dateString = '${now.year}-${now.month}-${now.day}-${now.weekday}-am-';
    file = await _getFile('carDatas', dateString);
  }
  else{
    String dateString = '${now.year}-${now.month}-${now.day}-${now.weekday}-pm-';
    file = await _getFile('carDatas', dateString);
  }

  file.writeAsString(json.encode(dataBase));
}

Future<List> listFiles(String folder) async {
  final dir = Directory('${await _localPath}/$folder');
  if ((await dir.exists()) == false) { await dir.create(recursive: true); }
  final List<FileSystemEntity> entities = await dir.list().toList();
  return(entities);
}

Future<String> readFile(String folder, String filename) async {
  try {
    final file = await _getFile(folder, filename);
    final contents = await file.readAsString();
    return contents;
  } catch (e) {
    return '';
  }
}

void deleteFile(String folder, String filename) async {
  final file = await _getFile(folder, filename);
  await file.delete();
}

Map<String, int> dirStatSync(String dirPath) {
  int fileNum = 0;
  int totalSize = 0;
  var dir = Directory(dirPath);
  try {
    if (dir.existsSync()) {
      dir.listSync(recursive: true, followLinks: false)
          .forEach((FileSystemEntity entity) {
        if (entity is File) {
          fileNum++;
          totalSize += entity.lengthSync();
        }
      });
    }
  } catch (e) {
    print(e.toString());
  }

  return {'fileNum': fileNum, 'size': totalSize};
}

void deleteFloder (String folder) async {
  final dir = Directory('${await _localPath}/$folder');
  dir.deleteSync(recursive: true);
}