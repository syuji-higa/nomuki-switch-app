import 'package:flutter/material.dart';
import '../localdb.dart';

const int measurementPeriod = 1000 * 60 * 60 * 24 * 7; // 一週間

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<int> _drinkCount;

  @override
  Widget build(BuildContext context) {
    _drinkCount = _getDrinkCount();

    return FutureBuilder<int>(
      future: _drinkCount,
      builder: (context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DrinkCountContainer(snapshot.data),
                  SizedBox(height: 40),
                  NomukiButtonContainer(_updateDrinkCount),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    ); 
  }

  Future<int> _getDrinkCount() async {
    List<DrinkTime> _drinkTimes = await DrinkTime.getDrinkTimes();

    int _count = 0;
    DateTime now = DateTime.now();
    int startedTimestamp = now.millisecondsSinceEpoch - measurementPeriod;

    for(DrinkTime data in _drinkTimes.reversed) {
      int createdAtTimestamp = data.createdAt.millisecondsSinceEpoch;
      if(startedTimestamp > createdAtTimestamp) {
        break;
      } 
      _count++;
    }
    return _count;
  }

  void _updateDrinkCount() {
    _drinkCount = _getDrinkCount();
    setState(() {});
  }
}

class DrinkCountContainer extends StatelessWidget {
  final int drinkCount;
  DrinkCountContainer(this.drinkCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DrinkCount(drinkCount),
        SizedBox(height: 4),
        DrinkCountDescText('飲んでいます'),
      ],
    );
  }
}

class DrinkCountDescText extends StatelessWidget {
  final String text;
  DrinkCountDescText(this.text);
  
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Theme.of(context).accentColor,
      ),
    );
  }
}

class DrinkCount extends StatelessWidget {
  final int drinkCount;
  DrinkCount(this.drinkCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        DrinkCountUnit('1週間以内に'),
        DrinkCountValue(drinkCount),
        DrinkCountUnit('回'),
      ]
    );
  }
}

class DrinkCountValue extends StatelessWidget {
  final int drinkCount;
  DrinkCountValue(this.drinkCount);

  @override
  Widget build(BuildContext context) {
    return Text(
      drinkCount.toString(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 60,
        color: Theme.of(context).accentColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 60.0,
      ),
    );
  }
}

class DrinkCountUnit extends StatelessWidget {
  final String unit;
  DrinkCountUnit(this.unit);
  Widget build(BuildContext context) {
    return Text(
      unit,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Theme.of(context).accentColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 72.0,
      ),
    );
  }
}

class NomukiButtonContainer extends StatelessWidget {
  final Function updateDrinkCount;
  NomukiButtonContainer(this.updateDrinkCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NomukiButton(updateDrinkCount),
        SizedBox(height: 16),
        Icon(
          Icons.arrow_upward_rounded,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 4),
        NomukiButtonDesc()
      ],
    );
  }
}

class NomukiButton extends StatelessWidget {
  final Function updateDrinkCount;
  NomukiButton(this.updateDrinkCount);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.amber,
        shape: CircleBorder(),
      ),
      child: SizedBox(
        height: 100.0,
        width: 100.0,
        child: IconButton(
          icon: Icon(
            Icons.sports_bar_outlined,
            size: 40.0
          ),
          color: Colors.white,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return StartedDialog();
              },
            );
            _addDrinkTime();
            updateDrinkCount();
          },
        ),
      ),
    );
  }
}

class NomukiButtonDesc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '飲む前にタップ',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class StartedDialog extends StatelessWidget {
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('今日も楽しく飲みましょう！'),
      actions: <Widget>[
        RaisedButton(
          color: Colors.amber,
          textColor: Colors.white,
          child: Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

void _addDrinkTime() async {
  DrinkTime _drinkTime = DrinkTime();
  await DrinkTime.insertDrinkTime(_drinkTime);
}
