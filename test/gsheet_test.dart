import 'package:flutter/material.dart';
import 'package:line_converter/core/typing.dart';
import 'package:http/http.dart' as http;

const List weekString = ['', '一', '二', '三', '四', '五', '六', '日', '一'];
const int maxColumn = 3;

String getCredential() {
  return r'''
  {
    "type": "service_account",
    "project_id": "dulcet-cat-359804",
    "private_key_id": "0cbbe61fea5972d008484037f5533ef1ee79e210",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOHLYPtG/xKuBG\nPF2ATjSdoeD79qMWb7TeYIuXpnOLB1U9azOi4JOQeVDcKbPYBT0g9v7C4aBGtuKR\nxiRJB2dLMaOZiBS7LzepMo8T7CgjQU+QaLmYTZeKmovf9tQP03vDFkaBrYN03Pkt\n5g/HB6tjUIdtwnCJC1oQvKOu3JkOGu8DXTZiRrMh/cxDYfxBl9jUDnGVyGhaw4I9\nz0+DXLFm7K+JUUEwm+UZpBm7OQx/kzgcd7cp6m8QBRSW5pys+bYs6KiBxsjZwCMb\nJ2Nahtpz/YJpmiqP0Bt2CTIiKja/kA9KxNp0ThxVb0pqdjNlgPnsG+2gE43BO42a\njMZT74vJAgMBAAECggEAAM96Spe3virtF9ZouoNUNjx3nhxrQ404slkoPPZRscqO\nsL+i3XFk0yaCK8nal0jDlt7k9vVpKm4Eq3SsGg3P5hFLZrEMywTVnLI1f550zlkV\nS+jFgtsac4tfbaGF778x10oKolVOCFMbUO1jKX6wholZOi32DR8aZ9w+CCCw72Fb\nUsWxOjzVa8FNTMqFDlH1Lel2ScIyWgUbNlOtAejink6rx3cwEjuW70dXPyzksmCj\n4WbHn7Rud8eMJXpMMhgEB35fP+n5z84dARremoW/mw8p3zohDLaIzu1RyFt4zfu3\n2eyMdhry2fviiaJrlBjrtDOzGdfzNEsQbqmBDYLRYwKBgQDxzWjLmPAx7hYaluO4\n4t2Y+6uuXkK9c5gc270h/Vbq88SRKnDrkFpcyTEepynXTAAggE4EoigjQ5xUxfcc\nyq2ue6N1rtezbAeB9m443Yt8hpyZbaaNiBnU3TPnt8BzY44ehQcsW3AC10ItlnSF\nCqzgBy4z+BlaP5JMkI8bufltHwKBgQDaNtVS6kIU7tc/iec4Gt1RKRu78cziau/C\niAfpY/TClT2wXVHYChekqGPBpMIlu7vDoEZ7HRyfoXqa1igmYwfcEp9bRPOHSqET\nkLtxOfmNAcYbW+nNRIYsgkFdA/BoNaO7SRGjHbmvRAalgE32KQ9Ohahh/sAKI1G1\nvN3c2kOCFwKBgQCivSimvowKTr85rgwdxzJ1YAywEmjAsSfTZGDqm2MARogpW3Mc\nV885W39frgoPCOuc9D2OCMUS1tJEi+hAzHgQUs40yjQKYc67vWt5gkH60W5cJNxP\nrSYVibsBXT59aqegCtBFHlVI1C+KFxTc5c5sCOkjuPr3Lon8Vd67PnOM6QKBgH7K\nA3MU1+aPzBOIDgfkXBmvOAUg/rnEBqFSJr6uLGXvDxPtdQOBAbHTgXrfP0trZDLL\naohYJux9h951doivW768N0lxq8o9S5AxtSeZ1uzeTfxRkGyLVyZ/XHkuM75pBERq\ntUvAlsZGUVJSVXok61blhCvEOFLrqKtfHM4ZJ8ZrAoGAY1BKb/83fJowpdZ4w2OY\nrTyNZr1xPmnDu+omwaOhT8GXGXtF9kzcNEbD14eRxjYCpc4qwk/tyx8g2XzJ/lKn\nWJ1RcZ0oHvP9Q4r+5Opw3dmnlsMcM/ekLD21rD+Q058YxVXvnOdl4b3VZyV/UbOT\n8LVfFWkHPnB3QoBCC2JygmI=\n-----END PRIVATE KEY-----\n",
    "client_email": "yfhd-sheets-client@dulcet-cat-359804.iam.gserviceaccount.com",
    "client_id": "115151941743082732398",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/yfhd-sheets-client%40dulcet-cat-359804.iam.gserviceaccount.com"
  }
  ''';
}

List<List<String>> getMorningList(List<CarData> data) {
  for (int i=0; i<maxColumn ; i++) {

  }

  return [[]];
}

const sheetID = '17U7FXfIGVBtZGPb-Ndw0W3HPCx9ZBvLh-o1e_QNdlCw';
const sheetName = 'example';
void main() async {
  Map<String, String> payload = {
    "iss": "message-converter@dulcet-cat-359804.iam.gserviceaccount.com",
    "scope": "https://www.googleapis.com/auth/spreadsheets.readonly",
    "aud": "https://www.googleapis.com/oauth2/v4/token",
    "iat": "1672085129",
    "exp": "1672085189"
  };

  Map<String, String> header = {
    "alg": "RS256",
    "typ": "JWT"
  };

  header;

  final url = Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/$sheetID/values/$sheetName?alg=RS256&typ=JWT');

  final response = await http.get(url, headers: payload);
  debugPrint(response.body);

}