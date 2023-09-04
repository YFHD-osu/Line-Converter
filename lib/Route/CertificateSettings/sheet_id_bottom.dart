import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:line_converter/Route/CertificateSettings/sheet_id_section.dart';

import 'certificate_section.dart';

class SheetIdBottom extends StatefulWidget {
  const SheetIdBottom({
    super.key,
    required this.sheetIdKey,
    required this.certificateKey
  });

  final GlobalKey<SheetSectionState> sheetIdKey;
  final GlobalKey<CertificateSectionState> certificateKey;

  @override
  State<SheetIdBottom> createState() => SheetIdBottomState();
}

class SheetIdBottomState extends State<SheetIdBottom> {
  
  @override
  Widget build(BuildContext context) {
    final state = widget.sheetIdKey.currentState!;
    final mediaQuery = MediaQuery.of(context);

    if (widget.certificateKey.currentState!.cert == null) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15)
        ),
        child: const Text('請先完成憑證設定')
      );
    }

    if (state.error == 'waiting') {
      return Row(
        children: [
          const Icon(Icons.file_present, size: 125),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('選取表單', style: TextStyle(fontSize: 30)),
              const Text('', 
                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.normal)
              ),
              DropdownMenu<String>(
                width: mediaQuery.size.width - 165,
                label: const Text('工作區名稱'),
                dropdownMenuEntries: state.sheetEntries,
                leadingIcon: const Icon(Icons.search),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  contentPadding: EdgeInsets.all(0),
                ),
                onSelected: (String? title) async {
                  setState(() => state.sheetTitle = title);
                  state.setState(() => state.error = null);

                  final perfs = EncryptedSharedPreferences();
                  await perfs.setString('sheetID', state.sheetID!);
                  await perfs.setString('spreadsheetTitle', title!);
                }
              )
            ]
          )
        ]
      );
    }

    if (state.error != null && state.error != 'working') {
      return Row(
        children: [
          const Icon(Icons.error, size: 125),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('發生錯誤', style: TextStyle(fontSize: 30)),
              Text('${state.error}', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
              )
            ]
          )
        ]
      );
    }

    if (state.sheetID == null) {
      return const Row(
      children: [
        Icon(Icons.file_present, size: 125),
        Text('請貼上表單ID', style: TextStyle(fontSize: 30))
      ]
    );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.file_present, size: 125),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('工作表名稱', style: TextStyle(fontSize: 30)),
            Text('${state.sheetID}', 
              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.normal)
            ),
            Text('${state.sheetTitle}', 
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.normal)
            )
          ]
        )
      ]
    );
  }
}