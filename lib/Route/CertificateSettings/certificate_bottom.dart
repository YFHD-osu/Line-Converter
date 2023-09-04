import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_converter/Route/CertificateSettings/certificate_section.dart';

class CertificateBottom extends StatelessWidget {
  const CertificateBottom({
    super.key,
    required this.certificateKey,
    required this.errorMessage
  });
  final GlobalKey<CertificateSectionState> certificateKey;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final state = certificateKey.currentState!;
    final context = jsonDecode(state.cert??'{}');
    
    if (errorMessage!=null) {
      return Row(
        children: [
          const Icon(Icons.error_rounded, size: 125),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              text: errorMessage,
              style: const TextStyle(fontSize: 30)
            )
          )
        ],
      );
    }

    if (state.cert == null) {
      return Row(
        children: [
          const Icon(Icons.account_circle, size: 125),
          RichText(
            textAlign: TextAlign.start,
            text: const TextSpan(
              text: '請貼上憑證',
              style: TextStyle(fontSize: 30)
            )
          )
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.account_circle, size: 125),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('服務帳號', 
              style: TextStyle(fontSize: 30)
            ),
            Text('${context["client_email"]}', 
              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.normal)
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.only(bottom: 2)),
              ),
              child: const Text(' 複製 ', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: context["client_email"]??""));
              }
            )
          ]
        )
      ]
    );
  }
}