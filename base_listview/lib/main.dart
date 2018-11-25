import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:base_listview/baselistview.dart';

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
      home: FutureBuilderPage(),
    );
  }
}

class FutureBuilderPage extends StatefulWidget {
  @override
  _FutureBuilderPageState createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {


  PageRequest<String> pageRequest;
  ItemBuilder<String> itemBuilder;

  BaseListView<String> baseListView;
  @override
  void initState() {
    itemBuilder = getItem;
    pageRequest = loadData;
    baseListView=new BaseListView<String>(
      pageRequest, itemBuilder, enableLoadmore: true,);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("知识体系"), actions: <Widget>[
        new IconButton(
            icon: Icon(Icons.search, color: Colors.white,), onPressed: null)
      ],),

      body: baseListView,

      floatingActionButton: new FloatingActionButton(onPressed: () {
        setState(() {
          //测试futurebuilder是否进行没必要的重绘操作
        });
      }),
    );
  }


  Future<List<String>> loadData(int page, int pageSize) async {
    await Future.delayed(Duration(seconds: 2));
    List<String> list = new List.generate(15, (index) {
      return "$index";
    });
    return list;
  }

  Widget getItem(List<String> list,int index) {
    return new ListTile(title: new Text(list[index]),);
  }

}
