# future_builder_learning

主要是学习FutureBuilder的使用，利用FutureBuilder来实现懒加载，并可以监听加载过程的状态
这个Demo是加载玩Android的一个页面的列表数据

![](https://github.com/LXD312569496/flutter-learing/blob/master/future_builder_learning/future_builder.jpg)

## Getting Started

### 1.需求场景
经常有这些场景，就是先请求网络数据并显示加载菊花，拿到数据后根据请求结果显示不同的界面，
比如请求出错就显示error界面，响应结果里面的列表数据为空的话，就显示数据为空的界面，有数据的话，
就把列表数据加载到列表中进行显示.

### 2.需要用到的控件
#### 下拉刷新RefreshIndicator，列表ListView，这里不做过多介绍
#### FutureBuilder:Flutter应用中的异步模型，基于与Future交互的最新快照来构建自身的widget

官方文档：[https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html](https://docs.flutter.io/flutter/widgets/FutureBuilder-class.html)

```
const FutureBuilder({
    Key key,
    this.future,//获取数据的方法
    this.initialData,
    @required this.builder//根据快照的状态，返回不同的widget
  }) : assert(builder != null),
       super(key: key);
```

future就是一个定义的异步操作，注意要带上泛型，不然后面拿去snapshot.data的时候结果是dynamic的
snapshot就是future这个异步操作的状态快照，根据它的connectionState去加载不同的widget
有四种快照的状态：
```
enum ConnectionState {
   //future还未执行的快照状态
  none,
  //连接到一个异步操作，并且等待交互，一般在这种状态的时候，我们可以加载个菊花
  waiting,
  //连接到一个活跃的操作，比如stream流，会不断地返回值，并还没有结束，一般也是可以加载个菊花
  active,
  //异步操作执行结束，一般在这里可以去拿取异步操作执行的结果，并显示相应的布局
  done,
}
```
下面的官方的例子。

```
FutureBuilder<String>(
  future: _calculation, // a previously-obtained Future<String> or null
  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('Press button to start.');
      case ConnectionState.active:
      case ConnectionState.waiting:
        return Text('Awaiting result...');
      case ConnectionState.done:
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        return Text('Result: ${snapshot.data}');
    }
    return null; // unreachable
  },
)
```

### 3.实现思路，布局方式
· 网络请求：利用Dio库来请求玩Android的知识体系列表，api:[http://www.wanandroid.com/tree/json](http://www.wanandroid.com/tree/json)
序列化json：利用json_serializable来解析返回的json数据

布局：加载过程显示CircularProgressIndicator，加载完成把数据显示到ListView中，
加载为空或者加载出错的话，显示相应的提示页面，并可以进行重试请求
一般我们的列表页面都是有下拉刷新的功能，所以这里就用RefreshIndicator来实现。


### 4.代码实现
```
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'entity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilderPage(),
    );
  }
}

class FutureBuilderPage extends StatefulWidget {
  @override
  _FutureBuilderPageState createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {
  Future future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    future = getdata();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("知识体系"),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: buildFutureBuilder(),
      floatingActionButton: new FloatingActionButton(onPressed: () {
        setState(() {
          //测试futurebuilder是否进行没必要的重绘操作
        });
      }),
    );
  }

  FutureBuilder<List<Data>> buildFutureBuilder() {
    return new FutureBuilder<List<Data>>(
      builder: (context, AsyncSnapshot<List<Data>> async) {
        //在这里根据快照的状态，返回相应的widget
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
        if (async.connectionState == ConnectionState.done) {
          debugPrint("done");
          if (async.hasError) {
            return new Center(
              child: new Text("ERROR"),
            );
          } else if (async.hasData) {
            List<Data> list = async.data;
            return new RefreshIndicator(
                child: buildListView(context, list),
                onRefresh: refresh);
          }
        }
      },
      future: future,
    );
  }

  buildListView(BuildContext context, List<Data> list) {
    return new ListView.builder(
      itemBuilder: (context, index) {
        Data bean = list[index];
        StringBuffer str = new StringBuffer();
        for (Children children in bean.children) {
          str.write(children.name + "  ");
        }
        return new ListTile(
          title: new Text(bean.name),
          subtitle: new Text(str.toString()),
          trailing: new IconButton(
              icon: new Icon(
                Icons.navigate_next,
                color: Colors.grey,
              ),
              onPressed: () {}),
        );
      },
      itemCount: list.length,
    );
  }

  //获取数据的逻辑，利用dio库进行网络请求，拿到数据后利用json_serializable解析json数据
  //并将列表的数据包装在一个future中
  Future<List<Data>> getdata() async {
    debugPrint("getdata");
    var dio = new Dio();
    Response response = await dio.get("http://www.wanandroid.com/tree/json");
    Map<String, dynamic> map = response.data;
    Entity entity = Entity.fromJson(map);
    return entity.data;
  }

  //刷新数据,重新设置future就行了
  Future refresh() async {
    setState(() {
      future = getdata();
    });
  }
}

```

### 5.注意的问题和踩坑
1. 防止FutureBuilder进行不必要的重绘：这里我采用的方法，是将getData（）赋值给一个future的成员变量，
用它来保存getData（）的结果，以避免不必要的重绘
参考文章：[https://blog.csdn.net/u011272795/article/details/83010974](https://blog.csdn.net/u011272795/article/details/83010974)
2. FutureBuilder和RefreshIndicator的嵌套问题，到底谁是谁的child，这里我是把RefreshIndicator作为FutureBuilder
的孩子。如果将RefreshIndicator放在外层，FutureBuilder作为child的话，当RefreshIndicator调用onrefreh刷新数据并用
setState（）去更新界面的时候，那FutureBuilder也会再次经历生命周期，所以导致获取数据的逻辑会被走两遍


### 6.下一步，封装一个通用的listview
因为这个场景会经常被用到，如果要一直这样写的话，代码量还是挺多的，而且还挺麻烦的。
所以下一步是封装一个通用的listview，包含基本的下拉刷新上拉加载的功能。