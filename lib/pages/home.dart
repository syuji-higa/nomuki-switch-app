import 'package:flutter/material.dart';
import '../localdb.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            NumberOfTimesContainer(),
            SizedBox(height: 40),
            NomukiButtonContainer(),
          ],
        ),
      ),
    );
  }
}

class NumberOfTimesContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NumberOfTimes(),
        SizedBox(height: 4),
        NumberOfTimesDescText('飲んでいます'),
      ],
    );
  }
}

class NumberOfTimesDescText extends StatelessWidget {
  final String text;
  NumberOfTimesDescText(this.text);
  
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

class NumberOfTimes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        NumberOfTimesUnit('1週間以内に'),
        NumberOfTimesValue('0'),
        NumberOfTimesUnit('回'),
      ]
    );
  }
}

class NumberOfTimesValue extends StatelessWidget {
  final String value;
  NumberOfTimesValue(this.value);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
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

class NumberOfTimesUnit extends StatelessWidget {
  final String unit;
  NumberOfTimesUnit(this.unit);
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
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        NomukiButton(),
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
          onPressed: _addDrinkTime,
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

void _addDrinkTime() async {
  DrinkTime _drinkTime = DrinkTime();
  await DrinkTime.insertDrinkTime(_drinkTime);
}
