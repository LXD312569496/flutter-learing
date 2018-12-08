import 'package:flutter/material.dart';
import 'package:login_demo/ui/sign_up_page.dart';
import 'package:random_pk/random_pk.dart';
import 'package:login_demo/style/theme.dart' as theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_demo/ui/sign_in_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  PageController _pageController;
  PageView _pageView;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
    _pageView = new PageView(
      controller: _pageController,
      children: <Widget>[
        new SignInPage(),
        new SignUpPage(),
      ],
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        /**
       * SafeArea，让内容显示在安全的可见区域
       * SafeArea，可以避免一些屏幕有刘海或者凹槽的问题
       */
        body: new SafeArea(
      child: new SingleChildScrollView(
          /**
             * 用SingleChildScrollView+Column，避免弹出键盘的时候，出现overFlow现象
             */
          child: new Container(
              /**这里要手动设置container的高度和宽度，不然显示不了
                 * 利用MediaQuery可以获取到跟屏幕信息有关的数据
                 */
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //设置渐变的背景
              decoration: new BoxDecoration(
                gradient: theme.Theme.primaryGradient,
              ),
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new SizedBox(
                    height: 75,
                  ),
                  /**
                       * 可以用SizeBox这种写法代替Padding：在Row或者Column中单独设置一个方向的间距的时候
                       */
//                    new Padding(padding: EdgeInsets.only(top: 75)),

                  //顶部图片
                  new Image(
                      width: 250,
                      height: 191,
                      image: new AssetImage("assets/login_logo.png")),
                  new SizedBox(
                    height: 20,
                  ),

                  //中间的Indicator指示器
                  new Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: Color(0x552B2B2B),
                    ),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            child: new Container(
                          /**
                                   * TODO:暂时不会用Paint去自定义indicator，所以暂时只能这样实现了
                                   */
                          decoration: _currentPage == 0
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  color: Colors.white,
                                )
                              : null,
                          child: new Center(
                            child: new FlatButton(
                              onPressed: () {
                                _pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              },
                              child: new Text(
                                "Existing",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )),
                        Expanded(
                            child: new Container(
                          decoration: _currentPage == 1
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  color: Colors.white,
                                )
                              : null,
                          child: new Center(
                            child: new FlatButton(
                              onPressed: () {
                                _pageController.animateToPage(1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.decelerate);
                              },
                              child: new Text(
                                "New",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
//                      new SignInPage(),
//                      new SignUpPage(),
                  new Expanded(child: _pageView),
                ],
              ))),
    ));
  }
}
