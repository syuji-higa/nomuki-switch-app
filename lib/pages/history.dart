import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                  return HistoryItem(item, _updateDrinkTime);
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

  void _updateDrinkTime() {
    _data = DrinkTime.getDrinkTimes();
    setState(() {});
  }
}

class HistoryItem extends StatelessWidget {
  final DrinkTime data;
  final Function updateDrinkTime;
  HistoryItem(this.data, this.updateDrinkTime);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.access_time_outlined),
      title: DrinkTimeText(data.createdAt),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever_outlined),
        onPressed: () async {
          bool isDelete = await showDialog(
            context: context,
            builder: (BuildContext context) {
              String createdAtText = DateFormat('yyyy年MM月dd日 HH時mm分').format(data.createdAt);
              return Dialog('$createdAtText の履歴を削除しますか？');
            },
          );

          if(isDelete) {
            DrinkTime.deleteDrinkTime(data.id);
            updateDrinkTime();
          }
        },
      ),
    );
  }
}

class Dialog extends StatelessWidget {
  final String text;
  Dialog(this.text);

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(text),
      actions: <Widget>[
        RaisedButton(
          color: Colors.amber,
          textColor: Colors.white,
          child: Text('いいえ'),
          onPressed: () => Navigator.pop(context, false),
        ),
        RaisedButton(
          color: Colors.amber,
          textColor: Colors.white,
          child: Text('はい'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}

class DrinkTimeText extends StatelessWidget {
  final DateTime createdAt;
  DrinkTimeText(this.createdAt);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('yyyy年MM月dd日 HH時mm分').format(createdAt),
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
