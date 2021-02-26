import 'package:flutter/material.dart';
import '../localdb.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<DrinkTime>> _data;

  @override
  Widget build(context) {
    _data = DrinkTime.getDrinkTimes();

    return FutureBuilder<List<DrinkTime>>(
      future: _data,
      builder: (context, AsyncSnapshot<List<DrinkTime>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: snapshot.data.reversed.map((DrinkTime item) {
                  return HistoryItem(item, _deleteDrinkTime);
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

  void _deleteDrinkTime() {
    _data = DrinkTime.getDrinkTimes();
    setState(() {});
  }
}

class HistoryItem extends StatelessWidget {
  final DrinkTime data;
  final Function deleteDrinkTime;
  HistoryItem(this.data, this.deleteDrinkTime);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.access_time_outlined),
      title: DrinkTimeText(data.createdAt.toString()),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever_outlined),
        onPressed: () {
          DrinkTime.deleteDrinkTime(data.id);
          deleteDrinkTime();
        },
      ),
    );
  }
}

class DrinkTimeText extends StatelessWidget {
  final String unit;
  DrinkTimeText(this.unit);

  @override
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
