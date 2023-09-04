import 'dart:io';
import 'package:flutter/material.dart';
import 'package:line_converter/Page/DataPage/mode_switch.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:line_converter/Library/data_manager.dart';
import 'package:line_converter/Route/DetailData/title_bar.dart';
import 'package:line_converter/Route/DetailData/morning_main_column.dart';
import 'package:line_converter/Page/DataPage/control_button.dart';

const List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

class MorningDetailDataRoute extends StatefulWidget {
  const MorningDetailDataRoute({Key? key, required this.data} ) : super(key: key);

  final Map<String, Object?> data;

  @override
  State<MorningDetailDataRoute> createState() => _MorningDetailDataRouteState();
}

class _MorningDetailDataRouteState extends State<MorningDetailDataRoute> {
  bool getImageBusy = false;
  String highlightString = "";
  WidgetsToImageController controller = WidgetsToImageController();
  GlobalKey<ControlButtonState> showMorning = GlobalKey(), showEvening = GlobalKey(), showHighlight = GlobalKey();

  Future getImage() async {
    setState(() => getImageBusy = true);
    final directory = await getApplicationDocumentsDirectory();
    final bytes = await controller.capture();
    final dir = Directory('${directory.path}/cache/');
    if ((await dir.exists()) == false) { await dir.create(recursive: true); }
    await File('${directory.path}/cache/screenshots.jpg').writeAsBytes(bytes!);
    await Share.shareXFiles([XFile('${directory.path}/cache/screenshots.jpg')], text: '車表輸出');
    setState(() => getImageBusy = false);
  }

  @override
  void initState() {
    super.initState();
    EncryptedSharedPreferences().getString('highlightName')
    .then((value) => highlightString = value)
    .then((value) => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: Column(
        children: [
          TitleBar(
            showType: ShowType.morning,
            heroTag: widget.data['addTime'] as String
          ),
          Row(
            children: [
              const Spacer(),
              ControlButton(
                title: '早上',
                key: showMorning,
                onTap: () => setState(() {}),
              ),
              const Spacer(),
              ControlButton(
                title: '下午',
                key: showEvening,
                onTap: () => setState(() {}),
              ),
              const Spacer(),
              ControlButton(
                title: '標記',
                key: showHighlight,
                onTap: () => setState(() {}),
              ),
              const Spacer()
            ]
          ),
          Expanded(
            child: Material(
              color: Theme.of(context).scaffoldBackgroundColor,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                child: WidgetsToImage(
                  controller: controller,
                  child: MorningMainColumn(
                    highlightString: highlightString,
                    showMorning: showMorning.currentState?.isOn,
                    showEvening: showEvening.currentState?.isOn,
                    showHighlight: showHighlight.currentState?.isOn,
                    data: dbManager.convertMorningCarData(widget.data)
                  )
                )
              )
            )
          ),
          const SizedBox(height: 10)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageBusy ? null : getImage,
        backgroundColor: Colors.green,
        child: getImageBusy ? const CircularProgressIndicator() : const Icon(Icons.camera_alt_rounded)
      )
    );
  }
}

