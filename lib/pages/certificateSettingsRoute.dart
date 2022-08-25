import 'package:flutter/material.dart';

class CertificateSettingsRoute extends StatefulWidget {
  const CertificateSettingsRoute({Key? key}) : super(key: key);

  @override
  State<CertificateSettingsRoute> createState() => _CertificateSettingsRouteState();
}

class _CertificateSettingsRouteState extends State<CertificateSettingsRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0, toolbarHeight: 0),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
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
                            child: Center(child: Text('表單憑證', style: Theme.of(context).textTheme.titleLarge))
                        )
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 16, 0, 10),
                        child: Material(
                          clipBehavior: Clip.hardEdge,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          color: Theme.of(context).inputDecorationTheme.fillColor,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_ios_rounded)
                          ),
                        )
                    )
                  ],
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: TextField(
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
                              hintText: "輸入 Google Cloud Platform 憑證",
                              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                              filled: true,
                            ),
                          ),
                        ),
                        Row(
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

                                },
                                label: const Text('清除', style: TextStyle(color: Colors.white, fontSize: 15)),
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
                                onPressed: () async {

                                },
                                label: const Text('儲存', style: TextStyle(color: Colors.white, fontSize: 15)),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                )
              ],
            ),
          ),
        )
    );
  }
}