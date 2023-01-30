import 'package:flutter/material.dart';
import '../Route/ThemeSettings.dart';
import '../Route/CertificateSettings.dart';
import '../Route/CaptionSettings.dart';
import '../Route/HighlightSettings.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
          height: 60,
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 2, 0, 0),
            child: Text('設定', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
            )
          ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Material(
              borderRadius: BorderRadius.circular(15),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                children: [
                  Container( // 佈景主題按鈕
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const ThemeSettingsRoute()));},
                      icon: const Icon(Icons.display_settings, size: 32,),
                      label: Text(' 佈景主題', style: Theme.of(context).textTheme.labelMedium),
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Theme.of(context).inputDecorationTheme.fillColor,
                        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                        foregroundColor: Theme.of(context).primaryColor,
                        alignment: Alignment.centerLeft,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)
                        ),
                      )
                    )
                  ),
                  Container( // 憑證設定按鈕
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const SheeetSettingsRoute()));},
                      icon: const Icon(Icons.document_scanner_outlined,
                        size: 32,),
                      label: Text(' 上傳設定', style: Theme.of(context).textTheme.labelMedium),
                      style: ElevatedButton.styleFrom(
                        surfaceTintColor: Theme.of(context).inputDecorationTheme.fillColor,
                        backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                        foregroundColor : Theme.of(context).primaryColor,
                        alignment: Alignment.centerLeft,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)
                        ),
                      )
                    )
                  ),
                  Container( // 佈景主題按鈕
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: ElevatedButton.icon(
                          onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const HighlightSettingsRoute()));},
                          icon: const Icon(Icons.person_add, size: 32,),
                          label: Text(' 醒目標示', style: Theme.of(context).textTheme.labelMedium),
                          style: ElevatedButton.styleFrom(
                            surfaceTintColor: Theme.of(context).inputDecorationTheme.fillColor,
                            backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                            foregroundColor: Theme.of(context).primaryColor,
                            alignment: Alignment.centerLeft,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)
                            ),
                          )
                      )
                  ),
                  Container( // 使用說明按鈕
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ElevatedButton.icon(
                        onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => const CaptionSettingsRoute()));},
                        icon: const Icon(Icons.question_mark_rounded,
                          size: 32,),
                        label: Text(' 使用說明', style: Theme.of(context).textTheme.labelMedium),
                        style: ElevatedButton.styleFrom(
                          surfaceTintColor: Theme.of(context).inputDecorationTheme.fillColor,
                          backgroundColor: Theme.of(context).inputDecorationTheme.fillColor,
                          foregroundColor: Theme.of(context).primaryColor,
                          alignment: Alignment.centerLeft,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15)
                          ),
                        )
                      )
                    )
                ],
              ),
            ),
          )
        ),
      ],
    );
  }
}


