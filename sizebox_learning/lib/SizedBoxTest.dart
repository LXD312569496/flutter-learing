import 'package:flutter/material.dart';
import 'package:random_pk/random_pk.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SizedBox.expand(
        child: new RandomContainer(
          child: buildColumn(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new SizedBox(
          width: 100,
          height: 100,
          child: new RandomContainer(
            child: new Text("指定height和width"),
          ),
        ),
        new SizedBox(
          width: 100,
          height: 100,
        ),
        new SizedBox(
          width: 100,
          child: new RandomContainer(
            child: new Text("指定width"),
          ),
        ),
        new SizedBox(
          height: 100,
          child: new RandomContainer(
            child: new Text("指定height"),
          ),
        ),
        new ConstrainedBox(
          constraints: BoxConstraints(minHeight: 50),
          child: new RandomContainer(
            child: new Text("ConstrainedBox,minHeight: 50"),
          ),
        ),

        new RandomContainer(
          width: 100,
          height: 100,
          child: new OverflowBox(
            maxWidth: 200,
            maxHeight: 200,
            child: new RandomContainer(
              width: 300,
              height: 200,
              child: new Text("OverflowBox"),
            ),
          ),
        ),




      ],
    );
  }

  FractionallySizedBox buildFractionallySizedBox() {
    return new FractionallySizedBox(
      heightFactor: 0.5,
      widthFactor: 0.5,
//      alignment: Alignment.center,
      alignment: Alignment(0, 0),
      child: RandomContainer(),
    );
  }
}
