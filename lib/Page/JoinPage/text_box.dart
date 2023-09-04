import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/* ==================
 Three buttons below
================== */
class ToolButtons extends StatefulWidget {
  const ToolButtons({
    super.key,
    required this.tag,
    required this.visibile,
    required this.onDisfocus,
    required this.onClipboard,
    required this.onClear,
  });

  final String tag;
  final bool visibile;
  final void Function()? onDisfocus;
  final void Function()? onClipboard;
  final void Function()? onClear;

  @override
  State<ToolButtons> createState() => _ToolButtonsState();
}

class _ToolButtonsState extends State<ToolButtons> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:  widget.tag,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IgnorePointer(
            ignoring: !widget.visibile,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: widget.visibile ? 1.0 : 0.0,
              curve: Curves.linear,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green[500],
                ),
                onPressed: widget.onDisfocus,
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
            onPressed: widget.onClipboard,
            child: const Icon(Icons.paste_outlined)
          ),
          const SizedBox(width: 10),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
              foregroundColor: Colors.white,
              backgroundColor: Colors.red[500],
            ),
            onPressed: widget.onClear, //Get clipboard data,
            child: const Icon(Icons.delete_sweep_sharp, size: 24)
          ),
        ]
      )
    );
  }
}

/* ==========================
 Fullscreen input text field
========================== */
class FullscreenTextBox extends StatefulWidget {
  const FullscreenTextBox({
    super.key,
    required this.heroTag,
    required this.controller
  });
  final String heroTag;
  final TextEditingController controller;

  @override
  State<FullscreenTextBox> createState() => _FullscreenTextBoxState();
}

class _FullscreenTextBoxState extends State<FullscreenTextBox> {
  bool isBuild = false;
  double lastHeight = -1;
  final GlobalKey containerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isBuild = true;
  }

  void exit() {
    lastHeight = -1;
    isBuild = false;
    Future.microtask(() => Navigator.of(context).pop(widget.controller.text));
  }

  bool onSizeChange (SizeChangedLayoutNotification notification) {
    if (!isBuild) return true;
    
    double currentHeight = containerKey.currentContext!.size!.height;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenSize = mediaQuery.size.height;
    
    if (lastHeight != -1 &&
        lastHeight <= currentHeight &&
        mediaQuery.viewInsets.bottom == 0 &&
        screenSize - currentHeight < 100) {
      exit();
      return true;
    } else { 
      lastHeight = currentHeight;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double safeArea = mediaQuery.padding.bottom;

    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      bottomNavigationBar: const SizedBox(height: 0),
      resizeToAvoidBottomInset: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: ToolButtons(
          tag: '${widget.heroTag}-c',
          visibile: true, 
          onDisfocus: exit, 
          onClipboard: () => 
            Clipboard.getData(Clipboard.kTextPlain).then((value)
              => widget.controller.text = value!.text ?? ''),
          onClear: () => widget.controller.text = ''
        )
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Hero(
            tag: widget.heroTag,
            child: Material(
              child: NotificationListener(
                onNotification: (SizeChangedLayoutNotification onNotification) 
                  => onSizeChange(onNotification),
                child: SizeChangedLayoutNotifier(
                  child: Container(
                    key: containerKey,
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: safeArea+10),
                    child: TextField(
                      maxLines: 999,
                      autofocus: true,
                      autocorrect: false,
                      controller: widget.controller,
                    )
                  )
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
  TextBox({
    super.key,
    required this.hintText,
    required this.tag,
  });

  final String tag;
  final String? hintText;
  final TextEditingController controller = TextEditingController();
  
  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  void onTap() {
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => 
      FullscreenTextBox(
        heroTag: widget.tag,
        controller: widget.controller,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Set textfield text agian beacuse the value got clean every time it rebuilt
    // widget.controller.text = tmpValue;
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double safeAreaHeight = mediaQuery.padding.top + mediaQuery.padding.bottom;
    final double defaultHeight = (mediaQuery.size.height - safeAreaHeight - 300)/2;

    return Stack(
      children: [
        Hero(
          tag: widget.tag,
          child: Material(
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              height: defaultHeight,
              child: TextField(
                onTap: onTap,
                maxLines: 999,
                readOnly: true,
                controller: widget.controller,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  hintText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                )
              )
            )
          )
        ),
        Padding(
          padding: EdgeInsets.only(top: defaultHeight - 50, right: 20),
          child: ToolButtons(
            tag: '${widget.tag}-c',
            visibile: false,
            onDisfocus: () {},
            onClipboard: () => 
              Clipboard.getData(Clipboard.kTextPlain).then((value)
                => widget.controller.text = value!.text ?? ''),
            onClear: () => widget.controller.text = ''
          )
        )
      ],
    );
  }
}