# willpopscope_learning

### 监听返回键

## Getting Started


 ####  场景：一般情况下，Android按一次返回键的话，就会退出所在的界面，所以有时候需要监听返回键的事件进行判断
 #### 用法：在最外层包裹一个WillPopScope控件，并注册一个onWillPop的回调来判断是否真的要退出应用
  注意：onWillPop的返回值是一个Future<bool>的值。 返回 Future.value(false); 表示不退出。返回 Future.value(true); 表示退出.

```
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Text(
            '学习WillPopScope的使用',
          ),
        ),
      ),
    );
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("是否退出应用程序"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("确认")),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("取消")),
            ],
          );
        });
  }
```



```

  /**
   * 另外一种场景：Android端返回按钮点击两次，就直接退出应用
   * 需要一个变量保存两次点击之间的时间间隔，根据这个时间间隔返回true或false
   */

  int lastClickTime = 0;

  Future<bool> doubleClickToBack() {
    int now = DateTime.now().millisecond;
    if ((now - lastClickTime) > 1000) {
      lastClickTime = DateTime.now().millisecond;
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
```

