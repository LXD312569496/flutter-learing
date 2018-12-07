# 学习在Flutter中使用Flare

## Getting Started

在看FlutterLive的时候，Flare演示看起来很牛逼，而且挺好玩的（对于一个不会设计的程序猿），所以就撸了个demo玩玩。

### 介绍
在FlutterLive,2Dimensions宣布即将推出Flare，这是一款非凡的新工具，可供设计师创建矢量动画，可直接嵌入到Flutter应用程序中并使用代码进行操作。

![](https://github.com/LXD312569496/flutter-learing/blob/master/flare_learning/pic1)

使用Flare构建的动画可以作为窗口小部件嵌入到现有的Flutter应用程序中，允许它们参与完整的合成器并与其他文本，图形图层甚至UI小部件重叠。以这种方式集成可以将动画从其他体系结构的“黑盒子”限制中解放出来，并允许设计人员和开发人员之间的持续协作直到应用程序完成。Flutter和Flare之间的这种紧密集成为想要创造高度完美的移动体验的数字设计师和动画师提供了独特的引人注目的产品。

比较大的一个优势：Flare消除了在一个应用程序中设计，在另一个应用程序中设置动画，然后将所有这些转换为特定于设备的资产和代码的需要。


### 在Flutter使用Flare构建的动画

##### 1. 导出Flare构建的动画的文件
[https://www.2dimensions.com/explore/popular/trending/all](https://www.2dimensions.com/explore/popular/trending/all)网站上面已经有很多现成的动画实例，可以直接拿来用就行。

点击其中的一个动画，然后页面右上角的OPEN IN NIMA.

![](https://github.com/LXD312569496/flutter-learing/blob/master/flare_learning/pic2.jpg)

![](https://github.com/LXD312569496/flutter-learing/blob/master/flare_learning/pic3.png)

点击Animate页面，就可以看到左下角，会显示所拥有的动画Animations

在Export to Engine菜单中，选择Generic作为引擎选项。将其他设置保留为默认值，然后按导出。这将生成并下载带有Robot.nima文件和Robot.png文件的zip文件。

##### 2. 在pubspec.yaml中添加Nima的依赖项

```
dependencies:
  flutter:
    sdk: flutter
  nima: ^1.0.0
```


##### 3. 将下载的动画文件添加到assets文件夹里面，并在pubspec.yaml中声明文件

```
  assets:
    - assets/
    - assets/robot.nima
    - assets/robot.png
```


##### 4. NimaActor的用法

```
class NimaActor extends LeafRenderObjectWidget{

	final String filename;//动画文件的路径
	final BoxFit fit;//设置填充的模式
	final Alignment alignment;//设置对齐方式
	final String animation;/*按我理解，就是一个动画文件，可能会包含多个动画状态，
	根据传进去的Animation的名字，播放对应的动画。就比如一个人形动画，有跳的动画，有走的动画，
	根据所传的animation的名字，播放对应的动画
	*/
	final double mixSeconds;//从一个动画切换到另一个动画之间的时间
	final bool paused;//是否暂停动画
	final NimaAnimationCompleted completed;//动画完成时提供的回调
	final NimaController controller;//控制器
}
```



##### 5. 在Flutter中显示Flare构建的动画

首先是导入nima_actor.dart，这样只后就可以使用用来显示动画的NimaActor小部件
```
import 'package:nima/nima_actor.dart';

//省略部分代码
@override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new NimaActor("assets/robot", alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: "Flight",
      ),
    );
  }

```
![](https://github.com/LXD312569496/flutter-learing/blob/master/flare_learning/pic4.png)




##### 6. 总结
优势就是那样咯，Flare消除了在一个应用程序中设计，在另一个应用程序中设置动画，然后将所有这些转换为特定于设备的资产和代码的需要。

看起来挺好玩的，有空的时候大家可以撸个动画demo玩玩.



















