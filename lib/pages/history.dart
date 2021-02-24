import 'package:flutter/material.dart';
import '../loacldb.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(context) {
    return FutureBuilder<List<DrinkTime>>(
      future: _getDrinkTimes(),
      builder: (context, AsyncSnapshot<List<DrinkTime>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: snapshot.data.reversed.map((DrinkTime item) {
                  return HistoryItem(item);
                }),
              ).toList(),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class HistoryItem extends StatelessWidget {
  final DrinkTime data;
  HistoryItem(this.data);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: DrinkTimeText(data.createdAt.toString()),
    );
  }
}

class DrinkTimeText extends StatelessWidget {
  final String unit;
  DrinkTimeText(this.unit);
  Widget build(BuildContext context) {
    return Text(
      unit,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

Future<List<DrinkTime>> _getDrinkTimes() async {
  List<DrinkTime> _drinkTimes = await DrinkTime.getDrinkTimes();
  return _drinkTimes;
}
