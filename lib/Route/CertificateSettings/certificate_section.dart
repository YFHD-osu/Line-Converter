import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/sheets/v4.dart' as sheet_api;

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:line_converter/Route/CertificateSettings/certificate_bottom.dart';
import 'package:line_converter/Route/CertificateSettings/certificate_settings.dart' as main;
import 'package:line_converter/Route/CertificateSettings/sheet_id_section.dart';

class CertificateSection extends StatefulWidget {
  const CertificateSection({
    super.key,
    required this.sheetIdKey,
    required this.certificateKey
  });

  final GlobalKey<SheetSectionState> sheetIdKey;
  final GlobalKey<CertificateSectionState> certificateKey;

  @override
  State<CertificateSection> createState() => CertificateSectionState();
}

class CertificateSectionState extends State<CertificateSection> {
  String? cert, error;
  
  void loadCertficate() async {
    final encryptedSharedPreferences = EncryptedSharedPreferences();
    final result = await encryptedSharedPreferences.getString('certificate');
    setState(() => cert = (result=='') ? null : result);
    widget.sheetIdKey.currentState?.setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadCertficate();
  }

  BoxConstraints getConst() {
    switch(error){
      case null: {
        final isDelete = (cert!=null);
        return !isDelete
          ? const BoxConstraints(maxHeight: double.infinity)
          : const BoxConstraints(minHeight: 100, maxWidth: double.infinity);
      } default: {
        return const BoxConstraints(minHeight: 110, maxWidth: double.infinity);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15)
      ),
      constraints: getConst(),
      child: Column(
        children: [
          HeadingBar(
            sheetIdKey: widget.sheetIdKey,
            certificateKey: widget.certificateKey
          ),
          CertificateBottom(
            certificateKey: widget.certificateKey,
            errorMessage: error
          )
        ]
      )
    );
  }
}

class HeadingBar extends StatefulWidget {
  const HeadingBar({
    super.key,
    required this.sheetIdKey,
    required this.certificateKey
  });

  final GlobalKey<SheetSectionState> sheetIdKey;
  final GlobalKey<CertificateSectionState> certificateKey;

  @override
  State<HeadingBar> createState() => _HeadingBarState();
}

class _HeadingBarState extends State<HeadingBar> {

  void pasteClipboard() async {
    final state = widget.certificateKey.currentState!;
    setState(() => state.error = 'working');

    final encryptedSharedPreferences = EncryptedSharedPreferences();
    final clipboard = (await Clipboard.getData(Clipboard.kTextPlain))!.text??'';

    try {
      final dataResult = jsonDecode(clipboard);
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(dataResult),
        ['https://www.googleapis.com/auth/spreadsheets',
        'https://www.googleapis.com/auth/drive.readonly',
        'https://www.googleapis.com/auth/spreadsheets.readonly'] 
      );
      final api = sheet_api.SheetsApi(client);
      // print(response.properties!.title);

    } on FormatException catch(_) {
      state.setState(() => state.error = '無法解析憑證格式');
      setState(() {});
      return;
    } on sheet_api.DetailedApiRequestError catch(_) {
      state.setState(() => state.error = '憑證無法通過登入');
      setState(() {});
      return;
    } on ArgumentError catch (_) {
      state.setState(() => state.error = '憑證內容存在缺陷');
      setState(() {});
      return;
    }

    state.cert = clipboard;
    final result = await encryptedSharedPreferences.setString('certificate', clipboard);

    widget.sheetIdKey.currentState?.setState(() {});
    setState(() => state.setState(() => state.error = null));
  }

  void deleteCertificate() async {
    final state = widget.certificateKey.currentState!;
    final encryptedSharedPreferences = EncryptedSharedPreferences();
    final result = await encryptedSharedPreferences.remove('certificate');
    
    setState(() {});
    state.setState(() => state.cert = null);
    widget.sheetIdKey.currentState?.setState(() {});
  }

  Widget getIcon(bool isDelete) {
    final state = widget.certificateKey.currentState!;
    if ('${state.error}' == 'working') {
      return const SizedBox(
        height: 24, width: 24,
        child: CircularProgressIndicator()
      );
    }

    return isDelete ? 
      const Icon(Icons.delete_sweep_sharp) :
      const Icon(Icons.paste_outlined) ; 
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.certificateKey.currentState!;
    final isDelete = (state.cert != null);

    return Row(
      children: [
        const Icon(Icons.article_rounded, size: 40),
        const SizedBox(width: 5),
        const Padding(padding: EdgeInsets.only(bottom: 4), child: Text('上傳憑證')),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            foregroundColor: Colors.white,
            backgroundColor: isDelete ? Colors.red[500] : Colors.green[500]
          ),
          onPressed: isDelete ? deleteCertificate : pasteClipboard,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: SizedBox(
              key: ValueKey<bool>(isDelete),
              child: getIcon(isDelete)
            )
          )
        ),
        const SizedBox(width: 10),
      ]
    );
  }
}

