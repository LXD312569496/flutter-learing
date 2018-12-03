import 'package:flutter/material.dart';
import 'dart:math' as math;

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
      body: new Container(
        child:

        buildScale(),
      ),
    );
  }

  /**注意的地方：
   * Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，所以无论对子widget应用何种变化，其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的
    区别：RotatedBox的变换是在layout阶段，会影响在子widget的位置和大小
   */

  /*
Transform.translate接收一个offset参数，可以在绘制时沿x、y轴对子widget平移指定的距离。
 */
  Widget buildTranslate() {
    return new Container(
      color: Colors.red,
      child: new Transform.translate(offset: Offset(50, 50),
        child: new Text("Hello Wolrd"),),
    );
  }

  /*
  旋转,Transform.rotate可以对子widget进行旋转变换
   */
  Widget buildRotate() {
    return new Container(
      color: Colors.red,
      child: new Transform.rotate(angle: math.pi / 2,
        child: new Text("Hello Wolrd"),),
    );
  }

  /*
  缩放：Transform.scale可以对子Widget进行缩小或放大
   */
  Widget buildScale() {
    return new Container(
      color: Colors.red,
      child: new RotatedBox(
        child: new Text("Hello Wolrd"), quarterTurns: 2,),
    );
  }
}

