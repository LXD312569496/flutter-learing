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
      body: new Container(
          child:
//              buildSingleChildScrollView()
//              buildListView()
//          buildGridView()
          buildCustomScrollView()
      ),
    );
  }
}

/*
ListView.builder适合列表项比较多（或者无限）的情况，
因为只有当子Widget真正显示的时候才会被创建。
在ListView中，指定itemExtent比让子widget自己决定自身长度会更高效，
这是因为指定itemExtent后，滚动系统可以提前知道列表的长度，而不是总是动态去计算，尤其是在滚动位置频繁变化时（滚动系统需要频繁去计算列表高度）。
 */
Widget buildListView() {
//  return ListView.builder(itemBuilder: (context, index) {
//    return new Text("$index");
//  }, itemCount: 10, itemExtent: 50,);
  return ListView.separated(itemBuilder: (context, index) {
    debugPrint("itemBuilder:$index");
    return new Text("$index");
  }, itemCount: 10,
    separatorBuilder: (context, index) {
      debugPrint("separatorBuilder:$index");
      return new Divider();
    },);
}

/*
SingleChildScrollView+Column
使用column和默认的ListView方法，需要一个children参数，就需要将所有的children都提前创建好后再能显示，
而不是等到子Widget真正显示的时候才去创建。这两种方法，适用于只有少量子Widget的情况。
可滚动widget通过一个List来作为其children属性时，只适用于子widget较少的情况，这是一个通用规律，并非ListView自己的特性，像GridView也是如此
 */
Widget buildSingleChildScrollView() {
  String string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  List<Widget> list = new List();
  for (int i = 0; i < string.length; i++) {
    list.add(new SizedBox(height: 50, child: new Text(string[i]),));
  }

  return new Scrollbar(child: new SingleChildScrollView(
    child: new Center(
      child: new Column(
        children: list,
      ),
    ),
  ));
}


Widget buildGridView() {
  //flutter_staggered_grid_view ,一个可以实现瀑布流的复杂GridView插件
  /**
   * SliverGridDelegateWithFixedCrossAxisCount,一个纵轴为固定数量子元素的layout算法
   * GridView.count内部就是使用了SliverGridDelegateWithFixedCrossAxisCount
   * crossAxisCount固定每一行的数量，childAspectRatio设置宽高比
   */
//  return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//      crossAxisCount: 3, childAspectRatio: 1.0),
//    children: <Widget>[
//      new RandomContainer(
//        child: Icon(Icons.ac_unit),
//      ),
//      new RandomContainer(
//        child: Icon(Icons.airport_shuttle),
//      ),
//      new RandomContainer(
//        child: Icon(Icons.beach_access),
//      ),
//      Icon(Icons.airport_shuttle),
//      Icon(Icons.all_inclusive),
//      Icon(Icons.beach_access),
//      Icon(Icons.cake),
//      Icon(Icons.free_breakfast),
//      Icon(Icons.ac_unit),
//      Icon(Icons.airport_shuttle),
//      Icon(Icons.all_inclusive),
//      Icon(Icons.beach_access),
//      Icon(Icons.cake),
//      Icon(Icons.free_breakfast)
//    ],);

  /**
   * SliverGridDelegateWithMaxCrossAxisExtent，一个纵轴子元素为固定最大长度的layout算法
      GridView.extent就是用了SliverGridDelegateWithMaxCrossAxisExtent。
      注意：最大长度的意思，是因为纵轴方向每个子元素的长度仍然是等分的。
      如果ViewPort的纵轴长度是450，那么当maxCrossAxisExtent的值在区间(450/4，450/3]内的话，子元素最终实际长度都为150，
      而childAspectRatio所指的子元素纵轴和主轴的长度比为最终的长度比
   */
//  return GridView(gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
//      maxCrossAxisExtent: 100,childAspectRatio: 1),
//    children: <Widget>[
//      new RandomContainer(
//        child: Icon(Icons.ac_unit),
//      ),
//      new RandomContainer(
//        child: Icon(Icons.airport_shuttle),
//      ),
//      new RandomContainer(
//        child: Icon(Icons.beach_access),
//      ),
//      Icon(Icons.airport_shuttle),
//      Icon(Icons.all_inclusive),
//      Icon(Icons.beach_access),
//      Icon(Icons.cake),
//      Icon(Icons.free_breakfast),
//      Icon(Icons.ac_unit),
//      Icon(Icons.airport_shuttle),
//      Icon(Icons.all_inclusive),
//      Icon(Icons.beach_access),
//      Icon(Icons.cake),
//      Icon(Icons.free_breakfast)
//    ],);

  return new GridView.builder(
    gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100, childAspectRatio: 1),
    itemBuilder: (context, index) {
      return new RandomContainer(
        child: new Center(child: new Text("$index"),),);
    },
    itemCount: 20,);
}

/**
 * 使用场景：假设有一个页面，顶部需要一个GridView，底部需要一个ListView，而要求整个页面的滑动效果是统一一致的，即它们看起来是一个整体，如果使用GridView+ListView来实现的话，就不能保证一致的滑动效果，因为它们的滚动效果是分离。
 * 原理：对于大多数Sliver来说，它们和可滚动Widget最主要的区别是Sliver不会包含Scrollable Widget，也就是说Sliver本身不包含滚动交互模型 ，正因如此，CustomScrollView才可以将多个Sliver"粘"在一起，这些Sliver共用CustomScrollView的Scrollable，最终实现统一的滑动效果
 *
 */
Widget buildCustomScrollView(){
  return  CustomScrollView(
      slivers: <Widget>[
        //AppBar，包含一个导航栏
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Demo'),
            background:
//            Image.network(
//              "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1544431103&di=ec49d1305e18a453363f892e42b05af0&imgtype=jpg&er=1&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F014565554b3814000001bf7232251d.jpg%401280w_1l_2o_100sh.png", fit: BoxFit.cover,),
        new Center(
          child: new Column(
            children: <Widget>[
              new SizedBox(height: 50,),
              new RandomContainer(width: 150,height: 150,),
              new Text("登录")
            ],
          ),
        )
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: new SliverGrid( //Grid
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 4.0,
            ),
            delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                //创建子widget
                return new Container(
                  alignment: Alignment.center,
                  color: Colors.cyan[100 * (index % 9)],
                  child: new Text('grid item $index'),
                );
              },
              childCount: 20,
            ),
          ),
        ),
        //List
        new SliverFixedExtentList(
          itemExtent: 50.0,
          delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                //创建列表项
                return new Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: new Text('list item $index'),
                );
              },
              childCount: 50 //50个列表项
          ),
        ),
      ],

  );
}