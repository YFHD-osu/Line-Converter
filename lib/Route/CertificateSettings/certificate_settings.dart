import 'package:flutter/material.dart';
import 'package:line_converter/Route/CertificateSettings/title_bar.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:line_converter/Route/CertificateSettings/sheet_id_section.dart';
import 'package:line_converter/Route/CertificateSettings/certificate_section.dart';

class SheeetSettingsRoute extends StatefulWidget {
  const SheeetSettingsRoute({Key? key}) : super(key: key);

  @override
  State<SheeetSettingsRoute> createState() => _SheeetSettingsRouteState();
}

class _SheeetSettingsRouteState extends State<SheeetSettingsRoute> {

  GlobalKey<CertificateSectionState> certificateKey = GlobalKey();
  GlobalKey<SheetSectionState> sheetIdKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadTextBox();
  }

  void _loadTextBox () {
    final perfs = EncryptedSharedPreferences();
    perfs.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const Titlebar(),
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                child: Material(
                  borderRadius: BorderRadius.circular(15),
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        CertificateSection(
                          key: certificateKey,
                          sheetIdKey: sheetIdKey,
                          certificateKey: certificateKey
                        ),
                        const SizedBox(height: 5),
                        SheetSection(
                          key: sheetIdKey,
                          sheetIdKey: sheetIdKey,
                          certificateKey: certificateKey
                        )
                      ]
                    )
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}