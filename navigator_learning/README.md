
本文首先讲的Flutter中的路由，然后主要讲下Flutter中栈管理的几种方法。
* 了解下Route和Navigator
* 简单的路由
* 命名路由
* 自定义路由
* Flutter中使用的路由场景
* Flutter中的路由栈管理
* 实战
* 代码链接
* 下一步

## 了解下Route和Navigator
在Flutter中，我们需要在不同屏幕或者页面之间进行切换和发送数据,这些“screens”或者“pages”被称为Route(路由),是由一个Navigator的小部件进行管理。

Navigator可以管理包含若干Route对象的堆栈，并提供了管理的方法，平常我们经常用的就是[Navigator.push]和[Navigator.pop]。

尽管我们可以自己直接创建一个navigator,但是当我们创建一个WidgetsApp或者MaterialApp,Flutter会自动默认创建一个Navigator。
所以我们一般是使用由[WidgetsApp]或者[MaterialApp]所创建的Navigator就行了，然后通过调用[Navigator.of]
来拿到当前的Navigator的状态NavigatorState,然后调用它的pop或者push方法。


## 简单的路由
比如要导航到一个新的页面，我们可以创建一个[MaterialPageRoute]的实例，然后调用Navigator.of(context).push()方法就将新页面添加到堆栈的顶部。

返回上一个页面，则调用Navigator.pop(context)就可以从堆栈中删除这个屏幕;

```
     Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new DetailPage();
                    }));
 Navigator.pop(context);
```


## 命名路由
如果每次跳转到一个新的路由页面，都要跟上面一样的写法，创建MaterialPageRoute实例然后调用push方法，这样的话就太麻烦了。

所以，Flutter提供了另外一种方式来管理路由，可以使用命名路由，然后使用Navigator.pushNamed（）方法来弹出路由。

创建MaterialApp的时候需要传入一个routes参数，routes本质上是一个Map<String,WidgetBuilder>,key值对应自定义的路径名字，value值会映射到对应的WidgetBuilder,我们可以在WidgetBuilder中创建对应的页面。

Navigator.pushNamed()方法有两个参数（BuildContext，String),第一个是上下文，第二个是在路由中预定义的string。

特殊情况处理：当push一个不存在的路由页面的时候，需要进行提示操作。可以使用UnknownRoute的属性。比如下面的例子，
当push一个不存在的路由的时候，会跳转到NotFoundPage的页面。


```
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        //Map<String, WidgetBuilder>
        "/splash": (context) => new SplashPage(),
        "/login": (context) => new LoginPage(),
        "/home": (context) => new HomePage(),
        "/detail": (context) => new DetailPage(),
      },
      onUnknownRoute: (RouteSettings setting) {
        String name = setting.name;
        print("onUnknownRoute:$name");
        return new MaterialPageRoute(builder: (context) {
          return new NotFoundPage();
        });
      },
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashPage(),
    );
  }
}

//弹出路由，跳转到其他页面
 Navigator.of(context).pushNamed("/detail");
```

## 自定义路由

比如我们上面使用的是MaterialPageRoute，在页面切换的时候，会有默认的自适应平台的过渡动画。
如果想自定义页面的进场和出场动画，那么需要使用PageRouteBuilder来创建路由。
PageRouteBuilder是主要的部分，一个是“pageBuilder”，用来创建所要跳转到的页面，另一个是“transitionsBuilder”，也就是我们可以自定义的转场效果。

```
  PageRouteBuilder({
    RouteSettings settings,
    @required this.pageBuilder,//构造页面
    this.transitionsBuilder = _defaultTransitionsBuilder,//创建转场动画
    this.transitionDuration = const Duration(milliseconds: 300),//转场动画的持续时间
    this.opaque = true,//是否是透明的
    this.barrierDismissible = false,//举个例子，比如AlertDialog也是利用PageRouteBuilder进行创建的，barrierDismissible若为false，点击对话框周围，对话框不会关闭；若为true，点击对话框周围，对话框自动关闭。
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  }
```
只修改单独一个页面的过渡动画，可以这样操作，例如下面的代码，
```
//              自定义跳转动画
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return new HomePage();
                      },
                      transitionsBuilder: (___, Animation<double> animation,
                          ____, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: RotationTransition(
                            turns: Tween<double>(begin: 0.5, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        );
                      }));
```

## Flutter中使用的路由场景
在Flutter中，我们会使用到这些方法，例如[showDialog()], [showMenu()], and [showModalBottomSheet()]等，这些方法其实本质上是创建了一个路由的页面后，并调用Navigator的push方法去push到当前的屏幕上。

showDialog()其实是调用了showGeneralDialog()，所以下面贴了showGeneralDialog的源码，可以看出，也是利用了Navigator的push方法的。

这里插一下，关于对话框的使用，比如列表对话框，自定义对话框的使用和踩坑，可以看下我的另外一篇文章：[Flutter之Dialog使用和踩坑](https://juejin.im/post/5c0aa283518825444612a1eb)

```
Future<T> showGeneralDialog<T>({
  @required BuildContext context,
  @required RoutePageBuilder pageBuilder,
  bool barrierDismissible,
  String barrierLabel,
  Color barrierColor,
  Duration transitionDuration,
  RouteTransitionsBuilder transitionBuilder,
}) {
  return Navigator.of(context, rootNavigator: true).push<T>(_DialogRoute<T>(
    pageBuilder: pageBuilder,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,
    transitionBuilder: transitionBuilder,
  ));
}

```





## Flutter中的路由栈管理

相信大家对栈Stack都有一定的了解，push方法是将元素添加到堆栈的顶部，pop方法是删除顶部元素。

下面用图文的方式来讲解Flutter中几个管理栈的方法之间的区别。
### push（）
push()，就是直接将一个元素插入到堆栈的顶部。

这个方法很简单，并且我们会经常用到。比如从Screen1中利用navigator的push方法，将Screen2的路由弹到堆栈的顶部。堆栈的情况如下图：

![](https://user-gold-cdn.xitu.io/2019/2/3/168b15d27dce600b?w=94&h=85&f=png&s=694)

可以利用下面的两个push方法，实现这个目的。
```
Navigator.of(context).pushNamed("/111");
Navigator.of(context).push(route);
```

### pop()
pop(), 就是将堆栈的顶部元素进行删除，回退到上一个界面。

比如上面的例子，在Screen2中利用pop()将顶部的Screen2从堆栈中移除，之后的堆栈如下图：

![](https://user-gold-cdn.xitu.io/2019/2/3/168b21447857bca9?w=93&h=64&f=png&s=533)

```
Navigator.of(context).pop();
```

注意：
* 当利用push()跳转到一个使用Scaffold的页面的时候，Scaffold会自动在其AppBar上添加一个“ 后退 ”按钮，点击按钮会自动调用Navigator.pop()。
* 在Android中，按下设备后退按钮也会自动调用Navigator.pop()。


### pushReplacementNamed()和popAndPushNamed()
有下面的这种场景，我们进入到Screen3页面后，要跳转到Screen4页面，不过点击返回按钮，并不想回退到Screen3页面。也就是想将Screen4的元素插入栈顶的同时，将Screen3的元素夜进行移除。

![](https://user-gold-cdn.xitu.io/2019/2/3/168b256b313e0819?w=242&h=83&f=png&s=1045)

这个时候，我们就要用到pushReplacementNamed()或者popAndPushNamed(),pushReplacement()都可以实现这个目的。
```
Navigator.of(context).pushReplacementNamed('/screen4');
Navigator.popAndPushNamed(context, '/screen4');
Navigator.of(context).pushReplacement(newRoute);
```

### pushNamedAndRemoveUntil()
一般会有这种场景，我们在已经登录的情况下，在设置界面会有个退出用户登录的按钮，点击后会注销用户退出登录，并且会跳转到登录界面。那么路由栈的变化应该会如下图所示：

![](https://user-gold-cdn.xitu.io/2019/2/3/168b2606bedc5a4d?w=241&h=124&f=png&s=1658)

如果只是简单的进行push一个LoginScreen的操作的话，那么按返回键的话，会回到上一个页面，这样的逻辑是不对的。

所以我们应该删除掉路由栈中的所有route，然后再弹出LoginScreen。这个时候就要用到pushNamedAndRemoveUntil()或者pushAndRemoveUntil()了。

```
typedef RoutePredicate = bool Function(Route<dynamic> route);
//第一个参数context是上下文的context，
//第二个参数newRouteName是新的路由所命名的路径
//第三个参数predicate，返回值是bool类型，按照我的理解，就是用来判断Until所结
//束的时机，如果为false的话，就会一直继续执行Remove的操作，直到为true的时候，停止Remove操作，然后才执行push操作。
  static Future<T> pushNamedAndRemoveUntil<T extends Object>(BuildContext context, String newRouteName, RoutePredicate predicate) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(newRouteName, predicate);
  }
```
* 如果想在弹出新路由之前，删除路由栈中的所有路由，那可以使用下面的这种写法，(Route<dynamic> route) => false，这样能保证把之前所有的路由都进行删除，然后才push新的路由。
```
Navigator.of(context).pushNamedAndRemoveUntil('/LoginScreen', (Route<dynamic> route) => false);
```
* 如果想在弹出新路由之前，删除路由栈中的部分路由。比如只弹出Screen1路由上面的Screen3和Screen2，然后再push新的Screen4，堆栈的情况如下图：

![](https://user-gold-cdn.xitu.io/2019/2/3/168b279818e79c56?w=213&h=82&f=png&s=977)

利用ModalRoute.withName(name)，来执行判断，可以看下面的源码，当所传的name跟堆栈中的路由所定义的时候，会返回true值，不匹配的话，则返回false。
```
Navigator.of(context).pushNamedAndRemoveUntil('/screen4',ModalRoute.withName('/screen1'));
 
 //ModalRoute.withName的源码
   static RoutePredicate withName(String name) {
    return (Route<dynamic> route) {
      return !route.willHandlePopInternally
          && route is ModalRoute
          && route.settings.name == name;
    };
  }
```

### popUntil()
popUntil()方法的过程其实跟上面差不多，就是是少了push一个新页面的操作，只是单纯的进行移除路由操作。
```
popUntil(RoutePredicate predicate);
Navigator.of(context).popUntil(ModalRoute.withName("/XXX"));

```


## 实战
这里写了一个Demo，将上面的几种管理栈的用法都运用了一下。

<img src="https://user-gold-cdn.xitu.io/2019/2/3/168b2f2a94dd26d2" width=300 height=600/>

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        //Map<String, WidgetBuilder>
        "/splash": (context) => new SplashPage(),
        "/login": (context) => new LoginPage(),
        "/home": (context) => new HomePage(),
        "/detail": (context) => new DetailPage(),
      },
      onUnknownRoute: (RouteSettings setting) {
        String name = setting.name;
        print("onUnknownRoute:$name");
        return new MaterialPageRoute(builder: (context) {
          return new NotFoundPage();
        });
      },
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SplashPage(),
    );
  }
}
```
首先是定义在MaterialApp中定义多个路由，Demo中有多个路由:
* SplashPage 启动页面，设置2秒后自动跳转到LoginPage
* LoginPage 登录页面，点击按钮，模仿登录成功的动作并跳转到HomePage
* HomePage 主页，显示一个列表，点击列表项跳转到DetailPage
* DetailPage 详细信息页面，并且有一个退出登录的按钮
* NotFoundPage 当没有路由可以匹配的时候，弹出这个页面

下面简单讲一下代码：

#### SplashPage->LoginPage,LoginPage->HomePage
用的都是pushReplacementNamed()。因为跳到登录界面后，不需要返回到SplashPage，所以需要将SplashPage从路由栈中移除。LoginPage->HomePage，也是同样的道理。
```
Navigator.of(context).pushReplacementNamed("/login");
Navigator.of(context).pushReplacementNamed("/home");
```
#### HomePage->DetailPage
使用的是简单的pushNamed()就可以了，没必要移除HomePage，因为从DetailPage点击返回后，需要返回到HomePage界面。
```
//下面的两种写法都是可以的
Navigator.of(context).pushNamed("/detail");
Navigator.of(context)
         .push(new MaterialPageRoute(builder: (context) {
         return new DetailPage();
       }));
```
#### DetailPage->LoginPage
利用的是从DetailPage点击退出登录按钮，会弹出路由栈中的所有路由页面，然后再将LoginPage的路由插入到栈顶。这样的话，路由栈中就只剩下LoginPage了，若是点击返回按钮的话，默认就会退出应用程序了，因为堆栈为空了。
```
Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
```

## 代码链接

[https://github.com/LXD312569496/flutter-learing/navigator_learning](https://github.com/LXD312569496/flutter-learing/navigator_learning)

欢迎大家关注我的公众号，会推送关于Flutter和Android学习的一些文章

<img src="https://user-gold-cdn.xitu.io/2019/2/2/168acc8ef6a38b77?w=430&h=430&f=jpeg&s=39449" width=200 height-200/>

## 下一步
学习使用fluro的第三方路由框架，并做下整理和总结。