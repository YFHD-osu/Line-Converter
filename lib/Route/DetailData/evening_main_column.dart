import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:line_converter/Library/typing.dart';
import 'package:line_converter/Route/DetailData/car_order.dart';
import 'package:line_converter/Route/DetailData/car_serial.dart';
import 'package:line_converter/Route/DetailData/passenger_list.dart';

class EveningMainColumn extends StatelessWidget {
  const EveningMainColumn({super.key,
    required this.data, 
    required this.followOrder,
    required this.showHighlight,
    required this.highlightString
  });
  
  final bool? followOrder;
  final bool? showHighlight;
  final List<CarData> data;
  final String highlightString;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    List<CarData> dataList = data;
    if (!(followOrder??true)) {
      dataList.sort(((a, b) => a.order.compareTo(b.order)));
    }
    
    return Column(
      children: dataList.map((CarData index) {
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
                CarSerial(
                  serial: index.serial.morning,
                  icon: CupertinoIcons.sunrise
                )]
              ),
              PassengerList(
                headingText: '晚',
                show: true,
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