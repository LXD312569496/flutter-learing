## Flutter提升开发效率的一些方法和工具

Flutter的环境搭配完之后，就开始Flutter的开发，下面的一些工具和方法，可以省下一些时间。

自己在用的，暂时想到的，就是这些了，总结一下。

### 1.JSON解析快速生成实体类

根据接口返回的数据，编写实体类，添加两个方法。

fromJson()方法是可以聪一个Map中构造出一个User的实例，toJson()方法，可以将一个实例转化为Map。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fac2157ee366?w=1151&h=369&f=png&s=25999)


如果接口返回的数据比较复杂点，那么手动写起来就会很麻烦。这个时候可以利用json_serializable来帮你自动生成实体类的一些代码，还有利用[https://caijinglong.github.io/json2dart/index_ch.html](https://caijinglong.github.io/json2dart/index_ch.html)来快速生成相关代码。

将json数据复制到这个网站上，就会生成相关的代码，只需要将这些代码复制到项目中的文件就行了，

最后在我们的项目根目录下运行flutter packages pub run build_runner build，我们可以在需要时为我们的model生成json序列化代码 。 

注意：要先在pubspec.yaml文件里面添加：

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fac44a0d72b6?w=355&h=79&f=png&s=7394)


每个类最后面生成的with _$UserSerializerMixin，这部分可以去掉，不去掉的话，好像生成会有问题，反正我是去掉了，没什么影响。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fac7cca32663?w=1826&h=907&f=png&s=74937)


 

 

### 2.代码模板
最简单的一个例子，就是在写一个有状态StatefulWidget的时候，要手动继承StatefulWidget，重写createState方法，再创建一个相应的State类并重写build方法。会写到你吐血。

这个时候就需要一些代码模板，帮你快速生成代码。

反正百度一下肯定有些导入Flutter代码模板的教程。

比如直接打出stf，就可以自动提示生成StatefulWidget的代码了。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fac94cedf811?w=685&h=280&f=png&s=32156)


 

### 3.Asset资源文件的导入
Flutter中，常见类型的asset包括静态数据（例如JSON文件），配置文件，图标和图片（JPEG，WebP，GIF，动画WebP / GIF，PNG，BMP和WBMP）。

一般导入的资源都要在pubspec.yaml文件中按照下面的方式，一个一个进行声明，应用程序才能获取到。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675facb42bb90cd?w=537&h=111&f=png&s=5393)


改进方法：要包含asset文件下面的所有资源，直接用下面这样方法，这样的话，只在这个目录里的文件会被包含进来。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675faccf5238667?w=492&h=87&f=png&s=3353)


 

 

### 4.Flutter Outline工具，主要用于视图的预览，还有其他功能
在编写布局的时候，可以看到Flutter Outline界面，会实时地更新所写的布局层次，方便查看。

除了视图的预览，还有其他的功能。

就是右键某一个widget，可以根据提示框，快速帮你在这个widget的外面包装一层比如padding之类的代码。这个功能有时候挺方便的。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675facfb2203b96?w=640&h=610&f=png&s=76327)


Extract method的作用是：可以把某一个widget控件的代码，帮你封装成一个方法。不用你去手动地去找出一个widget的全部代码，再自己拉到某一个方法内。

另一方面，也可以方便地看出这个widget的相关代码，比如要复制操作起来也比较方便。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fad1839eb346?w=1398&h=516&f=png&s=138115)


 

### 5.拖动widget自动生成相关代码
有一个网站：[https://flutterstudio.app/](https://flutterstudio.app/)

可以拖动widget到模拟器中，就可以生成相关的布局代码，自己手动复制粘贴就可以了。

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fad5d854dd45?w=1462&h=946&f=png&s=72309)

![](https://user-gold-cdn.xitu.io/2018/11/29/1675fad765abf0c8?w=1309&h=943&f=png&s=82788)

 
### 6.使用random_pk库，在开发中也可以达到调试布局的作用
