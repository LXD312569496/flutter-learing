## 处理多屏幕适配和屏幕方向（Flutter中的Fragment)

### 介绍
本文是medium的一篇文章的翻译，再加上自己的一点理解，已得到作者的同意。

主要讲的是在平板和手机中，处理屏幕适配的问题。

原文地址：[https://medium.com/flutter-community/developing-for-multiple-screen-sizes-a
nd-orientations-in-flutter-fragments-in-flutter-a4c51b849434](https://medium.com/flutter-community/developing-for-multiple-screen-sizes-and-orientations-in-flutter-fragments-in-flutter-a4c51b849434)

### Android中解决大屏幕的方法
在Android中，我们处理比较大尺寸的屏幕，例如平板电脑。我们可以用过最小宽度限定符来定义相应尺寸的布局文件的名称。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026ab4e76109?w=701&h=472&f=png&s=150564](https://user-gold-cdn.xitu.io/2019/1/21/1687026ab4e76109?w=701&h=472&f=png&s=150564)
这意味着我们要去给一个布局文件用于手机，一个布局用于平板电脑。然后在运行的时候，根据设备，实例化相应的布局。然后我们要去检查哪个布局是active的，并进行相应的初始化操作。官方关于Android支持不同屏幕尺寸的文档：[https://developer.android.com/training/multiscreen/screensizes#TaskUseSWQuali](https://developer.android.com/training/multiscreen/screensizes#TaskUseSWQuali)

Android中的Fragment本质上是可重用的组件，可以在屏幕中使用。Fragment有自己的布局文件，并且
Java/Kotlin的类会去控制Fragment的生命周期。这是一项相当大的工作，需要大量代码才能开始工作。

下面，我们先来看看在Flutter中处理屏幕方向，然后处理Flutter的屏幕尺寸。

### 在Flutter中使用方向
当我们使用屏幕方向的时候，我们希望使用屏幕的全部宽度和显示尽可能的最大信息量。

下面的示例，在两个方向上创建一个基本的配置文件页面，并根据不同的方向去构建布局，以最大限度地使用屏幕宽度。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026ac85e885d?w=1080&h=1920&f=gif&s=2215836](https://user-gold-cdn.xitu.io/2019/1/21/1687026ac85e885d?w=1080&h=1920&f=gif&s=2215836)
在这里，我们有一个简单的屏幕，具有不同的纵向和横向的布局。下面，我们尝试通过创建上面的示例来了解
如何在Flutter中实现横竖屏切换布局。

#### 如何解决这个问题
在概念上，解决方法跟Android的方法是类似的。我们也要弄两个布局（这里的布局并不是Android中的布局文件，因为在Flutter中
没有布局文件），一个用于纵向，一个用于横向。然后当设备的方向改变的时候，rebuild更新我们的布局。
#### 如何检测方向变化
Flutter中提供了一个OrientationBuilder的小部件。OrientationBuilder可以在设备的方向发生改变的时候，重新构建布局。
```
typedef OrientationWidgetBuilder = Widget Function(BuildContext context, Orientation orientation);
class OrientationBuilder extends StatelessWidget {
  /// Creates an orientation builder.
  const OrientationBuilder({
    Key key,
    @required this.builder,
  }) : assert(builder != null),
       super(key: key);

  /// Builds the widgets below this widget given this widget's orientation.
  /// A widget's orientation is simply a factor of its width relative to its
  /// height. For example, a [Column] widget will have a landscape orientation
  /// if its width exceeds its height, even though it displays its children in
  /// a vertical array.
  final OrientationWidgetBuilder builder;

  Widget _buildWithConstraints(BuildContext context, BoxConstraints constraints) {
    // If the constraints are fully unbounded (i.e., maxWidth and maxHeight are
    // both infinite), we prefer Orientation.portrait because its more common to
    // scroll vertically then horizontally.
    final Orientation orientation = constraints.maxWidth > constraints.maxHeight ? Orientation.landscape : Orientation.portrait;
    return builder(context, orientation);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildWithConstraints);
  }
}
```
OrientationBuilder有一个builder函数来构建我们的布局。当设备的方向发生改变的时候，就会调用
builder函数。orientation的值有两个，Orientation.landscape和Orientation.portrait。
```
@override
Widget build（BuildContext context）{
  return Scaffold（
    appBar：AppBar（），
    body：OrientationBuilder（
      builder :( context，orientation）{
        return orientation == Orientation. portrait
            ？_buildVerticalLayout（）
            ：_ buildHorizo​​ntalLayout（）;
      }，
    ），
  ）;
}
```
在上面的例子中，我们检查屏幕是否处于竖屏模式并构建竖屏的布局，否则我们为屏幕构建横屏的布局。
_buildVerticalLayout（）和_buildHorizontalLayout（）是编写的用于创建相应布局的方法。


### 在Flutter中创建更大屏幕的布局
当我们处理更大的屏幕尺寸的时候，我们希望屏幕适应地去使用屏幕上的可用空间。最直接的方法就是为平板电脑
和手机创建两种不同的布局（这里的的布局，表示屏幕的可视部分）。然而，这里会涉及许多不必要的代码，并且代码需要被重用。

那么我们如何解决这个问题呢？

首先，让我们来看看它最常见的用例。

这里讨论下“Master-Detail Flow”。对于应用程序来说，你会看到一个常见的场景。其中有一个Master的列表，然后当你点击列表项Item的时候，就会跳到另一个显示Detail详细信息的屏幕。以Gmail为例，我们有一个电子邮件的列表，当我们点击其中一个的时候，
会打开一个显示详细信息的页面，其中包含邮件内容。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026aa5c9c547?w=720&h=526&f=png&s=142668](https://user-gold-cdn.xitu.io/2019/1/21/1687026aa5c9c547?w=720&h=526&f=png&s=142668)
让我们为这个流程做一个示例的应用程序。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026acd0b488f?w=1080&h=1920&f=gif&s=3447249](https://user-gold-cdn.xitu.io/2019/1/21/1687026acd0b488f?w=1080&h=1920&f=gif&s=3447249)
这个应用程序只保存一个数字列表，并在点击的时候，跳转到只显示一个数字的详细视图。

如果我们在平板电脑中使用相同的布局，那将是一个相当大的空间浪费。那么我们可以做些什么来解决它呢？
我们可以在同一屏幕上同时拥有主列表和详细视图，因为我们有足够可用的屏幕空间。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026ac99d7a32?w=2048&h=1536&f=gif&s=773243](https://user-gold-cdn.xitu.io/2019/1/21/1687026ac99d7a32?w=2048&h=1536&f=gif&s=773243)
那么我们可以做些什么，来减少编写两个独立屏幕的工作呢？

先看看Android中是如何解决这个问题的。Android从主列表和详细信息视图中创建称为Fragment的可重用组件。
Fragment可以与屏幕分开定义，只是简单地将fragment添加到屏幕中而不是重复的两套代码。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026aa4c69f51?w=586&h=229&f=png&s=34659](https://user-gold-cdn.xitu.io/2019/1/21/1687026aa4c69f51?w=586&h=229&f=png&s=34659)
因此FragmentA是显示主列表的fragment，FragmentB是显示详细信息的fragment。在较小宽度的布局中，单击列表项Item，会导航到单独的页面来显示详细视图FragmentB，
而在平板电脑中，fragmentB将跟fragmentA显示在同一屏幕上。

This is where the power of Flutter comes in.

Every widget in Flutter is by nature, reusable.

Every widget in Flutter is like a Fragment.

我们需要做的就是定义两个Widget，一个用于显示主列表，一个用于显示详细视图。实际上，这些就是类似的fragments。

我们只需要检查设备是否具有足够的宽度来处理列表视图和详细视图。如果是，我们在同一屏幕上显示两个widget。如果设备没有足够的宽度来包含两个界面，那我们只需要在屏幕中展示主列表，点击列表项后导航到独立的屏幕来显示详细视图。

首先，我们需要检查设备的宽度，看看我们是否可以使用更大的布局，而不是使用更小的布局。
为了获得宽度，我们使用MediaQuery来获取宽度，Size中的宽度和高度的单位是dp。
```
MediaQuery.of(context).size.width
```
让我们将最小宽度设置为600dp，以切换到第二种布局。

#### 总结：
1. 我们创建了两个Widget，一个包含主列表，一个显示详细视图
2. 我们创建了两个屏幕，在第一个屏幕上，我们检查设备是否具有足够的宽度来处理这两个小部件
3. 如果具有足够的宽度，我们将在第一个页面上添加上两个Widget就行了。如果没有，我们在第一个页面只添加主列表Widget，
在点击列表项之后导航到第二个屏幕上，显示详细视图的Widget。
### 代码实现
代码的实现我是用自己的代码进行说明，跟原作者的代码实现的思路和结果是一样的。
下面实现的是，有一个数字列表，点击后显示详细视图。

#### ListWidget
![https://user-gold-cdn.xitu.io/2019/1/21/1687026b765a0534?w=632&h=930&f=png&s=10797](https://user-gold-cdn.xitu.io/2019/1/21/1687026b765a0534?w=632&h=930&f=png&s=10797)
```
//需要定义一个回调，决定是在同一个屏幕上显示更改详细视图还是在较小的屏幕上导航到不同界面。
typedef Null ItemSelectedCallback(int value);
//列表的Widget
class ListWidget extends StatelessWidget {
  ItemSelectedCallback itemSelectedCallback;

  ListWidget({@required this.itemSelectedCallback});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return new ListTile(
            title: new Text("$index"),
            onTap: () {
            //设置点击事件
              this.itemSelectedCallback(index);
            },
          );
        });
  }
}
```
#### DetailWidget
![https://user-gold-cdn.xitu.io/2019/1/21/1687026ba708fdc1?w=630&h=930&f=png&s=3399](https://user-gold-cdn.xitu.io/2019/1/21/1687026ba708fdc1?w=630&h=930&f=png&s=3399)
```
//详细视图的Widget,简单的显示一个文本
class DetailWidget extends StatelessWidget {
  final int data;

  DetailWidget(this.data);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: new Center(
          child: new Text("详细视图:$data"),
        ),
      ),
    );
  }
}
```

请注意，这些Widget不是屏幕，只是我们将在屏幕上使用的小部件。

#### 主屏幕
![https://user-gold-cdn.xitu.io/2019/1/21/1687026bbc94b431?w=720&h=488&f=png&s=7025](https://user-gold-cdn.xitu.io/2019/1/21/1687026bbc94b431?w=720&h=488&f=png&s=7025)
```
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLargeScreen; //是否是大屏幕

  var selectValue = 0; //保存选择的内容

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new OrientationBuilder(builder: (context, orientation) {
        print("width:${MediaQuery.of(context).size.width}");
        //判断屏幕宽度
        if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
        //两个widget是放在一个Row中进行显示，如果是小屏幕的话，用一个空的Container进行占位
        //如果是大屏幕的话，则用Expanded进行屏幕的划分并显示详细视图
        return new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Expanded(child: new ListWidget(
              itemSelectedCallback: (value) {
                //定义列表项的点击回调
                if (isLargeScreen) {
                  selectValue = value;
                  setState(() {});
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new DetailWidget(value);
                  }));
                }
              },
            )),
            isLargeScreen
                ? new Expanded(child: new DetailWidget(selectValue))
                : new Container()
          ],
        );
      }),
    );
  }
}
```
这是应用程序的主页面。有两个变量：selectedValue用于存储选定的列表项，isLargeScreen表示屏幕是否足够大。

这里还用了OrientatinBuilder包裹在最外面，所以当如果手机被旋转到横屏的时候，并且有足够的宽度来显示两个Widget的话，那它将以这种方式重建。(如果不需要这功能，那可以把OrientatinBuilder去掉就行)。

* 代码的主要部分是：
```
  isLargeScreen
                ? new Expanded(child: new DetailWidget(selectValue))
                : new Container()
```
如果isLargeScreen为true，则添加一个Expanded控件内部包裹DetailWidget。
Expanded允许每个小部件通过设置Flex属性来填充屏幕。

如果isLargeScreen为false，则返回一个空的Container就行了，ListWidget所在的Expanded会自动填充满屏幕。

* 第二个重要部分是：
```
                //定义列表项的点击回调
                if (isLargeScreen) {
                  selectValue = value;
                  setState(() {});
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new DetailWidget(value);
                  }));
                }
```
定义列表项的点击回调，如果屏幕较小，我们需要导航到不同的页面。如果屏幕较大，就不需要导航到不同的屏幕，因为DetailWidget就在这个屏幕里面，只需调用setState()去刷新界面就行。

现在我们有一个功能正常的应用程序，能够适应不同大小的屏幕和方向。
![https://user-gold-cdn.xitu.io/2019/1/21/1687026bcf3e4095?w=720&h=809&f=png&s=11876](https://user-gold-cdn.xitu.io/2019/1/21/1687026bcf3e4095?w=720&h=809&f=png&s=11876)


#### 一些更重要的事情
1. 如果只是想简单地拥有不同的布局（按照我的理解，就是横屏竖屏的布局是完全不一样的，不需要去复用一部分代码）而没有类似Fragment的布局，那可以只可以直接在build方法中编写不同的方法进行构建就行。
```
if (MediaQuery.of(context).size.width > 600) {
          isLargeScreen = true;
        } else {
          isLargeScreen = false;
        }
return isLargeScreen? _buildTabletLayout() : _buildMobileLayout();
```
2. 如果只是想给平板电脑设计的应用程序，那不能直接检查MediaQurey的宽度来判断，而是需要获取Size并使用它来获取实际的宽度。在横屏的时候，width的值其实是平板的长度，height的值其实是平板的宽度。
```
Size size = MediaQuery.of(context).size;
double width = size.width > size.height ? size.height : size.width;
if(width > 600) {
  // Do something for tablets here
} else {
  // Do something for phones
}
```


### Github链接

自己也跟着原作者撸了下demo，顺便加了点注释，方便自己理解。

自己的Github链接：[https://github.com/LXD312569496/flutter-learing/tree/master/adapt_screen_learning](https://github.com/LXD312569496/flutter-learing/tree/master/adapt_screen_learning)

原作者：[https://github.com/deven98/FlutterAdaptiveLayouts](https://github.com/deven98/FlutterAdaptiveLayouts)









