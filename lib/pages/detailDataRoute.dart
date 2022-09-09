import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_line_message_converter/dataManager.dart';
import 'package:flutter_line_message_converter/gsheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_line_message_converter/provider/themeProvider.dart';

List<Widget> GetWidgetList (Map dataBase, var context) {
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
    detailList = GetWidgetList(dataBase, context);
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
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                        child: Center(child: Text('詳細資訊', style: Theme.of(context).textTheme.titleLarge),)
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 16, 0, 10),
                  child: Material(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    color: Theme.of(context).inputDecorationTheme.fillColor,
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
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              alignment: Alignment.bottomCenter,
              child: Hero(
                  tag: 'tag-${widget.fileName[1]}-${widget.fileName[2]}-${widget.fileName[3]}-${widget.fileName[4]}-${widget.fileName[0]}-',
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: InkWell(
                      child: Stack(
                        children: [
                          Ink.image(
                            image: (widget.fileName[4] == 'am') ? const AssetImage('assets/img_breakfast.jpg') : const AssetImage('assets/img_cyclingbmx.jpg'),
                            height: (MediaQuery.of(context).size.width - 20) * 250 / 1010,
                            width: MediaQuery.of(context).size.width - 20,
                            fit: BoxFit.fill,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              '${widget.fileName[0]}年${widget.fileName[1]}月${widget.fileName[2]}日 (${weekString[int.parse(widget.fileName[3])]})',
                              style: Theme.of(context).textTheme.titleSmall,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(55, 35, 10, 0),
                            child: Text((widget.fileName[4] == 'am') ? '早班車' : '晚班車', style: Theme.of(context).textTheme.titleLarge,),
                          )
                        ],
                      )
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
