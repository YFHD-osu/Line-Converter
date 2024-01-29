import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_converter/process_dialog.dart';

class JoinPage extends StatelessWidget {
  JoinPage({super.key});
  final timeText = TextEditingController();
  final serialText = TextEditingController();

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
      title: Text("加入資料", style: theme.textTheme.titleMedium),
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Container(color: Colors.transparent))
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textHeight = (mediaQuery.size.width - 50 - 80) / 2;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _appBar(context)
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: ListView(
          children: [
            SizedBox(
              height: (mediaQuery.size.height - 130) / 2,
              child: TextBox(
                hintText: "輸入車輛時間資訊",
                heroTag: "timeCtrl",
                controller: timeText,
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: (mediaQuery.size.height - 130) / 2,
              child: TextBox(
                hintText: "輸入車輛代碼資訊",
                heroTag: "serialCtrl",
                controller: serialText
              )
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              child: TextButton(
                child: const Text("開始轉換"),
                onPressed: () async {
                  final obj = DataViewDialog(
                    context: context,
                    car: timeText,
                    person: serialText
                  );
                  await obj.parse();
                }
              )
            )
          ]
        )
      )
    );
  }
}

class FullscreenTextBox extends StatelessWidget {
  final String heroTag;
  final TextEditingController controller;

  const FullscreenTextBox({
    super.key,
    required this.controller,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final safeArea = mediaQuery.padding.bottom;

    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      bottomNavigationBar: const SizedBox(height: 0),
      resizeToAvoidBottomInset: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ToolButtons(
          tag: '$heroTag-c',
          visibile: true, 
          closeBtn: () => Navigator.of(context).pop(controller.text),
          clipBtn: () async {
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            controller.text = data?.text.toString() ?? '剪貼簿錯誤';
          },
          onClear: () => controller.text = ''
        )
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Hero(
            tag: heroTag,
            child: Material(
              child: Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: safeArea+10),
                child: TextField(
                  maxLines: 999,
                  autofocus: true,
                  autocorrect: false,
                  controller: controller,
                  style: theme.textTheme.labelMedium,
                )
              )
            )
          )
        )
      )
    );
  }
}

/* ====================
 Main input text field
==================== */
class TextBox extends StatefulWidget {
  const TextBox({
    super.key,
    required this.heroTag,
    required this.hintText,
    required this.controller
  });

  final String heroTag, hintText;
  final TextEditingController controller;

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {

  void onTap() {
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => 
      FullscreenTextBox(
        heroTag: widget.heroTag,
        controller: widget.controller,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Set textfield text agian beacuse the value got clean every time it rebuilt
    // widget.controller.text = tmpValue;
    // final MediaQueryData mediaQuery = MediaQuery.of(context);
    // final double safeAreaHeight = mediaQuery.padding.top + mediaQuery.padding.bottom;
    // final double defaultHeight = (mediaQuery.size.height - safeAreaHeight - 300)/2;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Hero(
          tag: widget.heroTag,
          child: Material(
            child: TextField(
              onTap: onTap,
              maxLines: 999,
              readOnly: true,
              controller: widget.controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: widget.hintText
              )
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: ToolButtons(
            tag: '${widget.heroTag}-c',
            visibile: false,
            closeBtn: () {},
            clipBtn: () => 
              Clipboard.getData(Clipboard.kTextPlain).then((value)
                => widget.controller.text = value!.text ?? ''),
            onClear: () => widget.controller.text = ''
          )
        )
      ],
    );
  }
}

class ToolButtons extends StatelessWidget {
  final String tag;
  final bool visibile;
  final void Function()? closeBtn, clipBtn, onClear;

  const ToolButtons({
    super.key,
    required this.tag,
    required this.visibile,
    this.onClear,
    this.closeBtn,
    this.clipBtn,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IgnorePointer(
            ignoring: !visibile,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: visibile ? 1.0 : 0.0,
              curve: Curves.linear,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[500],
                ),
                onPressed: closeBtn,
                child: const Icon(Icons.transit_enterexit_rounded)
              )
            ),
          ),
          const SizedBox(width: 10),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              foregroundColor: Colors.white,
              backgroundColor: Colors.green[500],
            ),
            onPressed: clipBtn,
            child: const Icon(Icons.paste_outlined)
          ),
          const SizedBox(width: 10),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[500],
            ),
            onPressed: onClear, //Get clipboard data,
            child: const Icon(Icons.delete_sweep_sharp, size: 24)
          ),
        ]
      )
    );
  }
}