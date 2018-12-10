
![Flutter中的Cupertino和Material小部件](https://user-gold-cdn.xitu.io/2018/12/10/16798d7c9d849f30?w=1484&h=1414&f=png&s=1630338)

### 背景
Flutter是一个新的跨平台应用程序开发框架。Flutter中有两套UI组件，分别适用于ios和Android，分别叫做Cupertino和Material。

但是如果希望在各自的平台上继续保持原来的风格的话，比如在Android手机上保持Material风格，在ios上保持Cupertino风格的话，那应该如何实现呢？

如果要写两套代码的话，就太麻烦了。因为两套代码其实有大部分东西是一样的，只是因为风格不一样，而用了不一样的Widget而已。在FLutter中还要注意的一点问题就是，某一些小部件需要一个属于同一“平台特定”库的祖先。举个例子，RaisedButton和Switch属于Material包库，它需要一个Material小部件作为其祖先之一，如果没有的话，则运行的时候会报出下面的错误。
![](https://user-gold-cdn.xitu.io/2018/12/11/16798dc974ef4105?w=828&h=1792&f=png&s=526823)

实现思路：我们可以创建个抽象的组件，并让它根据其运行的平台，显示不同风格的Widget。

### 代码实现
创建一个抽象类,子类只需要重写对应平台的抽象方法就可以了。
```
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
```

下面根据这个基础的平台类,去创建一些基本的Widget。比如去创建一个在Android平台显示AppBar，在ios平台显示CupertinoNavigationBar的Widget。

```

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


```


### 运行实例
```

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

```


