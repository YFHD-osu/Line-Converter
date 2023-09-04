import 'package:flutter/material.dart';
import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Library/main_parser.dart';
import 'package:line_converter/Dialog/Join/data_view.dart';
import 'package:line_converter/Dialog/Join/blank_view.dart';
import 'package:line_converter/Dialog/Join/error_view.dart';

class DataViewDialog {
  late final BuildContext context;
  late final AnimationController? animation;
  late final TextEditingController person;
  late final TextEditingController car;

  late List<CarData> result;
  late List<ParseException> errors;

  bool isProcessing = false;

  DataViewDialog({
    required this.context,
    required this.animation,
    required this.person,
    required this.car
  });

  Widget build(BuildContext context) {
    if (result.isEmpty) return empty(context);

    if (errors.isNotEmpty) return error(context, errors);

    return preview(context, result);

  }

  Future<void> parse() async {
    final data = MainPraser(personMessage: person.text, carIDMessage: car.text);
    late final List<CarData> result;
    late final List<ParseException> errors;
    (result, errors) = data.parse();
    this.result = result;
    this.errors = errors;
  
    await show();
  }

  Future<void> show() async =>
    await showModalBottomSheet(
      context: context,
      enableDrag: !isProcessing,
      useSafeArea: true,
      isDismissible: !isProcessing,
      isScrollControlled: true,
      transitionAnimationController: animation,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (context) => DraggableScrollableSheet(
        snap: false,
        expand: false,
        maxChildSize: 0.89,
        minChildSize: 0.89,
        initialChildSize: 0.89,
        builder: (context, scrollController) => build(context)
      )
    );
}