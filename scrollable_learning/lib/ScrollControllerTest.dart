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

  ScrollController scrollController = new ScrollController();
  bool showTopBtn = false;

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset >= 500 && showTopBtn == false) {
        setState(() {
          showTopBtn = true;
        });
      }
      if (scrollController.offset < 500 && showTopBtn == true) {
        setState(() {
          showTopBtn = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          child:
          new ListView.builder(
            controller: scrollController, itemBuilder: (context, index) {
            return new RandomContainer(height: 100, child: new Text("$index"),);
          }
            , itemCount: 20,)
      ),
      floatingActionButton: !showTopBtn ? null : new FloatingActionButton(
        onPressed: () {
          //点击返回顶部执行动画,jumpTo(double offset)、animateTo(double offset,...)：
          // 这两个方法用于跳转到指定的位置，它们不同之处在于，前者在跳转时会执行一个动画，而前者不会
          if (scrollController != null) {
//            scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.ease);
            scrollController.jumpTo(0);
          }
        }, child: new Icon(Icons.arrow_upward),),
    );
  }
}
