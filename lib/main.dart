import 'package:flutter/material.dart';
import 'header.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '飲む気スイッチ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: Header(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElapsedTimeContainer(),
              SizedBox(height: 40),
              NomukiButtonContainer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ElapsedTimeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElapsedTimeDescText('最後に飲んでから'),
        ElapsedTime(),
        SizedBox(height: 8),
        ElapsedTimeDescText('が経過しています'),
      ],
    );
  }
}

class ElapsedTimeDescText extends StatelessWidget {
  final String text;
  ElapsedTimeDescText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Theme.of(context).primaryColor,
      )
    );
  }
}

class ElapsedTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ElapsedTimeValue('00'),
        ElapsedTimeUnit('日'),
        SizedBox(width: 8),
        ElapsedTimeValue('00'),
        ElapsedTimeUnit('時'),
        SizedBox(width: 8),
        ElapsedTimeValue('00'),
        ElapsedTimeUnit('分'),
      ]
    );
  }
}

class ElapsedTimeValue extends StatelessWidget {
  final String value;
  ElapsedTimeValue(this.value);
  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 50,
        color: Theme.of(context).primaryColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 50.0,
      ),
    );
  }
}

class ElapsedTimeUnit extends StatelessWidget {
  final String unit;
  ElapsedTimeUnit(this.unit);
  Widget build(BuildContext context) {
    return Text(
      unit,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: Theme.of(context).primaryColor,
      ),
      strutStyle: StrutStyle(
        fontSize: 60.0,
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
        SizedBox(height: 24),
        Icon(
          Icons.arrow_upward_rounded,
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: 8),
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
        color: Colors.lightBlue,
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
          onPressed: () {},
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
