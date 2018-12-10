import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/**
 * 会根据平台，去适配所在平台的小部件
 * Flutter中包含了适用于IOS和Android的两套原生小部件，名为Cupertino和Material
 */
abstract class BasePlatformWidget<A extends Widget, I extends Widget>
    extends StatelessWidget {
  A createAndroidWidget(BuildContext context);

  I createIosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    /**如果是IOS平台，返回ios风格的控件
     * Android和其他平台都返回materil风格的控件
     */
    if (Platform.isIOS) {
      return createIosWidget(context);
    }
    return createAndroidWidget(context);
  }
}


/**
 * 脚手架
 */
class PlatformScaffold
    extends BasePlatformWidget<Scaffold, CupertinoPageScaffold> {
  PlatformScaffold({this.appBar, this.body});

  final PlatformAppBar appBar;
  final Widget body;

  @override
  Scaffold createAndroidWidget(BuildContext context) {
    return Scaffold(
      appBar: appBar.createAndroidWidget(context),
      body: body,
    );
  }

  @override
  CupertinoPageScaffold createIosWidget(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: appBar.createIosWidget(context),
      child: body,
    );
  }
}

/**
 * AppBar
 */
class PlatformAppBar
    extends BasePlatformWidget<AppBar, CupertinoNavigationBar> {
  final Widget title;
  final Widget leading;

  PlatformAppBar({this.title, this.leading});

  @override
  AppBar createAndroidWidget(BuildContext context) {
    return new AppBar(leading: leading, title: title,);
  }

  @override
  CupertinoNavigationBar createIosWidget(BuildContext context) {
    return new CupertinoNavigationBar(leading: leading, middle: title,);
  }

}

/**
 * 对话框
 */
class PlatformAlertDialog
    extends BasePlatformWidget<AlertDialog, CupertinoAlertDialog> {

  final Widget title;
  final Widget content;
  final List<Widget> actions;

  PlatformAlertDialog({this.title, this.content, this.actions});

  @override
  AlertDialog createAndroidWidget(BuildContext context) {
    return new AlertDialog(title: title, content: content, actions: actions,);
  }

  @override
  CupertinoAlertDialog createIosWidget(BuildContext context) {
    return new CupertinoAlertDialog(
      title: title, content: content, actions: actions,);
  }
}

/**
 * Switch
 */

class PlatformSwicth extends BasePlatformWidget<Switch, CupertinoSwitch> {

  final bool value;
  final ValueChanged<bool> onChanged;

  PlatformSwicth({this.value, this.onChanged});

  @override
  Switch createAndroidWidget(BuildContext context) {
    return new Switch(value: value, onChanged: onChanged);
  }

  @override
  CupertinoSwitch createIosWidget(BuildContext context) {
    return new CupertinoSwitch(value: value, onChanged: onChanged);
  }
}

/**
 * Button
 */
class PlatformButton extends BasePlatformWidget<FlatButton, CupertinoButton> {
  final VoidCallback onPressed;
  final Widget child;

  PlatformButton({this.onPressed, this.child});

  @override
  FlatButton createAndroidWidget(BuildContext context) {
    return new FlatButton(onPressed: onPressed, child: child);
  }

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return new CupertinoButton(child: child, onPressed: onPressed);
  }
}


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
  void initState() {
    super.initState();
  }

  bool androidSelected = false;
  bool iosSelected = false;

  @override
  Widget build(BuildContext context) {
    return new PlatformScaffold(
      appBar: new PlatformAppBar(
        title: new Text(widget.title),

      ),
      body: new SafeArea(child: new Container(
          child:
          new Column(
            children: <Widget>[
              new CupertinoButton(
                  child: new Text("显示ios风格的对话框"), onPressed: () {
                showDialog(context: context, builder: (context) {
                  return new CupertinoAlertDialog(
                    title: new Text("title"),
                    content: new Text("content"),
                    actions:
                    <Widget>[
                      new CupertinoButton(onPressed: () {},
                          child: new Text("Cancel")),
                      new CupertinoButton(onPressed: () {},
                          child: new Text("Confirm")),
                    ]
                    ,
                  );
                });
              }),
              new FlatButton(child: new Text("显示android风格的对话框"), onPressed: () {
                showDialog(context: context, builder: (context) {
                  return new AlertDialog(
                    title: new Text("title"),
                    content: new Text("content"),
                    actions:
                    <Widget>[
                      new FlatButton(onPressed: () {},
                          child: new Text("Cancel")),
                      new FlatButton(onPressed: () {},
                          child: new Text("Confirm")),
                    ]
                    ,
                  );
                });
              }),
//下面这段代码在ios平台运行会出错，在android平台可以运行，所以暂时注释掉，原因就是Switch需要有一个Material的祖先
//              new Switch(
//                value: androidSelected, onChanged: (value) {
//                setState(() {
//                  androidSelected = value;
//                });
//              },),
              new CupertinoSwitch(value: iosSelected, onChanged: (value) {
                setState(() {
                  iosSelected = value;
                });
              }),


            ],
          )
      ),),
    );
  }
}

