import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import '../Library/DataManager.dart';

const List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];
WidgetsToImageController controller = WidgetsToImageController();
Uint8List? bytes;

class ContainerInfo {
 late Size size;
 late ThemeData theme;

 ContainerInfo(Size deviceSize, ThemeData themeData) {
   size = deviceSize;
   theme = themeData;
 }
}

Future<String> getHighlightName () async {
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  return await encryptedSharedPreferences.getString('highlightName');
}

List<Widget> getWidgetList (Map dataBase, String highlightName, ContainerInfo info) {
  List<Widget> previewData = [];
  List<dynamic> carOrder = [];

  if(dataBase['carOrder'] == null){
    for (int i=1; i<= dataBase.length; i++){
      carOrder.add(i);
    }
  }else {carOrder = dataBase['carOrder'];}

  for(int i=0; i<carOrder.length; i++){
    String key = carOrder[i].toString();

  previewData.add(
    Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: info.size.width - 20,
      decoration: BoxDecoration(
        color: info.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
        height: 95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  decoration: BoxDecoration(
                    color: info.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(' 車次: $key ', style: info.theme.textTheme.labelLarge,),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  decoration: BoxDecoration(
                    color: info.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(' 代碼: ${dataBase[key]['carID']} ', style: info.theme.textTheme.labelLarge,),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row( //Generate passengers name in every container
                  children: [for (String passenger in dataBase[key]['person']) Visibility(
                    visible: passenger != "---",
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: info.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(' $passenger ', style: TextStyle(
                          color: highlightName.contains(passenger) ? Colors.green[500] : info.theme.textTheme.labelLarge?.color,
                          fontSize: info.theme.textTheme.labelLarge?.fontSize)
                      )
                    )
                  )
                ]
              ),
            )
          )
        ],
      ),
    )
  )
);
  }
  return previewData;
}

class DetailDataRoute extends StatefulWidget {
  const DetailDataRoute({Key? key, required this.fileName} ) : super(key: key);

  final List fileName;

  @override
  State<DetailDataRoute> createState() => _DetailDataRouteState();
}

class _DetailDataRouteState extends State<DetailDataRoute> {
  late String highlightName;
  late List<Widget> detailList = [];
  Map dataBase = {};

  @override
  void initState() {
    super.initState();
    _getFile();
  }

  _getFile() async{
    String dataBaseString = await readFile('carDatas', '${widget.fileName[0].toString()}-${widget.fileName[1].toString()}-${widget.fileName[2].toString()}-${widget.fileName[3]}-${widget.fileName[4].toString()}-');
    dataBase = json.decode(dataBaseString);
    highlightName = await getHighlightName();
    detailList = getWidgetList(dataBase, highlightName, ContainerInfo(MediaQuery.of(context).size, Theme.of(context)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  alignment: Alignment.bottomCenter,
                  child: Hero(
                    tag: 'tag-${widget.fileName[1]}-${widget.fileName[2]}-${widget.fileName[3]}-${widget.fileName[4]}-${widget.fileName[0]}-',
                    child: Material(
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                          child: SingleChildScrollView(
                            child: Stack(
                              children: [
                                ClipRRect( // Clip it cleanly.
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.1),
                                      alignment: Alignment.center,
                                      child: Ink.image(
                                        image: (widget.fileName[4] == 'am') ? const AssetImage('assets/img_breakfast.jpg') : const AssetImage('assets/img_cyclingbmx.jpg'),
                                        height: 60,
                                        width: MediaQuery.of(context).size.width - 20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(child: Text('詳細資訊', style: Theme.of(context).textTheme.titleLarge))
                              ],
                            ),
                          )
                      ),
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 16, 0, 10),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    color: Colors.redAccent.withOpacity(0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded)
                    ),
                  )
                )
              ],
            ),
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 226,
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  borderRadius: BorderRadius.circular(15),
                  child: SingleChildScrollView(
                    child: WidgetsToImage(
                      controller: controller,
                      child: Column(children: detailList)
                    )
                  )
                )
              )
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: () {
              setState(() {});
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.visibility),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () async {
              final directory = await getApplicationDocumentsDirectory();
              final bytes = await controller.capture();
              final dir = Directory('${directory.path}/cache/');
              if ((await dir.exists()) == false) { await dir.create(recursive: true); }
              await File('${directory.path}/cache/screenshots.jpg').writeAsBytes(bytes!);
              await Share.shareXFiles([XFile('${directory.path}/cache/screenshots.jpg')], text: 'Image Shared');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.camera_alt_rounded),
          )
        ],
      )
    );
  }
}


