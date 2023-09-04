import 'package:flutter/material.dart';

class TopButtonRow extends Container{

  TopButtonRow({
    super.key,
    required BuildContext context,
    required void Function()? cancel,
    required void Function()? confirm, 
    required String title,
    String confirmText = '確認',
    String cancelText = '取消',
  }) : super (
    decoration: BoxDecoration(
      color: Colors.grey.shade800,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15)
      ) 
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 5),
        TextButton(
          
          onPressed: cancel, 
          child: Text(cancelText, style: const TextStyle(fontSize: 20))
        ),
        const Spacer(),
        Text(title, style: const TextStyle(fontSize: 25)),
        const Spacer(),
        TextButton(
          onPressed: confirm, 
          child: Text(confirmText, style: const TextStyle(fontSize: 20))
        ),
        const SizedBox(width: 5)
      ]
    )
  );
}