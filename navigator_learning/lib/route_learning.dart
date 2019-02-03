import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      //定义路由
      routes: {
        //Map<String, WidgetBuilder>
        "/splash": (context) => new SplashPage(),
        "/login": (context) => new LoginPage(),
        "/home": (context) => new HomePage(),
        "/detail": (context) => new DetailPage(),
      },
      //没有路由可以进行匹配的时候
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

//主页，显示一个列表
class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
          child: new ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return new ListTile(
                  title: new Text("第$index项"),
                  onTap: () {
                    Navigator.of(context).pushNamed("/detail");
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new DetailPage();
                    }));
                  },
                );
              })),
    );
  }
}

//详细界面
class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: new Container(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text("详细界面"),
              new RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/login", (Route<dynamic> route) => false);
                },
                child: new Text("点击退出登录"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//启动页面
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacementNamed("/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Center(
          child: new Text("启动界面"),
        ),
      ),
    );
  }
}

//登录界面
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text("这是登录界面"),
          new RaisedButton(
            child: new Text("点击登录成功，跳转到主页"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/home");
            },
          ),
          new RaisedButton(
            child: new Text("点击跳转到NotFoundPage"),
            onPressed: () {
//              跳转到路由错误的界面
              Navigator.of(context).pushNamed("/111");
            },
          ),
          new RaisedButton(
            child: new Text("点击登录成功，自定义动画，跳转到主页"),
            onPressed: () {
//              自定义跳转动画
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: true,
                      pageBuilder: (BuildContext context, _, __) {
                        return new HomePage();
                      },
                      transitionsBuilder: (context, Animation<double> animation,
                          Animation<double> secondaryAnimation, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: RotationTransition(
                            turns: Tween<double>(begin: 0.5, end: 1.0)
                                .animate(animation),
                            child: child,
                          ),
                        );
                      }));
            },
          ),
        ],
      ),
    );
  }
}

//路由跳转失败的页面
class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Center(
          child: new Text("NotFoundPage"),
        ),
      ),
    );
  }
}
