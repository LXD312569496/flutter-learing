import 'package:flutter/material.dart';

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
  bool isLargeScreen; //是否是大屏幕

  var selectValue = 0; //保存选择的内容

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new OrientationBuilder(builder: (context, orientation) {
        print("width:${MediaQuery.of(context).size.width}");
        print("height:${MediaQuery.of(context).size.height}");
        //判断屏幕宽度
        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        //两个widget是放在一个Row中进行显示，如果是小屏幕的话，用一个空的Container进行占位
        //如果是大屏幕的话，则用Expanded进行屏幕的划分并显示详细视图
        return new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(child: new ListWidget(
              itemSelectedCallback: (value) {
                //定义列表项的点击回调
                if (isLargeScreen) {
                  selectValue = value;
                  setState(() {});
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new DetailWidget(value);
                  }));
                }
              },
            )),
            isLargeScreen
                ? new Expanded(child: new DetailWidget(selectValue))
                : new Container()
          ],
        );
      }),
    );
  }
}

//定义一个回调，决定是在同一个屏幕上显示更改详细视图还是在较小的屏幕上导航到不同界面。
typedef Null ItemSelectedCallback(int value);

//列表的Widget
class ListWidget extends StatelessWidget {
  ItemSelectedCallback itemSelectedCallback;

  ListWidget({@required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text("$index"),
            onTap: () {
              this.itemSelectedCallback(index);
            },
          );
        });
  }
}

//详细视图的Widget
class DetailWidget extends StatelessWidget {
  final int data;

  DetailWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: new Center(
          child: new Text("详细视图:$data"),
        ),
      ),
    );
  }
}
