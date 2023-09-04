import 'package:flutter/material.dart';
import 'package:line_converter/Page/DataPage/mode_switch.dart';
import 'package:line_converter/Route/DetailData/evening_detail_data.dart';
import 'package:line_converter/Route/DetailData/morning_detail_data.dart';

const List weekString = ['', '一', '二', '三', '四', '五', '六', '日'];

class IndexTile extends StatelessWidget {
  const IndexTile({
    super.key,
    required this.data,
    required this.showType
  });
  final ShowType showType;
  final Map<String, Object?> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final DateTime addTime = DateTime.parse(data['addTime'] as String);

    return InkWell(
      child: Container(
        color: Colors.red,
        child: Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.hardEdge,
          children: [
            Container(
              color: const Color(0xFFFF8B66),
              child: Image(
                fit: BoxFit.fill,
                width: mediaQuery.size.width - 20,
                height: (mediaQuery.size.width - 20) * 250 / 1010,
                image: showType == ShowType.morning ? 
                  const AssetImage('assets/img_breakfast.jpg'):
                  const AssetImage('assets/img_cyclingbmx.jpg'),
              )
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                '',
                style: Theme.of(context).textTheme.titleSmall),
            ),
            Container(
              padding: const EdgeInsets.only(right: 5, left: 5),
              decoration: BoxDecoration(
                color: theme.inputDecorationTheme.fillColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15)
                )
              ),
              child: Text(
                '${addTime.year}年${addTime.month}月${addTime.day}日 (${weekString[addTime.weekday]})',
                style: Theme.of(context).textTheme.labelMedium),
            )
          ],
        )
      ),
      onTap: () {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) =>
            showType == ShowType.morning ? 
              MorningDetailDataRoute(data: data):
              EveningDetailDataRoute(data: data)
          )
        );
      },
    );
  }
}