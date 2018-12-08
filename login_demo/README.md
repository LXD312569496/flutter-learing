### 介绍
最近学习了Flutter的一些控件使用，然后在Github上面看见了一个挺漂亮的登录界面，于是就用Flutter自己模仿地实现了一下。原作者做得比较好看，不过只是单纯实现界面。所以自己加了些东西，比如Key的使用和InheritedWidget的使用。

### 最终的展示界面
![](https://user-gold-cdn.xitu.io/2018/12/8/1678b8a5bef11259?w=828&h=1792&f=png&s=126155)
![](https://user-gold-cdn.xitu.io/2018/12/8/1678b89d2a552a85?w=828&h=1792&f=png&s=125206)


### 代码结构

![](https://user-gold-cdn.xitu.io/2018/12/8/1678b8d6c1075805?w=500&h=500&f=png&s=64588)
每个类的名字，相信大家一看就知道对应的作用类。每个类的作用，我在代码里面都有注释，可以去看下代码。


### 主要用到的控件

1. 利用Row，Column沿水平方向或者垂直方向排列子布局
2. 利用Stack实现布局层叠，利用Positioned控件实现绝对定位
3. 利用Container实现装饰效果
4. 利用TextFormField实现文本输入，利用Form来管理这些TextFormField
5. 利用Key来获取widget的状态
6. 利用InheritedWidget可以把数据传递给子控件
7. 利用PageView和PageController实现页面滑动切换


### 在pubspec.yaml中添加依赖

1. font_awesome_flutter，这个一个Flutter的图标库
2. 添加一张登录界面的顶部图片，并声明资源路径。下面的这种写法，会之间把整个文件夹下面的资源都导入应用程序，可以不用一个一个资源地进行声明。
3. random_pk。这里说一下这个库的作用，一方面是为容器提供随机颜色。另一方面，我觉得可以这个有颜色的容器进行调试布局，这个RandomContainer的用法是跟Container一样的，只需包裹child就可以了。然后你可以通过容器的背景的大小，来判断是否所绘制布局的大小是不是对的，看起来比较直观一些，而且自己可以不用手动的去写container+color的那种写法。当你不需要用的时候，再把这一层RandomContainer给去掉就可以了。我自己在平时用的时候，发现确实挺有作用的，大家可以拿去试试。
```
  random_pk: any
  font_awesome_flutter: any
  //省略部分代码
  assets:
 - assets/
```



### 代码实现



#### 1.利用代码模板生成代码，新建一个空页面（如果手动打出一段stateful的代码是真的麻烦）

```
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

#### 2.根据布局编写代码
这部分没什么好说的，主要是要熟悉一些控件的使用，根据UI稿一步一步写出布局就可以了。

例如，输入账号和密码的TextForm的实现
```
 /**
   * 创建登录界面的TextForm
   */
  Widget buildSignInTextForm() {
    return new Container(
      decoration:
      new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))
          , color: Colors.white
      ),
      width: 300,
      height: 190,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: new Form(
        key: _SignInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
//        autovalidate: true,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20, bottom: 20),
                child: new TextFormField(
                  //关联焦点
                  focusNode: emailFocusNode,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },

                  decoration: new InputDecoration(
                      icon: new Icon(Icons.email, color: Colors.black,),
                      hintText: "Email Address",
                      border: InputBorder.none
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email can not be empty!";
                    }
                  },
                  onSaved: (value) {

                  },
                ),
              ),
            ),
            new Container(
              height: 1,
              width: 250,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20),
                child: new TextFormField(
                  focusNode: passwordFocusNode,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.lock, color: Colors.black,),
                      hintText: "Password",
                      border: InputBorder.none,
                      suffixIcon: new IconButton(icon: new Icon(
                        Icons.remove_red_eye, color: Colors.black,),
                          onPressed: showPassWord)
                  ),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Password'length must longer than 6!";
                    }
                  },
                  onSaved: (value) {

                  },
                ),
              ),
            ),


          ],
        ),),
    );
  }
```
例如，PageView的实现
```
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
```


#### 3. InheritedWidget的使用

例如，我想在任意一个地方的子控件，想获得用户的数据User，就可以利用InheritedWidget来实现。比如我们平时用的Theme.of(context)在任何地方来获取应用的主题，或者用MediaQuery.of(context)来获取应用的屏幕数据，其实本质上都是用了InheritedWidget来实现数据的共享。

具体的用法，后面再写一篇文章来解释吧（最近刚弄懂）

```
/**
 * 利用InheritedWidget用于子节点向祖先节点获取数据
    当依赖的InheritedWidget rebuild,会触发子控件的didChangeDependencies()接口
 */
class UserProvider extends InheritedWidget {
  final Widget child;
  final User user;//在子树中共享的数据

  UserProvider({this.user, this.child}) : super(child: child);

  /**
   * 该回调决定当数据发生变化时，是否通知子树中依赖数据的Widget
   */
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

/**
 * 需要一个StatefulWidget作为外层的组件，
    将我们的继承于InheritateWidget的组件build出去
 */
class UserContainer extends StatefulWidget {
  //给子控件分享的数据
  final User user;
  final Widget child;

  UserContainer({Key key, this.user, this.child}) : super(key: key);

  @override
  _UserContainerState createState() => _UserContainerState();

  static UserProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(UserProvider);
  }
}

class _UserContainerState extends State<UserContainer> {
  @override
  Widget build(BuildContext context) {
    return new UserProvider(user: widget.user, child: widget.child);
  }
}

```

#### 4.Key的使用

在Flutter中，每个Widget的构建方法都会有一个key的参数可选，如果没有传key，那么应用会自动帮忙生成一个key值。这个key值在整个应用程序里面是唯一的，并且一个key唯一对应一个widget，所以你可以利用key来获取到widget的state，进而对widget进行控制。

例如，利用key来获取Form的状态FormState,当我点击登录按钮的时候，利用key来获取widget的状态FormState，再利用FormState对Form的子孙FromField进行统一的操作。

```
//定义一个key，并关联到对应的widget
  GlobalKey<FormState> _SignInFormKey = new GlobalKey();
new Form(
        key: _SignInFormKey,
        child: .........)
```
```
 /**利用key来获取widget的状态FormState
              可以用过FormState对Form的子孙FromField进行统一的操作
           */
          if (_SignInFormKey.currentState.validate()) {
            //如果输入都检验通过，则进行登录操作
            Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("执行登录操作")));
            //调用所有自孩子的save回调，保存表单内容
            _SignInFormKey.currentState.save();
          }
```


### 遇到的问题
1.一些布局方面的坑
利用SafeArea可以让内容显示在安全的可见区域。
利用SingleChildScrollView可以避免弹出键盘的时候，出现overFlow的现象。
![](https://user-gold-cdn.xitu.io/2018/12/8/1678ba4fb6d9ac8c?w=1272&h=690&f=png&s=215501)

2.理解context，state，key，widget的一些概念和之间的关系，这篇文章我觉得写得很不错：
[https://user-gold-cdn.xitu.io/2018/12/8/1678bb83bcdb5f6d](https://user-gold-cdn.xitu.io/2018/12/8/1678bb83bcdb5f6d)

### 下一步计划
继续整理自己学习Flutter中的收获和遇到的一些问题


### Demo地址（代码我都加了挺多注释的地方）
[https://github.com/LXD312569496/flutter-learing/tree/master/login_demo](https://github.com/LXD312569496/flutter-learing/tree/master/login_demo)