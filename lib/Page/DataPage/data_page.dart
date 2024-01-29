import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';

import 'package:line_converter/page/DataPage/mode_switch.dart';
import 'package:line_converter/page/DataPage/dismissable_list_view.dart';

ShowType tempVal = ShowType.morning;
const List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  bool listIsReady = false;
  List<Map<String, Object?>> eveningItems = [];
  List<Map<String, Object?>> morningItems = [];
  final PageController controller = PageController(initialPage: tempVal.index);
  final GlobalKey<ModeSwitchState> switchKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() async {
    morningItems.clear();
    setState(() => listIsReady = false);

    /* TODO
    morningItems = (await dbManager.fetchMorning()).reversed.toList();
    eveningItems = (await dbManager.fetchEvening()).reversed.toList();
    */
    
    setState(() => listIsReady = true);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              //morningItems.isEmpty && listIsReady ? const NoIndex() :
              DismissableListView(
                items: morningItems,
                showType: ShowType.morning,
                onDismissed: () => setState(() {})
              ),
              //eveningItems.isEmpty && listIsReady ? const NoIndex() :
              DismissableListView(
                items: eveningItems,
                showType: ShowType.evening,
                onDismissed: () => setState(() {})
              )
            ]
          )
        )
      ]
    );
  }
}