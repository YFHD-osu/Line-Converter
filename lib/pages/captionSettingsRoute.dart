import 'package:flutter/material.dart';
import '../dataManager.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

String cerificate = r'''{
"type": "service_account",
"project_id": "dulcet-cat-359804",
"private_key_id": "6c97ff6e8e13169dfdd43dc422ce997379ef8afd",
"private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCbUlE06I3cHDLi\ng0P/gSZVtblfZ2NBbZFFhxIURBy0QS4dLfs6VkkWh0AmL0c4SIAJNNVv0oMKt1LD\n7eEv/MGaVqMxBGgi9i6mFWOofiGIRVvcONiDTqEHWvtgeY+vumHwGOI8bFwk3cY3\nVBL2iMNgJaqRW58shwork1zYr92d+1YTopizA96t+8Vf1MM6+PAzb37EsR2fmgFS\nDSdd3z84N6X5oe8KoIa40lqFkmjsR/k7B00otDDfRxOdKSbzF3/93qfnzNAz6Gph\nuX3eEsRu/g8MCe3ywR+4O8WJ+7bY9tZlRCOFG/LUjNNEWwg14E8N/Feo4aU+1Ex4\nNGWY5aDVAgMBAAECggEAMAw/bcgQ9knM3fBwbQ5VPwdn0GEJvdg4q9L0X0uQu5w8\nOS+bu3isxGjTidxvQjR/UxnCewSaoAqE8nJYioE8nNN3STcNRd91H9CXEyztj5ux\nJod5RulgfAeDot0H+3sDSARSnBGDUa4/XqdF9HjrQ4dzY+L9cwdVOJSuEKQawP9f\nEGf/7FdCuiPWZ5mEBRhpFgT9onF6a84Us5E+yVguEYz6ESSfgR+BaS3a8MD5n5yW\nxieESTNPQKFpOO3nUpJmDxmrx1RKTO62sf8CuoH3+mxibdtL0NRE7HPyDZEpMrut\n/Vz9lZVr+VvN8rcdVrEcP/txiZuqyyY3vb4XGrggAwKBgQDT5ggDZpDLgYf414ok\nMXHNrDEn2CMzmgyiZwzmFOqA+YmuwP0Ga0EOrAE5LOS/E2az7/vIxwZPlcoGqhw0\nC/1acrN9Vdc4XWOEFuqqtaOp+OkELq5bAoA4VNTSZkyL4/rEJKtLmHGmqPfCwhS9\nvt8I8hMi9KU2jn9zFnKlUyh5SwKBgQC7pdv9Emy1ufWoYzGEQNYfb3v3GjnX2O7+\nFV9lvSpqqwI+ypnaAnc4c0JOs83z/MbZdYUGNoLynmrzgEXgPWg2on0GQQRw8wZv\ncpGZMsRYImvu0ppKrVPhKQPbVjQWANZBh0qWF0uEIYiipQYwBpQJH8w4OFjJzBer\n0RGdT00aXwKBgHVDm7OmEwNMD59aSIx3AG+9lwZhyjlISy2ksbKyaIQvlE4tZtki\nicJA1fx6J6zGY9O4PzKBUbDBSCggA7OZ3v8q8sGtu4jpxaTXuc327zelE+7Ilpyu\n6Z5C8/PrwPi5lZDuag1Ps7VzVIlnNms7MdqVfJmfob5rZYSfK5rqRj+5AoGADZpt\ng0Alr1rmyyk9ure0jhzX4Mb+8H3ifXrxKn/3Jjp1dDXdx2csW2RHp0rzoD9v7u3N\nEfE7tvjzCen/pszs1CEdbSmjd8i2a7fjhDag8z6zkmGkG8vK6+S8SddK+VlgLunu\n50iTCeYgcKID+9FORAcRF/ZFwYNRJ/yFCWFpVoMCgYABo7wwg1gjB0PBbJpEwh42\ngZKchjuXwFsmW9LtkO/KOh6MpYoGeAKfI1jGRSdTllwWQ8vyPUodCh32GosJQqLH\nn/PN98M2+mjfbc2hA1gLGURU7liWcOQDhlKJItmf7StPMGRcyl433JcTT5F+a29H\nQ7i+9Sq2XUeG9fH7ZxL4tw==\n-----END PRIVATE KEY-----\n",
"client_email": "message-converter@dulcet-cat-359804.iam.gserviceaccount.com",
"client_id": "115796331577057258669",
"auth_uri": "https://accounts.google.com/o/oauth2/auth",
"token_uri": "https://oauth2.googleapis.com/token",
"auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
"client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/message-converter%40dulcet-cat-359804.iam.gserviceaccount.com"
}
''';

class CaptionSettingsRoute extends StatefulWidget {
  const CaptionSettingsRoute({Key? key}) : super(key: key);

  @override
  State<CaptionSettingsRoute> createState() => _CaptionSettingsRouteState();
}

class _CaptionSettingsRouteState extends State<CaptionSettingsRoute> {

  @override
  void initState() {
    super.initState();
    _getFileSize();
  }

  void _getFileSize () {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: GestureDetector(
          onTap: () { FocusScope.of(context).unfocus(); },
          child: Column(
            children: [
              Hero(
                tag: 'captionSettingsHero',
                child: Stack(
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
                            child: Center(child: Text('更多說明', style: Theme.of(context).textTheme.titleLarge))
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
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Material(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text('加入頁面', style: Theme.of(context).textTheme.titleMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 1. 左右滑動選取早班或午班的轉換', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 2. 填入沒有其他注意事項的車表資訊', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 3. 按下"開始轉換"按鈕', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 4. 在上方選取欲執行的動作', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 5. 按下"執行"按鈕', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 6. 等待"完成"按鈕變成綠色後執行已完成', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 10),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text('顯示頁面', style: Theme.of(context).textTheme.titleMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 1. 輕按任意一個字卡即可顯示詳細資訊', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(' 2. 欲刪除字卡，長按要刪出的項目即可', style: Theme.of(context).textTheme.labelMedium),
                                  margin: EdgeInsets.fromLTRB(12, 0, 0, 10),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).inputDecorationTheme.fillColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text('|進階| 回復設定', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
                                      margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(' 快速套用設定過的資訊', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                                      margin: EdgeInsets.fromLTRB(12, 0, 0, 5),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  padding: EdgeInsets.all(5),
                                  child: ElevatedButton(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: BorderSide(color: Colors.red)
                                        )
                                      ),
                                    backgroundColor: MaterialStateProperty.resolveWith((states) {return Colors.red[500];})
                                    ),
                                    onPressed: () {

                                    },
                                    onLongPress: () {
                                      EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
                                      encryptedSharedPreferences.setString('morningWorkspaceTitle','接車表');
                                      encryptedSharedPreferences.setString('sheetID','1-9WyEnfRInGMPOXAocCVmYt90ittVKIxIWEhQvQ0Z30');
                                      encryptedSharedPreferences.setString('certificate', cerificate);
                                    },
                                    child: const Text('長按套用', style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            )
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width - 20,
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).inputDecorationTheme.fillColor,
                                borderRadius: BorderRadius.circular(15),),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(' |進階| 刪除全部', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,),
                                        margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(' 刪除所有的本機資訊', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
                                        margin: EdgeInsets.fromLTRB(12, 0, 0, 5),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    padding: EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  side: BorderSide(color: Colors.red)
                                              )
                                          ),
                                          backgroundColor: MaterialStateProperty.resolveWith((states) {return Colors.red[500];})
                                      ),
                                      onPressed: () {

                                      },
                                      onLongPress: () {
                                        DeleteFloder('carDatas');
                                      },
                                      child: const Text('長按刪除', style: TextStyle(color: Colors.white)),
                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      ),
                    )
                  ),
                ))
            ]
          )
        )
      );


  }
}