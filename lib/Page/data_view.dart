import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:line_converter/core/typing.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:line_converter/Page/Datapage/control_button.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;

class DataViewPage extends StatefulWidget {
  final List<CarData> data;

  const DataViewPage({Key? key, required this.data} ) : super(key: key);

  @override
  State<DataViewPage> createState() => _DataViewPageState();
}

class _DataViewPageState extends State<DataViewPage> {
  bool getImageBusy = false;
  String highlightString = "";
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey<ControlButtonState> showMorning = GlobalKey(), showEvening = GlobalKey(), showHighlight = GlobalKey();

  var container = Builder(builder: (context) {
    return Container(
        // width: size2.width,
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          border:
              Border.all(color: Colors.blueAccent, width: 5.0),
          color: Colors.redAccent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < 12; i++)
              Text("Tile Index $i"),
          ],
        ));
  });

  void _download(List<int> bytes, {String? filename}) {
    final base64 = base64Encode(bytes); // Encode our file in base64
    // Create the link with the file
    final anchor =
      AnchorElement(href: 'data:application/octet-stream;base64,$base64')
      ..target = 'blank';

    // add the name
    anchor.download = filename??anchor.download;

    // trigger download
    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  Future _imageOut() async {
    setState(() => getImageBusy = true);
    final bytes = await screenshotController
        .captureFromLongWidget(
      InheritedTheme.captureAll(
          context, Material(child: container)),
      delay: const Duration(milliseconds: 100),
      context: context,
    );
    setState(() => getImageBusy = false);
    _download(bytes.toList(), filename: "file.png");
  }

  Future _highlight() async {
    final perfs = EncryptedSharedPreferences();
    highlightString = await perfs.getString('highlightName');
  }

  @override
  void initState() {
    super.initState();
    _highlight();
  }

  Widget _empty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inbox_outlined, size: 300),
          Text('空空如也'),
          Text('未發現任何可轉換的訊息')
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder:(context) {
                if (widget.data.isEmpty) return _empty();
                return SizedBox(
                  width: 100, height: 100,
                  child: FlutterLogo()
                );
              },
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: getImageBusy ? null : _imageOut,
        child: getImageBusy ? const CircularProgressIndicator() : const Icon(Icons.camera_alt_rounded)
      )
    );
  }
}
