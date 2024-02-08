import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:line_converter/core/database.dart';
import 'package:line_converter/page/join.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart' as html;

class DataViewPage extends StatefulWidget {
  final DataDocs data;

  const DataViewPage({Key? key, required this.data} ) : super(key: key);

  @override
  State<DataViewPage> createState() => _DataViewPageState();
}

class _DataViewPageState extends State<DataViewPage> {
  String highlightString = "";
  bool getImageBusy = false, highlight = true;
  final screenshotController = ScreenshotController();
  int visMode = 0;

  Widget _dataColumn() {
    final mediaQuery = MediaQuery.of(context);
    return Wrap(
      spacing: 10,
      direction: Axis.vertical,
      children: widget.data.data.map((e) => SizedBox(
        width: mediaQuery.size.width - 20,
        child: DataCard(data: e, visMode: visMode, highlight: highlight)
      )
      ).toList()
    );
  }

  late var screenShot = Builder(builder: (context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[const SizedBox(height: 5)] + widget.data.data.map((e) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: DataCard(data: e, visMode: visMode, highlight: highlight)
          )
        ).toList() + <Widget>[const SizedBox(height: 5)]
      )
    );
  });

  void _download(String base64, {String? filename}) {
     // Encode our file in base64
    // Create the link with the file
    final anchor =
      html.AnchorElement(href: 'data:application/octet-stream;base64,$base64')
      ..target = 'blank';

    // add the name
    anchor.download = filename??anchor.download;

    // trigger download
    html.document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }

  String _getFilename() {
    final ts = widget.data.timestamps;
    final type = widget.data.data.first.type.index;
    return "${ts.year}-${ts.month}-${ts.day}-${["早班車", "晚班車"][type]}.png";
  }

  Future _imageOut() async {
    late final String base64;
    setState(() => getImageBusy = true);
    if (!widget.data.checkBase64(visMode, highlight)) {
      final bytes = await screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(context, Material(child: screenShot)),
        delay: const Duration(milliseconds: 100),
        context: context,
        constraints: const BoxConstraints(minWidth: 500),
        pixelRatio: 5.0
      );
      base64 = base64Encode(bytes);
      widget.data.setBase64(visMode, highlight, base64);
      // FireStore.instance.setImage(widget.data);
    } else {
      base64 = widget.data.getBase64(visMode, highlight)!;
    }
    
    setState(() => getImageBusy = false);
    _download(base64, filename: _getFilename());
  }

  Widget _appBar() {
    final theme = Theme.of(context);
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      leadingWidth: 50,
      centerTitle: false,
      excludeHeaderSemantics: true,
      surfaceTintColor: theme.colorScheme.background,
      backgroundColor: theme.colorScheme.background.withOpacity(0.75),
      title: const Text("詳細資料"),
      actions: [
        IconButton(
          icon: const Icon(Icons.highlight),
          onPressed: () {
            highlight = !highlight;
            setState(() {});
          }
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () {
            visMode = (visMode+1)>2 ? 0 : visMode+1;
            setState(() {});
          }
        )
      ],
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
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: _appBar()
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 55),
              _dataColumn(),
              const SizedBox(height: 10)
            ]
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: getImageBusy ? null : _imageOut,
        child: getImageBusy ? const CircularProgressIndicator() : const Icon(Icons.download)
      )
    );
  }
}