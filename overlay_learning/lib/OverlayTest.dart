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
  FocusNode focusNode = new FocusNode();
  OverlayEntry textFormOverlayEntry;

  LayerLink layerLink = new LayerLink();

  OverlayEntry weixinOverlayEntry;

  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        textFormOverlayEntry = createSelectPopupWindow();
        Overlay.of(context).insert(textFormOverlayEntry);
      } else {
        textFormOverlayEntry.remove();
        textFormOverlayEntry = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (weixinOverlayEntry != null) {
          weixinOverlayEntry.remove();
          weixinOverlayEntry = null;
          return Future.value(false);
        }
        if (textFormOverlayEntry != null) {
          textFormOverlayEntry.remove();
          textFormOverlayEntry = null;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          if (weixinOverlayEntry != null) {
            weixinOverlayEntry.remove();
            weixinOverlayEntry = null;
          }
          if (textFormOverlayEntry != null) {
            textFormOverlayEntry.remove();
            textFormOverlayEntry = null;
          }
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showWeixinButtonView();
                  })
            ],
          ),
          body: new Container(
              child: new Column(
            children: <Widget>[
              new RaisedButton(
                  onPressed: () {
                    Toast.show(context: context, message: "显示对话框");
                  },
                  child: new Text("点击显示overlay")),
              new CompositedTransformTarget(
                link: layerLink,
                child: new TextFormField(
                  decoration: InputDecoration(
                    hintText: "请输入",
                  ),
                  focusNode: focusNode,
                ),
              ),
            ],
          )),
          floatingActionButton: new FabWithIcons(
              icons: [Icons.access_alarm, Icons.add, Icons.remove],
              onIconTapped: (value) {}),
        ),
      ),
    );
  }

  /**
   * 利用Overlay实现PopupWindow效果，悬浮的widget
   * 利用CompositedTransformFollower和CompositedTransformTarget
   */
  OverlayEntry createSelectPopupWindow() {
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
        width: 200,
        child: new CompositedTransformFollower(
          offset: Offset(0.0, 50),
          link: layerLink,
          child: new Material(
            child: new Container(
                color: Colors.grey,
                child: new Column(
                  children: <Widget>[
                    new ListTile(
                      title: new Text("选项1"),
                      onTap: () {
                        Toast.show(context: context, message: "选择了选项1");
                        focusNode.unfocus();
                      },
                    ),
                    new ListTile(
                        title: new Text("选项2"),
                        onTap: () {
                          Toast.show(context: context, message: "选择了选项1");
                          focusNode.unfocus();
                        }),
                  ],
                )),
          ),
        ),
      );
    });
    return overlayEntry;
  }

  /**
   * 展示微信下拉的弹窗
   */
  void showWeixinButtonView() {
    weixinOverlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: kToolbarHeight,
          right: 20,
          width: 200,
          height: 320,
          child: new SafeArea(
              child: new Material(
            child: new Container(
              color: Colors.black,
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: new ListTile(
                      leading: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      title: new Text(
                        "发起群聊",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("添加朋友",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("扫一扫",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("首付款",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Expanded(
                    child: new ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: new Text("帮助与反馈",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          )));
    });
    Overlay.of(context).insert(weixinOverlayEntry);
  }
}

/**
 * 利用overlay实现Toast
 */
class Toast {
  static void show({@required BuildContext context, @required String message}) {
    //创建一个OverlayEntry对象
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return new Positioned(
          top: MediaQuery.of(context).size.height * 0.7,
          child: new Material(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: new Center(
                child: new Card(
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Text(message),
                  ),
                  color: Colors.grey,
                ),
              ),
            ),
          ));
    });
    //往Overlay中插入插入OverlayEntry
    Overlay.of(context).insert(overlayEntry);
    new Future.delayed(Duration(seconds: 2)).then((value) {
      overlayEntry.remove();
    });
  }
}

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class FabWithIcons extends StatefulWidget {
  FabWithIcons({this.icons, this.onIconTapped});

  final List<IconData> icons;
  ValueChanged<int> onIconTapped;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          backgroundColor: backgroundColor,
          mini: true,
          child: Icon(widget.icons[index], color: foregroundColor),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
