import 'package:flutter/material.dart';
import '../Route/DetailData.dart';
import '../Library/DataManager.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];
  var _items = [];
  bool _listIsReady = false;

  @override
  void initState() {
    super.initState();
    _updateList();
  }

  _updateList() async {
    var tmpList = await listFiles('carDatas');
    for (int i = 0; i < tmpList.length; i++) {
      List processList = tmpList[i].path.split('/').last.split('-');

      _items.insert(i, [processList[0], processList[1], processList[2], processList[3], processList[4]]);
      _key.currentState!.insertItem(i, duration: const Duration(milliseconds:100));
    }
    setState(() {
      _listIsReady = (_items.isEmpty) ? true : false;
    });

  }

  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _removeItem(int index) {
    List tmpList = _items[index];
    deleteFile('carDatas', '${tmpList[0]}-${tmpList[1]}-${tmpList[2]}-${tmpList[3]}-${tmpList[4]}-');
    _key.currentState!.removeItem(index, (_, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: const Card(
          margin: EdgeInsets.all(10),
          elevation: 10,
          color: Colors.red,
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text("刪除", style: TextStyle(fontSize: 24)),
          ),
        ),
      );
    }, duration: const Duration(milliseconds: 500));
    _items.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0
      ),
      body: Stack(
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              height: 60,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Text('本機檔案', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
              )
          ),
          _listIsReady ? Center(child: Text('尚無資料', style: Theme.of(context).textTheme.labelMedium,),) :
          Container(
            margin: const EdgeInsets.fromLTRB(10, 80, 10, 0),
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(15),
              child: AnimatedList(
                key: _key,
                initialItemCount: 0,
                itemBuilder: (_, index, animation) {
                  return SizeTransition(
                    key: UniqueKey(),
                    sizeFactor: animation,
                    child: Column(
                      children: [
                        Hero(
                          tag: 'tag-${_items[index][1]}-${_items[index][2]}-${_items[index][3]}-${_items[index][4]}-${_items[index][0]}-',
                          child: SingleChildScrollView(
                            child: Material(
                              borderRadius: BorderRadius.circular(15),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => DetailDataRoute(fileName: _items[index])));
                                    },
                                    onLongPress: () { _removeItem(index); },
                                    child: Stack(
                                      children: [
                                        Ink.image(
                                          image: (_items[index][4] == 'am') ? const AssetImage('assets/img_breakfast.jpg') : const AssetImage('assets/img_cyclingbmx.jpg'),
                                          height: (MediaQuery.of(context).size.width - 20) * 250 / 1010,
                                          width: MediaQuery.of(context).size.width - 20,
                                          fit: BoxFit.fill,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: Text(
                                            '${_items[index][0]}年${_items[index][1]}月${_items[index][2]}日 (${weekString[int.parse(_items[index][3])]})',
                                            style: Theme.of(context).textTheme.titleSmall,),
                                        ),
                                        Container(
                                          height: (MediaQuery.of(context).size.width - 20) * 250 / 1010 - 5,
                                          alignment: Alignment.bottomLeft,
                                          margin: const EdgeInsets.fromLTRB(35, 0, 0, 5),
                                          child: Text((_items[index][4] == 'am') ? '早班車' : '晚班車', style: Theme.of(context).textTheme.titleMedium,),
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              )
                            ),
                          )
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  );
                },
              ),
            )
          )
        ],
      )
    );
  }
}