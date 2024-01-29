import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart' as sheet_lib;

import 'package:line_converter/core/typing.dart';
import 'package:line_converter/core/parser.dart';
import 'package:line_converter/core/gsheet.dart';

class DataViewDialog {
  late final BuildContext context;
  late final TextEditingController person;
  late final TextEditingController car;

  late List<CarData> result;
  late List<ParseException> errors;

  bool isProcessing = false;

  DataViewDialog({
    required this.context,
    required this.person,
    required this.car
  });

  Widget _error(BuildContext context, List<ParseException> errors) { 
    final mediaQuery = MediaQuery.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TopButtonRow(
          cancel: () => Navigator.of(context).pop(),
          confirm: null,
          context: context,
          title: '轉換時發生錯誤'
        ),
        SizedBox(
          width: mediaQuery.size.width,
          child: Row(
            children: [
              const Icon(Icons.error, size: 100),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: const <TextSpan>[
                    TextSpan(text: '轉換過程中發生以下錯誤\n', style: TextStyle(fontSize: 30)),
                    TextSpan(text: '請依提示訊息修正後再重新轉換', style: TextStyle(fontSize: 20)),
                  ]
                )
              )
            ],
          )
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: errors.map((ParseException index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 5, right: 5),
                      leading: FlutterLogo(),
                      title: Text(index.message),
                      subtitle: Text(index.description)
                    )
                  )
                );
              }).toList()
            )
          )
        )
      ]
    );
  }

  Widget _empty(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      TopButtonRow(
        cancel: () => Navigator.of(context).pop(),
        confirm: null,
        context: context,
        title: '轉換失敗'
      ),
      const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.all_inbox_outlined, size: 300),
              Text('空空如也'),
              Text('未發現任何可轉換的訊息')
            ]
          )
        )
      )
    ]
  );

  Widget build(BuildContext context) {
    if (result.isEmpty) return _empty(context);

    if (errors.isNotEmpty) return _error(context, errors);

    return DataView(result: result);

  }

  Future parse() async {
    final data = MainPraser(personMessage: person.text, carIDMessage: car.text);
    late final List<CarData> result;
    late final List<ParseException> errors;
    (result, errors) = data.parse();
    this.result = result;
    this.errors = errors;
  
    return await show();
  }

  Future<void> show() async =>
    await showModalBottomSheet(
      context: context,
      enableDrag: !isProcessing,
      useSafeArea: true,
      isDismissible: !isProcessing,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (context) => DraggableScrollableSheet(
        snap: false,
        expand: false,
        maxChildSize: 0.89,
        minChildSize: 0.89,
        initialChildSize: 0.89,
        builder: (context, scrollController) => build(context)
      )
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
        //TODO: await dbManager.insertMorning(data: widget.result);
      } else {
        // TODO: await dbManager.insertEvening(data: widget.result);
  
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
          PersonView(title: '早', passenger: index.passenger.come),
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
          PersonView(title: '晚', passenger: index.passenger.back)
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
        final data = dataByOrder(order);
        if (data!=null) list.add(data);
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

enum Result {never, failed, success, loading}

class FlatButtonController {
  bool value = false;
  Result result = Result.never;

}

class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.icon,
    required this.text,
    required this.opTap,
    required this.controller
  });

  final String text;
  final IconData icon;
  final FlatButtonController controller;
  final VoidCallback? opTap;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {

  Color getBorderColor() {
    if (widget.controller.result != Result.never &&
        widget.controller.result != Result.loading
    ) return Colors.transparent;
    return (widget.controller.value) ? Colors.green : Colors.transparent;
  } 

  Color? getBackground() {
    switch(widget.controller.result) {
      case Result.never: return null;
      case Result.loading: return null;
      case Result.failed: return Colors.red;
      case Result.success: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            onTap: (widget.controller.result != Result.never) ? null : () {
              setState(() => widget.controller.value = !widget.controller.value);
              widget.opTap?.call();
            },
            child: AnimatedContainer(
              height: double.infinity, width: double.infinity,
              padding: const EdgeInsets.all(5),
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: getBackground(),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: getBorderColor(), width: 4
                )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Icon(widget.icon, size: constraint.biggest.height);
                    })
                  ),
                  Text(widget.text)
                ]
              )
            )
          ),
          Visibility(
            visible: widget.controller.result == Result.loading,
            child: const SizedBox(
              height: 5, width: double.infinity,
              child: LinearProgressIndicator(),
            )
          )
        ]
      )
    );
  }
}

class TopButtonRow extends Container{

  TopButtonRow({
    super.key,
    required BuildContext context,
    required void Function()? cancel,
    required void Function()? confirm, 
    required String title,
    String confirmText = '確認',
    String cancelText = '取消',
  }) : super (
    padding: const EdgeInsets.all(5),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)
      ) 
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 5),
        TextButton(
          onPressed: cancel,
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent) 
          ),
          child: Text(cancelText, style: const TextStyle(fontSize: 20))
        ),
        const Spacer(),
        Text(title, style: const TextStyle(fontSize: 25)),
        const Spacer(),
        TextButton(
          onPressed: confirm,
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.transparent) 
          ),
          child: Text(confirmText, style: const TextStyle(fontSize: 20))
        ),
        const SizedBox(width: 5)
      ]
    )
  );
}