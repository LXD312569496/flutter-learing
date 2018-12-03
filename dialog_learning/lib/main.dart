import 'package:flutter/material.dart';
import 'package:dialog_learning/DialogUtils.dart';
import 'package:random_pk/random_pk.dart';
import 'package:dialog_learning/LoadingDialog.dart';

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
          child: new Column(
        children: <Widget>[
          new RaisedButton(
              onPressed: () {
                showMyDialog(context);
              },
              child: new Text("显示一个普通的对话框")),
          new RaisedButton(
              onPressed: () {
                showMyDialogWithValue(context);
              },
              child: new Text("显示一个有返回值的对话框")),
          new RaisedButton(
              onPressed: () {
                showMyDialogWithColumn(context);
              },
              child: new Text("显示一个SingleChildScrollView+Column的对话框")),
          new RaisedButton(
              onPressed: () {
                showMyDialogWithListView(context);
              },
              child: new Text("显示一个ListView的对话框")),
          new Divider(
            color: Colors.black,
          ),
          new Text("使用封装的工具类展示对话框"),
          new RaisedButton(
              onPressed: () {
                DialogUtil().showMyDialog<String>(context,
                    title: new Text("title"),
                    content: new Text("content"), onConfim: () {
                  Navigator.of(context).pop("点击了确认");
                }, onCancle: () {
                  Navigator.of(context).pop("点击了取消");
                }).then((value) {
                  debugPrint("对话框消失:$value");
                });
              },
              child: new Text("显示一个有返回值的对话框")),
          new RaisedButton(
              onPressed: () {
                DialogUtil().showMyDialogWithListView(context,
                    listview: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return new SizedBox(
                            height: 100,
                            child: new Text("$index"),
                          );
                        }),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    onConfirm: () {},
                    onCancel: () {});
              },
              child: new Text("显示一个ListView的对话框")),
          new Divider(
            color: Colors.black,
          ),
          new RaisedButton(
            onPressed: () {
              showMyCustomDialog();
            },
            child: new Text("自定义对话框"),
          ),
        ],
      )),
    );
  }

  void showMyDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  /*
  1.因为Dialog也是属于Navigator管理的，所以关闭对话框，直接用 Navigator.of(context).pop就行了
  2.ShowDialog()方法返回的是Future值,如果调用Navigator.of(context).pop()方法的时候，可以传递一些数值由Future返回。
    那么就可以用then()监听这个future所返回的数据了
   */
  void showMyDialogWithValue(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new Text("内容内容内容内容内容内容内容内容内容内容内容"),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop("点击了确定");
                },
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop("点击了取消");
                },
                child: new Text("取消"),
              ),
            ],
          );
        }).then((value) {
      debugPrint("对话框消失:$value");
    });
  }

  void showMyDialogWithColumn(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: new Text("title"),
            content: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                  new SizedBox(
                    height: 100,
                    child: new Text("1"),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {},
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: () {},
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  void showMyDialogWithListView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
            content: new Container(
          /*
              暂时的解决方法：要将ListView包装在具有特定宽度和高度的Container中
              如果Container没有定义这两个属性的话，会报错，无法显示ListView
               */
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: new ListView.builder(
            itemBuilder: (context, index) {
              return new SizedBox(
                height: 100,
                child: new Text("1"),
              );
            },
            itemCount: 10,
            shrinkWrap: true,
          ),
        ));
      },
    );

//如果直接将ListView放在dialog中，会报错，比如
//下面这种写法会报错：I/flutter (10721): ══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
//    I/flutter (10721): The following assertion was thrown during performLayout():
//    I/flutter (10721): RenderShrinkWrappingViewport does not support returning intrinsic dimensions.
//    I/flutter (10721): Calculating the intrinsic dimensions would require instantiating every child of the viewport, which
//    I/flutter (10721): defeats the point of viewports being lazy.
//    I/flutter (10721): If you are merely trying to shrink-wrap the viewport in the main axis direction, you should be able
//    I/flutter (10721): to achieve that effect by just giving the viewport loose constraints, without needing to measure its
//    I/flutter (10721): intrinsic dimensions.
//    I/flutter (10721):
//    I/flutter (10721): When the exception was thrown, this was the stack:
//    I/flutter (10721): #0      RenderShrinkWrappingViewport.debugThrowIfNotCheckingIntrinsics.<anonymous closure> (package:flutter/src/rendering/viewport.dart:1544:9)
//    I/flutter (10721): #1      RenderShrinkWrappingViewport.debugThrowIfNotCheckingIntrinsics (package:flutter/src/rendering/viewport.dart:1554:6)
//    I/flutter (10721): #2      RenderViewportBase.computeMaxIntrinsicWidth (package:flutter/src/rendering/viewport.dart:321:12)
//    I/flutter (10721): #3      RenderBox._computeIntrinsicDimension.<anonymous closure> (package:flutter/src/rendering/box.dart:1109:23)
//    I/flutter (10721): #4      __InternalLinkedHashMap&_HashVMBase&MapMixin&_LinkedHashMapMixin.putIfAbsent (dart:collection/runtime/libcompact_hash.dart:277:23)
//    I/flutter (10721): #5      RenderBox._computeIntrinsicDimension (package:flutter/src/rendering/box.dart:1107:41)
//    I/flutter (10721): #6      RenderBox.getMaxIntrinsicWidth (package:flutter/src/rendering/box.dart:1291:12)
//    I/flutter (10721): #7      _RenderProxyBox&RenderBox&RenderObjectWithChildMixin&RenderProxyBoxMixin.computeMaxIntrinsicWidth (package:flutter/src/rendering/proxy_box.dart:81:20)

//        showDialog(context: context, builder: (context) {
//      return new AlertDialog(title: new Text("title"),
//        content: new SingleChildScrollView(
//          child: new Container(
//            height: 200,
//            child: new ListView.builder(
//              itemBuilder: (context, index) {
//                return new SizedBox(height: 100, child: new Text("1"),);
//              }, itemCount: 10, shrinkWrap: true,),
//          ),
//        ),
//        actions: <Widget>[
//          new FlatButton(onPressed: () {}, child: new Text("确认"),),
//          new FlatButton(onPressed: () {}, child: new Text("取消"),),
//        ],);
//    });
  }

  void showMyCustomDialog() {
    /**
     *  通过下面的这个方法，可以看出默认的对话框的大小是占了大半个屏幕的
     */
//        showDialog(context: context,builder: (context){
//      return new AlertDialog(content: new RandomContainer(),);
//    });

    /**    用下面注释的代码执行一遍，会发现无法把对话框展示的内容设置成自己想要的大小
        有一些场景，默认的对话框无法满足条件，就需要自定义对话框
     */
//    showDialog(context: context,builder: (context){
//      return new AlertDialog(content: new SizedBox(width: 100,height: 100,
//      child: new RandomContainer(),),);
//    });

    showDialog(context: context,builder: (context){
      return new LoadingDialog(text: "加载中");
    });

  }
}
