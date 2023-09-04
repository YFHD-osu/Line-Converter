import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Route/DetailData/car_order.dart';
import 'package:line_converter/Route/DetailData/car_serial.dart';
import 'package:line_converter/Route/DetailData/passenger_list.dart';

class MorningMainColumn extends StatelessWidget {
  const MorningMainColumn({super.key,
    required this.data, 
    required this.showMorning,
    required this.showEvening,
    required this.showHighlight,
    required this.highlightString
  });
  
  final bool? showMorning;
  final bool? showEvening;
  final bool? showHighlight;
  final List<CarData> data;
  final String highlightString;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    if (!(showMorning??true) && !(showEvening??true)) {
      return const Column(
        children: [
          Icon(Icons.all_inbox_outlined, size: 300),
          Text('未選取任何顯示種類')
        ],
      );
    }
    
    return Column(
      children: data.map((CarData index) {
        return Container(
          width: mediaQuery.size.width - 20,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          padding: const EdgeInsets.fromLTRB(5,5,5,5),
          decoration: BoxDecoration(
            color: theme.inputDecorationTheme.fillColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CarOrder(order: index.order),
                const SizedBox(width: 5),
                showMorning??true ? CarSerial(
                  serial: index.serial.morning,
                  icon: CupertinoIcons.sunrise
                ) : Container(),
                const SizedBox(width: 5),
                showEvening??true ? CarSerial(
                  serial: index.serial.evening,
                  icon: CupertinoIcons.sunset
                ) : Container()]
              ),
              PassengerList(
                headingText: '早',
                show: showMorning??true,
                data: index.passenger.morning,
                highlight: showHighlight??true ? highlightString : "",
              ),
              PassengerList(
                headingText: '晚',
                show: showEvening??true,
                data: index.passenger.evening, 
                highlight: showHighlight??true ? highlightString : "",
              )
            ]
          )
        ); /*data_view.PersonView(title: '早', passenger: index.passenger.morning);*/
      }).toList()
    );
  }
}