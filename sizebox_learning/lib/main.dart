import 'package:flutter/material.dart';
import 'package:random_pk/random_pk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(child: buildColumn()),
    );
  }

  /**
   * 主要是学习SizeBox的几种使用方法，一般是用来限制孩子控件的大小
   * SizeBox()
   * SizeBox.expand()
   * SizeBox.fromSize()
   * SizedOverflowBox()
   * FractionallySizedBox()
   *
   *还有这么一种场景也可以使用SizeBox，就是可以代替padding和container，然后
   * 用来设置两个控件之间的间距，比如在行或列中就可以设置两个控件之间的间距
   * 主要是可以比使用一个padding或者container简单方便
   */

  /*
  一般的用法
  Sizebox会强制它的孩子的大小
   */
  buildSizebox() {
    return new RandomContainer(
      child: new SizedBox(
        width: 100,
        height: 100,
        child: new FlutterLogo(),
      ),
    );
  }

  /*
   * Sizebox.expand
   *会充满sizebox的父控件
   */
  RandomContainer buildSizeboxExpand() {
    return new RandomContainer(
        child: new SizedBox.expand(
      child: new FlutterLogo(),
    ));
  }

  /*
   * Sizebox的另外一种使用方法.
    参数是Size
   * 比如下面利用屏幕的size信息进行设置SizeBox的大小
   */
  buildSizeboxFromSize() {
    var deviceSize = MediaQuery.of(context).size;
    return new RandomContainer(
      child: new SizedBox.fromSize(
        size: Size(100, 100),
        child: FlutterLogo(),
      ),
//      child: new SizedBox.fromSize(size: deviceSize/2,child: FlutterLogo(),),
    );
  }

  /*
  SizedOverflowBox,允许sizebox里面的child大小比sizebox大，导致溢出显示
  而且还有个alignment的参数，可以用来设置sizebox里面的child的位置
   */
  buildSizedOverflowBox() {
    return new RandomContainer(
      child: new SizedOverflowBox(
        size: Size(100, 100),
        alignment: Alignment.bottomRight,
        child: new FlutterLogo(
          size: 50,
        ),
      ),
    );
  }

  /*
FractionallySizedBox,可以用百分比来控制sizebox的大小
widthFactor，heightFactor参数就是相对于父控件的比例
alignment：可以设置sizebox在父控件里面的相对位置
   */
  buildFractionallySizedBox() {
    return new RandomContainer(
      width: 200,
      height: 200,
      child: new FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 0.4,
        heightFactor: 0.4,
        child: new FlutterLogo(),
      ),
    );
  }

  /*
   * 在行或者列中，使用SizedBox来代替padding或者container来设置间距
   */
  buildColumn() {
    return new SafeArea(
        child: new Column(
      children: <Widget>[
        new Text(
          "11111",
          style: new TextStyle(fontSize: 30),
        ),
        new SizedBox(height: 20,),
        new Text(
          "22222",
          style: new TextStyle(fontSize: 30),
        ),
        new SizedBox(height: 20,),
        new Text(
          "33333",
          style: new TextStyle(fontSize: 30),
        ),
      ],
    ));
  }
}
