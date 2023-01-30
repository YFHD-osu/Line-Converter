import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../Library/DataManager.dart';

import 'dart:ui';

Future<String> GetHighlightName () async {
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  return await encryptedSharedPreferences.getString('highlightName');
}

List<Widget> GetPassengerName (List<dynamic> passengers,String HighlightName, var context){

  List<Widget> passengerContainer = [];
  for (int i=0; i<passengers.length; i++){
    if (passengers[i] != "---"){
      passengerContainer.add(
        Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(' ${passengers[i]} ', style: TextStyle(
            color: (HighlightName.contains(passengers[i])) ? Colors.green[500] : Theme.of(context).textTheme.labelLarge?.color,
            fontSize: Theme.of(context).textTheme.labelLarge?.fontSize
          ),
        ),
      )
    );
  }
}

  return passengerContainer;
}

List<Widget> GetWidgetList (Map dataBase, String highlightName, var context) {
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
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(' 車次: $key ', style: Theme.of(context).textTheme.labelLarge,),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(' 代碼: ${dataBase[key]['carID']} ', style: Theme.of(context).textTheme.labelLarge,),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: GetPassengerName(dataBase[key]['person'], highlightName, context),
                  )
                )
              )
            ],

          ),
        )
      )
      /*
      Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              child: Text('|$key車| ${dataBase[key]['carID']} ', style: Theme.of(context).textTheme.labelLarge),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(15, 10, 5, 0),
            ),
            Container(
              child: Text('|乘客| ${dataBase[key]['person']}', style: Theme.of(context).textTheme.labelMedium),
              alignment: Alignment.topLeft,
              margin: EdgeInsets.fromLTRB(15, 0, 5, 10),
            ),
          ],
        ),
      )
      */
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
  var HighlightName;
  final List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];
  List<Widget> detailList = [];
  Map dataBase = {};

  @override
  void initState() {
    super.initState();
    _getFile();
  }

  _getFile() async{
    String dataBaseString = await readFile('carDatas', '${widget.fileName[0].toString()}-${widget.fileName[1].toString()}-${widget.fileName[2].toString()}-${widget.fileName[3]}-${widget.fileName[4].toString()}-');
    dataBase = json.decode(dataBaseString);
    HighlightName = await GetHighlightName();
    detailList = GetWidgetList(dataBase, HighlightName, context);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0
      ),
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
                  margin: EdgeInsets.fromLTRB(15, 16, 0, 10),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    color: Colors.redAccent.withOpacity(0),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded)
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
                    child: Column(
                        children: detailList
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
