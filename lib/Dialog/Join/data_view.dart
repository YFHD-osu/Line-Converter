import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart' as sheet_lib;

import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Library/gsheet.dart';
import 'package:line_converter/Library/data_manager.dart';
import 'package:line_converter/Dialog/Join/flat_button.dart';
import 'package:line_converter/Dialog/Join/top_button_view.dart';

Widget preview(BuildContext context, List<CarData> result) {
  return StatefulBuilder(
    builder: ((context, setState) {
      return DataView(result: result);
    }) 
  );
}

class PersonView extends StatefulWidget {
  const PersonView({
    super.key,
    required this.title,
    required this.passenger
  });

  final String title;
  final List<String>? passenger; 

  @override
  State<PersonView> createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {

  Widget textBox(String title) =>
    Container(
      padding: const EdgeInsets.fromLTRB(4, 1, 4, 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Text(title, 
        style: const TextStyle(
          height: 0,
          fontSize: 24,
          fontWeight: FontWeight.normal
        )
      )
    );
  

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    if (widget.passenger == null) { return Container(); }

    return Row(
      children: [
        textBox(widget.title),
        const SizedBox(width: 5),
        SizedBox(
          height: 40, width: width - 151,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.passenger!.length,
            itemBuilder: (BuildContext context, int index) =>
              textBox(widget.passenger![index]),
            separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 5)
          )
        )
      ],
    );
  }
}

class DataView extends StatefulWidget {
  const DataView({
    super.key,
    required this.result
  });

  final List<CarData> result;

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView>{
 
  final driveController = FlatButtonController();
  final localController = FlatButtonController();

  Future<void> uploadDrive() async {
    driveController.result = Result.loading;

    final sheetAPI = GSheet();
    

    await sheetAPI.initialize();
    final sheet = await sheetAPI.sheetByName();
    if (sheet == null) {
      setState(() => driveController.result = Result.failed);
      return;
    }

    final clearRange = sheet_lib.GridRange(
      startColumnIndex: 0,
      startRowIndex: 0,
      endColumnIndex: 6,
      endRowIndex: (widget.result.length/3).ceil()*4+1,
      sheetId: sheet.properties!.sheetId
    );

    await sheetAPI.resetSheet(sheet, clearRange);
    await sheetAPI.uploadSheet(sheet, widget.result);
    driveController.result = Result.success;
    if (mounted) setState(() {});
  }

  Future<void> saveToLocal() async {
    localController.result = Result.loading;
    try {
      if (widget.result.first.type == MessageType.morning) {
        await dbManager.insertMorning(data: widget.result);
      } else {
        await dbManager.insertEvening(data: widget.result);
      }
      
    } catch(error) {
      localController.result = Result.failed;
    } finally {
      localController.result = Result.success;
    }
    
    if (mounted) setState(() {});
  }

  Card getMorningCard(CarData index) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 15, right: 10),
      leading: const Icon(Icons.people),
      title: Text("第${index.order}車", style: const TextStyle(fontSize: 20)),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PersonView(title: '早', passenger: index.passenger.morning),
          // const SizedBox(height: 5),
          // PersonView(title: '晚', passenger: index.passenger.evening)
        ]
      )
    )
  );

  Card getEveningCard(CarData index) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.only(left: 15, right: 10),
      leading: const Icon(Icons.people),
      title: Text("第${index.order}車", style: const TextStyle(fontSize: 20)),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PersonView(title: '早', passenger: index.passenger.morning),
          // const SizedBox(height: 5),
          PersonView(title: '晚', passenger: index.passenger.evening)
        ]
      )
    )
  );

  CarData? dataByOrder(int order) {
    for (CarData item in widget.result) {
      if (item.order == order) return item; 
    }
    
    return null;
  }

  List<Widget> getCards() {
    List<CarData> list = [];
    if (widget.result.first.type == MessageType.evening) {
      for (int order in widget.result.first.orderList) {
        list.add(dataByOrder(order)??CarData());
      }
    } else {list = widget.result;}

    return list.map((CarData index) {
      if (widget.result.first.type == MessageType.morning) {
        return getMorningCard(index);
      } else {
        return getEveningCard(index);
      }
    }).toList();
  }

  void Function()? getConfirm() {
    if (localController.result == Result.loading ||
        localController.result == Result.success ||
        driveController.result == Result.success ||
        driveController.result == Result.loading
    ) return null;

    if (!localController.value && 
        !driveController.value ) return null;

    return () async {
      if (localController.value) saveToLocal();
      if (driveController.value) {
        try{
          await uploadDrive();
        } catch (_) {
          driveController.result = Result.failed;
        }
      }
      setState(() => {});
    };
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopButtonRow(
          context: context,
          title: '轉換成功',
          confirmText: '執行',
          cancel: () => Navigator.of(context).pop(),
          confirm: getConfirm()
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(builder: (context, constraint) {
            final maxWidth = constraint.biggest.width;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: (maxWidth-10)/2, width: (maxWidth-10)/2,
                  child: FlatButton(
                    icon: Icons.save,
                    text: '儲存至本機',
                    controller: localController,
                    opTap: () => setState(() {})
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: (maxWidth-10)/2, width: (maxWidth-10)/2,
                  child: FlatButton(
                    text: '上傳至雲端',
                    icon: Icons.cloud_upload,
                    controller: driveController,
                    opTap: () => setState(() {})
                  ),
                )
              ]
            );
          }),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(15)
              ),
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: getCards()
              )
            )
          )
        )
      ]
    );
  }
}