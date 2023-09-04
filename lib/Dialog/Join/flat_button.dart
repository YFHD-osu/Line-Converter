import 'package:flutter/material.dart';

enum Result {never, failed, success, loading}

class FlatButtonController {
  bool value = false;
  Result result = Result.never;

}

// ignore: must_be_immutable
class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.icon,
    required this.text,
    required this.opTap,
    required this.controller
  });

  final String text;
  final IconData icon;
  final FlatButtonController controller;
  final VoidCallback? opTap;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {

  Color getBorderColor() {
    if (widget.controller.result != Result.never &&
        widget.controller.result != Result.loading
    ) return Colors.transparent;
    return (widget.controller.value) ? Colors.green : Colors.transparent;
  } 

  Color? getBackground() {
    switch(widget.controller.result) {
      case Result.never: return null;
      case Result.loading: return null;
      case Result.failed: return Colors.red;
      case Result.success: return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            onTap: (widget.controller.result != Result.never) ? null : () {
              setState(() => widget.controller.value = !widget.controller.value);
              widget.opTap?.call();
            },
            child: AnimatedContainer(
              height: double.infinity, width: double.infinity,
              padding: const EdgeInsets.all(5),
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: getBackground(),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: getBorderColor(), width: 4
                )
              ),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Icon(widget.icon, size: constraint.biggest.height);
                    })
                  ),
                  Text(widget.text)
                ]
              )
            )
          ),
          Visibility(
            visible: widget.controller.result == Result.loading,
            child: const SizedBox(
              height: 5, width: double.infinity,
              child: LinearProgressIndicator(),
            )
          )
        ]
      )
    );
  }
}