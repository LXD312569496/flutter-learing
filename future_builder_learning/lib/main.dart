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
                child: buildListView(context, list), onRefresh: refresh);
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
