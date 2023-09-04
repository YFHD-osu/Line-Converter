import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

import 'package:line_converter/Library/gsheet.dart';
import 'package:line_converter/Route/CertificateSettings/sheet_id_bottom.dart';
import 'package:line_converter/Route/CertificateSettings/sheet_id_section.dart';

class SheetIdHeadingBar extends StatefulWidget {
  const SheetIdHeadingBar({
    super.key,
    required this.bottomKey,
    required this.sheetIdKey
  });
  
  final GlobalKey<SheetIdBottomState> bottomKey;
  final GlobalKey<SheetSectionState> sheetIdKey;
  @override
  State<SheetIdHeadingBar> createState() => _SheetIdHeadingBarState();
}

class _SheetIdHeadingBarState extends State<SheetIdHeadingBar> {

  void verifySheetID() async {
    final parentState = widget.sheetIdKey.currentState!;
    final bottomState = widget.bottomKey.currentState!;
    final clipboard = (await Clipboard.getData(Clipboard.kTextPlain))!.text??'';
    if (clipboard == '') return;
    if (parentState.error == 'working') return;
    
    parentState.setState(() {});
    setState(() => parentState.error = 'working');
    
    /* Get and parse certificate from shared preference */
    final perfs = EncryptedSharedPreferences();
    final certificate = await perfs.getString('certificate');

    final api = GSheet();
    await api.initialize(credential: certificate);
    final result = await api.verifySheetAccess(sheetId: clipboard);

    if (result != null) {
      bottomState.setState(() {});
      setState(() => parentState.error = result);
      return;
    }

    parentState.sheetEntries = api.verifySheetTitle.map((title) => {
      DropdownMenuEntry<String>(value: title, label: title)
    }).expand((element) => element).toList();

    setState(() {});
    bottomState.setState(() => parentState.error = 'waiting');
    parentState.setState(() => parentState.sheetID = clipboard);

  }

  void deleteCertificate() async {
    final state = widget.sheetIdKey.currentState!;
    final prefs = EncryptedSharedPreferences();
    await prefs.remove('spreadsheetTitle');
    await prefs.remove('sheetID');
    
    setState(() => state.sheetID = null);
    state.setState(() => state.error = null);
  }

  Widget getIcon(bool isDelete) {
    final state = widget.sheetIdKey.currentState!;
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
    final state = widget.sheetIdKey.currentState!;
    final bool isDelete = state.sheetID != null;

    return Row(
      children: [
        const Icon(Icons.file_upload, size: 40),
        const SizedBox(width: 5),
        const Padding(padding: EdgeInsets.only(bottom: 4), child: Text('表單設定')),
        const Spacer(),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            foregroundColor: Colors.white,
            backgroundColor: isDelete ? Colors.red[500] : Colors.green[500]
          ),
          onPressed: state.sheetID == 'waiting' ? null : !isDelete ? verifySheetID : deleteCertificate,
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
        const SizedBox(width: 10)
      ]
    );
  }
}