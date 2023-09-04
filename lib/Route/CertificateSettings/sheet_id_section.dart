import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:line_converter/Route/CertificateSettings/sheet_id_bottom.dart';
import 'package:line_converter/Route/CertificateSettings/sheet_id_title_bar.dart';
import 'package:line_converter/Route/CertificateSettings/certificate_section.dart';

class SheetSection extends StatefulWidget {
  const SheetSection({
    super.key,
    required this.sheetIdKey,
    required this.certificateKey
  });

  final GlobalKey<SheetSectionState> sheetIdKey;
  final GlobalKey<CertificateSectionState> certificateKey;

  @override
  State<SheetSection> createState() => SheetSectionState();
}

class SheetSectionState extends State<SheetSection> {
  String? error, sheetID, sheetTitle;
  List<DropdownMenuEntry<String>> sheetEntries = <DropdownMenuEntry<String>>[];
  GlobalKey<SheetIdBottomState> bottomKey = GlobalKey();

  void loadCertficate() async {
    final perfs = EncryptedSharedPreferences();
    sheetID = await perfs.getString('sheetID');
    sheetTitle = await perfs.getString('spreadsheetTitle');
    // print(result);
    sheetTitle = (sheetTitle=='') ? null : sheetTitle;
    setState(() => sheetID = (sheetID=='') ? null : sheetID);
    bottomKey.currentState?.setState(() {});
    widget.sheetIdKey.currentState?.setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadCertficate();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: [
          SheetIdHeadingBar(
            bottomKey: bottomKey,
            sheetIdKey: widget.sheetIdKey
          ),
          SheetIdBottom(
            key: bottomKey,
            sheetIdKey: widget.sheetIdKey,
            certificateKey: widget.certificateKey
          )
        ]
      )
    );
  }
}

