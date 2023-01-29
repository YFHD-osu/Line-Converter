import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class MasterTextEditingControllerClass {
  var sheetID;
  var morningWorkspaceTitle;
  var afternoonWorkspaceTitle;
  var certificate;

  MasterTextEditingControllerClass(){
    sheetID = TextEditingController();
    morningWorkspaceTitle = TextEditingController();
    afternoonWorkspaceTitle = TextEditingController();
    certificate = TextEditingController();
  }

  void init () async {
    EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
    sheetID.text = await encryptedSharedPreferences.getString('sheetID');
    morningWorkspaceTitle.text = await encryptedSharedPreferences.getString('morningWorkspaceTitle');
    afternoonWorkspaceTitle.text = await encryptedSharedPreferences.getString('afternoonWorkspaceTitle');
    certificate.text = await encryptedSharedPreferences.getString('certificate');
  }
}

class SheeetSettingsRoute extends StatefulWidget {
  const SheeetSettingsRoute({Key? key}) : super(key: key);

  @override
  State<SheeetSettingsRoute> createState() => _SheeetSettingsRouteState();
}

class _SheeetSettingsRouteState extends State<SheeetSettingsRoute> {
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
                          child: Center(child: Text('上傳設定', style: Theme.of(context).textTheme.titleLarge))
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
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: Material(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 20,
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              decoration: BoxDecoration(
                                color: Theme.of(context).inputDecorationTheme.fillColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                    child: TextField(
                                      autocorrect: false,
                                      controller: MasterTextEditingController.sheetID,
                                      cursorHeight: 30,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(color: Colors.green.shade600, width: 15)),
                                        labelText: '表單 ID',
                                        labelStyle: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: TextField(
                                      autocorrect: false,
                                      controller: MasterTextEditingController.morningWorkspaceTitle,
                                      cursorHeight: 30,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(color: Colors.green.shade600, width: 15)),
                                        labelText: '早上車表工作區名稱',
                                        labelStyle: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                    child: TextField(
                                      autocorrect: false,
                                      controller: MasterTextEditingController.afternoonWorkspaceTitle,
                                      cursorHeight: 30,
                                      style: const TextStyle(fontSize: 18),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(color: Colors.green.shade600, width: 15)),
                                        labelText: '下午車表工作區名稱',
                                        labelStyle: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).inputDecorationTheme.fillColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextField(
                                  controller: MasterTextEditingController.certificate,
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
                                    hintText: 'Google Cloud Platform 憑證',
                                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                                    filled: true,
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
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
                        primary: Colors.green[600],
                        onPrimary: Colors.white
                    ),
                    onPressed: () async {
                      EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
                      MasterTextEditingController.certificate.text = '';
                      MasterTextEditingController.sheetID.text = '';
                      MasterTextEditingController.afternoonWorkspaceTitle.text = '';
                      MasterTextEditingController.morningWorkspaceTitle.text = '';
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
                      (MasterTextEditingController.certificate.text == '') ? encryptedSharedPreferences.remove('certificate') : encryptedSharedPreferences.setString('certificate', MasterTextEditingController.certificate.text);
                      (MasterTextEditingController.sheetID.text == '') ? encryptedSharedPreferences.remove('sheetID') : encryptedSharedPreferences.setString('sheetID', MasterTextEditingController.sheetID.text);
                      (MasterTextEditingController.afternoonWorkspaceTitle.text == '') ? encryptedSharedPreferences.remove('afternoonWorkspaceTitle') : encryptedSharedPreferences.setString('afternoonWorkspaceTitle', MasterTextEditingController.afternoonWorkspaceTitle.text);
                      (MasterTextEditingController.morningWorkspaceTitle.text == '') ? encryptedSharedPreferences.remove('morningWorkspaceTitle') : encryptedSharedPreferences.setString('morningWorkspaceTitle', MasterTextEditingController.morningWorkspaceTitle.text);
                      Navigator.pop(context);
                    },
                    label: const Text('儲存離開', style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}