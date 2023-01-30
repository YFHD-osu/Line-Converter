import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class MasterTextEditingControllerClass {
  var NameHighlighted;

  MasterTextEditingControllerClass(){
    NameHighlighted = TextEditingController();
  }

  void init () async {
    EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    NameHighlighted.text = await encryptedSharedPreferences.getString('highlightName');
  }
}

class HighlightSettingsRoute extends StatefulWidget {
  const HighlightSettingsRoute({Key? key}) : super(key: key);

  @override
  State<HighlightSettingsRoute> createState() => _HighlightSettingsRoute();
}

class _HighlightSettingsRoute extends State<HighlightSettingsRoute> {
  var MasterTextEditingController = MasterTextEditingControllerClass();

  @override
  void initState() {
    super.initState();
    _loadTextBox();
  }
  void _loadTextBox () {
    EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    MasterTextEditingController.init();
    encryptedSharedPreferences.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: GestureDetector(
          onTap: () { FocusScope.of(context).unfocus(); },
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Center(child: Text('醒目標示', style: Theme.of(context).textTheme.titleLarge))
                      )
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(15, 16, 0, 10),
                      child: Material(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        child: IconButton(
                            onPressed: () { Navigator.pop(context); },
                            icon: Icon(Icons.arrow_back_ios_rounded)
                        ),
                      )
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        controller: MasterTextEditingController.NameHighlighted,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Colors.green.shade600,
                                width: 15
                            ),
                          ),
                          hintText: '輸入需要醒目標示的人名',
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                          filled: true,
                        ),
                      ),
                    )
                )
              )

            ]
          )
        ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 60,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white
                  ),
                  onPressed: () async {
                    MasterTextEditingController.NameHighlighted.text = '';
                  },
                  label: const Text('清除全部', style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              ),

                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green[600],
                        onPrimary: Colors.white
                    ),
                    onPressed: () {
                      EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
                      (MasterTextEditingController.NameHighlighted.text == '') ? encryptedSharedPreferences.remove('highlightName') : encryptedSharedPreferences.setString('highlightName', MasterTextEditingController.NameHighlighted.text);
                      Navigator.pop(context);
                    },
                    label: const Text('儲存離開', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
             ],
           ),
          )
        ),
      );


  }
}