import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/core/parser.dart';
import 'package:line_converter/core/typing.dart';
import 'package:line_converter/widgets.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({super.key});

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final parser = MainPraser();
  final controller = ExpansionTileController();
  final carIDText = TextEditingController(text: r"""
  1車24067
  2車25552
  3車上午88368
        下午14446
  4車上午24090
        下午25441
  5車上午24016
        下午88368
  6車上午14446
        下午24016
  7車上午25441
        下午24067
  8車上午25552
        下午14227
  9車下午25552
  """);
  final personText = TextEditingController(text: """
  1車來7:40
  義邦，玲嫥，彩玉，思瑩
  1車回
  月鳳，奮力，何巧，葉妹
  2車來7:20
  進城，夏枝，桂妹，廖萬
  2車回
  廖萬，夏枝，孟昇，志銘
  3車來7:45
  麗慧，李義雄，蘇珠，水盛
  3車回
  文輝，蕭碧霞，光永，秀鳳
  4車來7:40
  玉蘭，黃庚，雪鑾，蕭碧霞
  4車回
  桂妹，秀金，黃粉，進城
  5車來7:40
  宏輝，文輝，介淦
  5車回
  宏輝，雅雯，麗慧
  6車來7:50
  孟昇，柏宇，月鳳，何巧
  6車回
  李義雄，蘇珠，玉山，如山
  7車來7:50
  如山，玉山，秀金，黃粉
  7車回
  思瑩，淑純，豐美
  8車來8:15
  謝敏，奮力
  8車回
  黃庚，水盛，雪鑾
  9車回
  阿梅，玲嫥
  """);

  void _doParser(String value) {
    parser.parse(person: personText.text, carID: carIDText.text);
    if (parser.data.isNotEmpty && parser.error.isEmpty) {
      controller.collapse();
    }
    if(mounted) setState(() {});
  }
  
  Widget _appBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.background,
      backgroundColor: theme.colorScheme.background.withOpacity(0.75),
      titleSpacing: 0,
      leadingWidth: 50,
      title: const Text("加入資料"),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(color: Colors.transparent))
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _appBar(context)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            InputSection(
              timeText: personText,
              serialText: carIDText,
              controller: controller,
              onChanged: _doParser
            ),
            const SizedBox(height: 10),
            ResultSection(parser: parser),
            const SizedBox(height: 10)
          ]
        )
      )
    );
  }
}

class InputSection extends StatelessWidget {
  final TextEditingController timeText, serialText;
  
  final Function(String) onChanged;
  final ExpansionTileController controller;
  
  const InputSection({
    super.key, 
    required this.timeText, 
    required this.serialText, 
    required this.controller, 
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size.width / 2 - 25;

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.primaryContainer
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent
        ),
        child: ExpansionTile(
          controller: controller,
          initiallyExpanded: true,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          title: Row(
            children: [
              const Icon(Icons.keyboard, size: 35),
              Text(" 輸入資訊", style: theme.textTheme.bodyLarge)
            ]
          ),
          children: [
            Row(
              children: [
                SizedBox(
                  width: size, height: size,
                  child: TextBox(
                    hintText: "輸入車輛時間資訊",
                    heroTag: "timeCtrl",
                    controller: timeText,
                    haveToolButtons: false,
                    onChanged: onChanged,
                  )
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: size, height: size,
                  child: TextBox(
                    hintText: "輸入車輛代碼資訊",
                    heroTag: "serialCtrl",
                    controller: serialText,
                    haveToolButtons: false,
                    onChanged: onChanged
                  )
                )
              ]
            )
          ],
        )
      )
      /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.keyboard, size: 35),
              Text(" 輸入資訊")
            ]
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                width: size, height: size,
                child: TextBox(
                  hintText: "輸入車輛時間資訊",
                  heroTag: "timeCtrl",
                  controller: timeText,
                  haveToolButtons: false,
                )
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size, height: size,
                child: TextBox(
                  hintText: "輸入車輛代碼資訊",
                  heroTag: "serialCtrl",
                  controller: serialText,
                  haveToolButtons: false,
                )
              )
            ]
          )
        ]
      )*/
    );
  }
}

class DataCard extends StatelessWidget {
  final int visMode;
  final CarData data;
  final bool highlight;

  const DataCard({super.key, required this.data, this.visMode = 0, this.highlight = true});

  Widget _personView(BuildContext context, List<String>? passenger, bool isCome) {
    final theme = Theme.of(context);
    final hMembers = FireStore.instance.prefs.highlight;

    if (passenger == null) { return const SizedBox(); }

    return Row(
      children: [
        Icon(isCome ? Icons.sunny : Icons.bedtime),
        const SizedBox(width: 10),
        SizedBox(
          height: 34,
          child: Wrap(
            spacing: 5,
            children: passenger.map((e) => Container(
              padding: const EdgeInsets.fromLTRB(2.5, 2, 2.5, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Text(e, style: theme.textTheme.titleLarge?.copyWith(
                color: hMembers.contains(e) && highlight ? Colors.green : null
              ))
            )).toList()
          )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.inputDecorationTheme.fillColor!
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Icon(Icons.directions_car_rounded)]
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" 第${data.order}車", style: theme.textTheme.titleMedium),
              visMode<2 ? _personView(context, data.passenger.come, true) : const SizedBox(),
              visMode%2==0 ? _personView(context, data.passenger.back, false) : const SizedBox()
            ]
          )
        ]
      )
    );
  }
}

class ResultSection extends StatelessWidget {
  const ResultSection({super.key, required this.parser});

  final MainPraser parser;

  Widget _empty(BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.all_inbox_outlined, size: 300),
        Text('空空如也'),
        Text('未發現任何可轉換的訊息')
      ]
    )
  );

  Widget _error(BuildContext context) { 
    final theme = Theme.of(context);

    return ListView.separated(
      itemCount: parser.error.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder:(context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.error),
            title: Text(
              parser.error[index].description,
              style: theme.textTheme.titleSmall
            ),
            subtitle: Text(
              parser.error[index].message,
              style: theme.textTheme.labelMedium?.copyWith(
                overflow: TextOverflow.ellipsis 
              )
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          )
        );
      }
    );
  }

  Widget _preview(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(15),
            child: ListView.separated(
              itemCount: parser.data.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder:(context, index) {
                final data = parser.data[index];
                return DataCard(data: data);
              },
            ) 
          )
        ),
        FunctionButton(parser: parser)
      ]
    );
  }

  Widget _getContext(BuildContext context) {
    if (parser.data.isEmpty) return _empty(context);
    if (parser.error.isNotEmpty) return _error(context);
    return _preview(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: theme.colorScheme.primaryContainer
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 35),
                Text(" 處理結果", style: theme.textTheme.bodyLarge)
              ]
            ),
            Expanded(child: _getContext(context))
          ]
        )
      )
    );
  }
}

class FunctionButton extends StatefulWidget {
  final MainPraser parser;

  const FunctionButton({super.key, required this.parser});

  @override
  State<FunctionButton> createState() => _FunctionButtonState();
}

class _FunctionButtonState extends State<FunctionButton> {
  int storeStage = 0, sheetStage = 0;

  Color _color(int stage) {
    final theme = Theme.of(context);
    switch(stage) {
      case 1: return Colors.red;
      case 2: return Colors.green;
      default: return theme.inputDecorationTheme.fillColor!;
    }
  }

  IconData? _icon(int stage) {
    switch(stage) {
      case 1: return Icons.close;
      case 2: return Icons.check;
      default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(_color(storeStage))
                ),
                onPressed: (storeStage == 2) ? (){} : () async {
                  if (!FireStore.instance.loggedIn) {
                    setState(() => storeStage = 1);
                    return;
                  }
                  await FireStore.instance.addData(widget.parser.data);
                  setState(() => storeStage = 2);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_icon(storeStage)??Icons.cloud),
                    const SizedBox(width: 10),
                    const Text("儲存至雲端")
                  ]
                )
              )
            )
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(_color(sheetStage))
                ),
                onPressed: () async {
                  
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_icon(sheetStage)??Icons.checklist),
                    const SizedBox(width: 10),
                    const Text("上傳至表單")
                  ]
                ) 
              )
            )
          )
        ]
      )
    );
  }
}