import 'package:flutter/material.dart';
import 'package:login_demo/model/user.dart';
import 'package:login_demo/ui/user_provider.dart';
import 'package:login_demo/ui/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    /**
     * 根据是否有用户登录信息进入登录注册页面或者主页
        利用inheritedWidget，可以读取到父控件分享的数据
     */
    User user = UserContainer.of(context).user;
    if (user == null) {
      return new LoginPage();
    } else {
      return new Scaffold(
        body: new Container(
          child: new Center(
            child: new Text("用户已登录\n用户名:${user.username}\n密码：${user.password}"),
          ),
        ),
      );
    }
  }
}
