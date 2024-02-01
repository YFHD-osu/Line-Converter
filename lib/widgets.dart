import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:universal_html/html.dart';
import 'package:super_clipboard/super_clipboard.dart';

class FullscreenTextBox extends StatelessWidget {
  final String heroTag;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const FullscreenTextBox({
    super.key,
    required this.controller,
    required this.heroTag,
    this.onChanged
  });

  String _getOSInsideWeb() {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    if( userAgent.contains("iphone"))  return "ios";
    if( userAgent.contains("ipad")) return "ios";
    if( userAgent.contains("android"))  return "Android";
    return "Web";
   }

  @override
  Widget build(BuildContext context) {
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
            final clipboard = SystemClipboard.instance;
            if (clipboard == null) {
              controller.text = "No API";
              return; // Clipboard API is not supported on this platform.
            }
            final reader = await clipboard.read();
            controller.text = reader.items.toList().length.toString();
            if (reader.canProvide(Formats.plainText)) { // Do something with the plain text
              controller.text = await reader.readValue(Formats.plainText) ?? "剪貼簿錯誤"; 
            }
            return;
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
                padding: EdgeInsets.fromLTRB(10, 10, 10, safeArea+6),
                child: TextField(
                  maxLines: 999,
                  autofocus: true,
                  autocorrect: false,
                  controller: controller,
                  contextMenuBuilder: (kIsWeb && _getOSInsideWeb() == "ios") ? (context, editableTextState) => const SizedBox() : null,
                  onChanged: onChanged,
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
class TextBox extends StatelessWidget {
  const TextBox({
    super.key,
    required this.heroTag,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.haveToolButtons = true
  });

  final bool haveToolButtons;
  final Function(String)? onChanged;
  final String heroTag, hintText;
  final TextEditingController controller;

  void onTap(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
    builder: (context) => 
      FullscreenTextBox(
        heroTag: heroTag,
        controller: controller,
        onChanged: onChanged
      )
    ));
  }

  String getOSInsideWeb() {
    final userAgent = window.navigator.userAgent.toString().toLowerCase();
    if( userAgent.contains("iphone"))  return "ios";
    if( userAgent.contains("ipad")) return "ios";
    if( userAgent.contains("android"))  return "Android";
    return "Web";
   }

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Hero(
          tag: heroTag,
          child: Material(
            color: Colors.transparent,
            child: TextField(
              onTap: () => onTap(context),
              maxLines: 999,
              readOnly: true,
              controller: controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: hintText
              )
            )
          )
        ),
        !haveToolButtons ? const SizedBox() :
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 10),
          child: ToolButtons(tag: '$heroTag-c', visibile: false)
        )
      ]
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
    final clipboard = SystemClipboard.instance;
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
          clipboard==null ? const SizedBox() : TextButton(
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
          )
        ]
      )
    );
  }
}

class CupertinoTextBox extends StatelessWidget {
  const CupertinoTextBox({
    super.key,
    required this.title,
    this.controller,
    this.onChanged,
    this.onlyDigits = false,
    this.onlyDouble = false,
    this.suffixString,
    this.autofocus,
    this.obscureText
  });

  final String title;
  final bool? autofocus, obscureText;
  final String? suffixString;
  final bool onlyDigits, onlyDouble;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  List<TextInputFormatter>? getInputFormat() {
    if (onlyDouble) {
      return [FilteringTextInputFormatter.allow(
        RegExp(r"(-?\d+(\.\d*)?)|(-?\.\d+)"),
      )];
    }

    if (onlyDigits) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraint) {
        return SizedBox(
          width: constraint.maxWidth, 
          child: TextField(
            maxLines: 1,
            obscureText: obscureText??false,
            autofocus: autofocus??false,
            autocorrect: false,
            onChanged: onChanged,
            controller: controller,
            enableSuggestions: false,
            style: const TextStyle(fontSize: 18),
            keyboardType: onlyDigits ? TextInputType.number : null,
            inputFormatters: getInputFormat(),
            decoration: InputDecoration(
              isDense: true,
              isCollapsed: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(title, 
                      style: themeData.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey
                      )
                    )
                  )
                ],
              ),
              contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(" ${suffixString??''}")
              ),
            )
          )
        );
      }
    );
  }
}

class FancySwitch extends StatefulWidget {
  const FancySwitch({
    super.key,
    required this.title,
    required this.isEnable,
    this.onChange,
    this.lore
  });
  
  final String title;
  final bool isEnable;
  final String? lore;
  final Function(bool)? onChange;
  @override
  State<FancySwitch> createState() => _FancySwitchState();
}

class _FancySwitchState extends State<FancySwitch> {
  
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    
    final loreText = [
      const SizedBox(height: 5),
      Flexible(
        child: Text(
          widget.lore??'',
          style: themeData.textTheme.labelSmall?.copyWith(
            color: Colors.grey
          )
        )
      )
    ];

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(15),
      color: Colors.transparent,
      child: InkWell(
        onTap: (widget.onChange == null) ? 
          null : () => widget.onChange?.call(!widget.isEnable),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(
                    color: (widget.onChange == null) ? Colors.grey : null
                  )),
                  (widget.lore == null) ? const SizedBox() : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: loreText
                  )
                  
                ]
              ),
              const Spacer(),
              Switch(
                value: widget.isEnable,
                onChanged: widget.onChange
              )
            ]
          )
        )
      )
    );
  }
}