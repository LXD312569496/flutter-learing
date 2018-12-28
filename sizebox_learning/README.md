# sizebox_learning
 ###  主要是学习SizeBox的几种使用方法
   * 一般的SizeBox()
   * SizeBox.expand()
   * SizeBox.fromSize()
   * SizedOverflowBox()
   * FractionallySizedBox()
 ### 使用场景：
   * 一般是用来限制孩子控件的大小
   * 还有这么一种场景也可以使用SizeBox，就是可以代替padding和container，然后
    用来设置两个控件之间的间距，比如在行或列中就可以设置两个控件之间的间距
    主要是可以比使用一个padding或者container简单方便


## Getting Started

```
 /*
  一般的用法
  Sizebox会强制它的孩子的大小
   */
  buildSizebox() {
    return new RandomContainer(
      child: new SizedBox(
        width: 100,
        height: 100,
        child: new FlutterLogo(),
      ),
    );
  }
```

```

  /*
   * Sizebox.expand
   *会充满sizebox的父控件
   */
  RandomContainer buildSizeboxExpand() {
    return new RandomContainer(
        child: new SizedBox.expand(
      child: new FlutterLogo(),
    ));
  }
```

```

  /*
   * Sizebox的另外一种使用方法.
    参数是Size
   * 比如下面利用屏幕的size信息进行设置SizeBox的大小
   */
  buildSizeboxFromSize() {
    var deviceSize = MediaQuery.of(context).size;
    return new RandomContainer(
      child: new SizedBox.fromSize(
        size: Size(100, 100),
        child: FlutterLogo(),
      ),
//      child: new SizedBox.fromSize(size: deviceSize/2,child: FlutterLogo(),),
    );
  }
```
```

  /*
  SizedOverflowBox,允许sizebox里面的child大小比sizebox大，导致溢出显示
  而且还有个alignment的参数，可以用来设置sizebox里面的child的位置
   */
  buildSizedOverflowBox() {
    return new RandomContainer(
      child: new SizedOverflowBox(
        size: Size(100, 100),
        alignment: Alignment.bottomRight,
        child: new FlutterLogo(
          size: 50,
        ),
      ),
    );
  }
```

```

  /*
FractionallySizedBox,可以用百分比来控制sizebox的大小
widthFactor，heightFactor参数就是相对于父控件的比例
alignment：可以设置sizebox在父控件里面的相对位置
   */
  buildFractionallySizedBox() {
    return new RandomContainer(
      width: 200,
      height: 200,
      child: new FractionallySizedBox(
        alignment: Alignment.topCenter,
        widthFactor: 0.4,
        heightFactor: 0.4,
        child: new FlutterLogo(),
      ),
    );
  }

```

```

  /*
   * 在行或者列中，使用SizedBox来代替padding或者container来设置间距
   */
  buildColumn() {
    return new SafeArea(
        child: new Column(
      children: <Widget>[
        new Text(
          "11111",
          style: new TextStyle(fontSize: 30),
        ),
        new SizedBox(height: 20,),
        new Text(
          "22222",
          style: new TextStyle(fontSize: 30),
        ),
        new SizedBox(height: 20,),
        new Text(
          "33333",
          style: new TextStyle(fontSize: 30),
        ),
      ],
    ));
  }
}
```










## SizedBox的源码
```
/// A box with a specified size。
/// 意思就是一个指定大小的盒子，SizedBox会强制设置它的孩子的宽度或者高度为指定值。
///
/// SizedBox的构造函数的参数：width,height, child。
/// 如果width,height, child都指定的话，那SizedBox和child的宽度和高度都为指定值。
/// 如果只指定width和child的话，那child的宽度为指定值，child的高度自适应，SizedBox的高度将跟child的高度一样。
/// 如果只指定height和child的话，那child的高度为指定值，child的宽度自适应，SizedBox的宽度将跟child的宽度一样。
/// 如果没有指定child,SizedBox的大小为指定的大小。
///
/// [new SizedBox.expand]的构造方法可以使SizedBox的大小充满parent的布局，相当于设置了SizedBox
/// 的宽度和高度为[double.infinity](无穷大)。
///
/// See also:
///
///  * [ConstrainedBox], a more generic version of this class that takes
///    arbitrary [BoxConstraints] instead of an explicit width and height.
///  * [UnconstrainedBox],一个容器container,试图让它的child可以不受约束地绘制
///  * [FractionallySizedBox], 也是一个SizedBox,设置它的child大小在可用空间的占比。
///  * [AspectRatio],一个小部件， a widget that attempts to fit within the parent's    constraints while also sizing its child to match a given aspect ratio.
///  * [FittedBox], which sizes and positions its child widget to fit the parent
///    according to a given [BoxFit] discipline.

class SizedBox extends SingleChildRenderObjectWidget {
  /// 创建一个SizedBox，参数[width]和[height] 可以为空，表示width或者height对应的方向不受约束，会自适应。
  const SizedBox({ Key key, this.width, this.height, Widget child })
    : super(key: key, child: child);

  /// 创建一个SizedBox，会去充满父布局
  const SizedBox.expand({ Key key, Widget child })
    : width = double.infinity,
      height = double.infinity,
      super(key: key, child: child);

  /// 创建一个SizeBox，尽可能地小。
  /// Creates a box that will become as small as its parent allows.
  const SizedBox.shrink({ Key key, Widget child })
    : width = 0.0,
      height = 0.0,
      super(key: key, child: child);

  /// 创建一个指定Size的SizedBox。
  SizedBox.fromSize({ Key key, Widget child, Size size })
    : width = size?.width,
      height = size?.height,
      super(key: key, child: child);

  /// 如果width不为空,会要求它的child具有这个宽度
  final double width;

  /// 如果height不为空,会要求它的height具有这个高度
  final double height;

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
      additionalConstraints: _additionalConstraints,
    );
  }

  BoxConstraints get _additionalConstraints {
    return BoxConstraints.tightFor(width: width, height: height);
  }

  @override
  void updateRenderObject(BuildContext context, RenderConstrainedBox renderObject) {
    renderObject.additionalConstraints = _additionalConstraints;
  }

  @override
  String toStringShort() {
    String type;
    if (width == double.infinity && height == double.infinity) {
      type = '$runtimeType.expand';
    } else if (width == 0.0 && height == 0.0) {
      type = '$runtimeType.shrink';
    } else {
      type = '$runtimeType';
    }
    return key == null ? '$type' : '$type-$key';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    DiagnosticLevel level;
    if ((width == double.infinity && height == double.infinity) ||
        (width == 0.0 && height == 0.0)) {
      level = DiagnosticLevel.hidden;
    } else {
      level = DiagnosticLevel.info;
    }
    properties.add(DoubleProperty('width', width, defaultValue: null, level: level));
    properties.add(DoubleProperty('height', height, defaultValue: null, level: level));
  }
}

/// ConstrainedBox是一个小部件，可以对它的child增加额外的约束。
/// 例如，你想让child的最小高度为50.0，那么可以使用const BoxConstraints(minHeight: 50.0)作为[constraints]属性。
///
/// See also:
///
///  * [BoxConstraints], 描述constarint约束的类.
///  * [UnconstrainedBox], a container that tries to let its child draw without
///    constraints.
///  * [SizedBox], which lets you specify tight constraints by explicitly
///    specifying the height or width.
///  * [FractionallySizedBox], which sizes its child based on a fraction of its
///    own size and positions the child according to an [Alignment] value.
///  * [AspectRatio], a widget that attempts to fit within the parent's
///    constraints while also sizing its child to match a given aspect ratio.

class ConstrainedBox extends SingleChildRenderObjectWidget {
  /// 创建一个小部件，对它的孩子增加一些额外的约束
  ///
  /// [constraints]参数不能为空。
  ConstrainedBox({
    Key key,
    @required this.constraints,
    Widget child
  }) : assert(constraints != null),
       assert(constraints.debugAssertIsValid()),
       super(key: key, child: child);

  /// 对child增加的约束constraints
  final BoxConstraints constraints;

  @override
  RenderConstrainedBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(additionalConstraints: constraints);
  }

  @override
  void updateRenderObject(BuildContext context, RenderConstrainedBox renderObject) {
    renderObject.additionalConstraints = constraints;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<BoxConstraints>('constraints', constraints, showName: false));
  }
}

/// A widget that imposes no constraints on its child, allowing it to render
/// at its "natural" size.
///
/// This allows a child to render at the size it would render if it were alone
/// on an infinite canvas with no constraints. This container will then attempt
/// to adopt the same size, within the limits of its own constraints. If it ends
/// up with a different size, it will align the child based on [alignment].
/// If the box cannot expand enough to accommodate the entire child, the
/// child will be clipped.
///
/// In debug mode, if the child overflows the container, a warning will be
/// printed on the console, and black and yellow striped areas will appear where
/// the overflow occurs.
///
/// See also:
///
///  * [ConstrainedBox], for a box which imposes constraints on its child.
///  * [Align], which loosens the constraints given to the child rather than
///    removing them entirely.
///  * [Container], a convenience widget that combines common painting,
///    positioning, and sizing widgets.
///  * [OverflowBox], a widget that imposes different constraints on its child
///    than it gets from its parent, possibly allowing the child to overflow
///    the parent.
class UnconstrainedBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that imposes no constraints on its child, allowing it to
  /// render at its "natural" size. If the child overflows the parents
  /// constraints, a warning will be given in debug mode.
  const UnconstrainedBox({
    Key key,
    Widget child,
    this.textDirection,
    this.alignment = Alignment.center,
    this.constrainedAxis,
  }) : assert(alignment != null),
       super(key: key, child: child);

  /// The text direction to use when interpreting the [alignment] if it is an
  /// [AlignmentDirectional].
  final TextDirection textDirection;

  /// The alignment to use when laying out the child.
  ///
  /// If this is an [AlignmentDirectional], then [textDirection] must not be
  /// null.
  ///
  /// See also:
  ///
  ///  * [Alignment] for non-[Directionality]-aware alignments.
  ///  * [AlignmentDirectional] for [Directionality]-aware alignments.
  final AlignmentGeometry alignment;

  /// The axis to retain constraints on, if any.
  ///
  /// If not set, or set to null (the default), neither axis will retain its
  /// constraints. If set to [Axis.vertical], then vertical constraints will
  /// be retained, and if set to [Axis.horizontal], then horizontal constraints
  /// will be retained.
  final Axis constrainedAxis;

  @override
  void updateRenderObject(BuildContext context, covariant RenderUnconstrainedBox renderObject) {
    renderObject
      ..textDirection = textDirection ?? Directionality.of(context)
      ..alignment = alignment
      ..constrainedAxis = constrainedAxis;
  }

  @override
  RenderUnconstrainedBox createRenderObject(BuildContext context) => RenderUnconstrainedBox(
    textDirection: textDirection ?? Directionality.of(context),
    alignment: alignment,
    constrainedAxis: constrainedAxis,
  );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DiagnosticsProperty<Axis>('constrainedAxis', null));
    properties.add(DiagnosticsProperty<TextDirection>('textDirection', textDirection, defaultValue: null));
  }
}

/// A widget that sizes its child to a fraction of the total available space.
/// 一个小部件，会使它的子部件大小，调整为剩余可用空间的一部分，可以使用百分比
/// See also:
///
///  * [Align], which sizes itself based on its child's size and positions
///    the child according to an [Alignment] value.
///  * [OverflowBox], a widget that imposes different constraints on its child
///    than it gets from its parent, possibly allowing the child to overflow the
///    parent.
class FractionallySizedBox extends SingleChildRenderObjectWidget {

  ///  [widthFactor] and [heightFactor] 不能是负数。
  const FractionallySizedBox({
    Key key,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
    Widget child,
  }) : assert(alignment != null),
       assert(widthFactor == null || widthFactor >= 0.0),
       assert(heightFactor == null || heightFactor >= 0.0),
       super(key: key, child: child);

  /// If non-null, the fraction of the incoming width given to the child.
  ///
  /// If non-null, the child is given a tight width constraint that is the max
  /// incoming width constraint multiplied by this factor.
  ///
  /// If null, the incoming width constraints are passed to the child
  /// unmodified.
  final double widthFactor;

  /// If non-null, the fraction of the incoming height given to the child.
  ///
  /// If non-null, the child is given a tight height constraint that is the max
  /// incoming height constraint multiplied by this factor.
  ///
  /// If null, the incoming height constraints are passed to the child
  /// unmodified.
  final double heightFactor;

  /// 根据alignment对齐孩子，默认值为[Alignment.center]
  /// Alignment(this.x, this.y)，利用x和y的值来控制水平方向和竖直方向的对齐。
  /// 比如x为 -1.0,表示child的左边缘和parent的左边缘对齐，x为1则表示child的右边缘和
  /// parent的右边缘对齐。
  /// x为0则表示child的中心和parent的中心对齐。
  /// 其他值利用线性插值的方法去计算。默认会有一些自定义的常量，比如Alignment.center表示(0,0)
  final AlignmentGeometry alignment;

  @override
  RenderFractionallySizedOverflowBox createRenderObject(BuildContext context) {
    return RenderFractionallySizedOverflowBox(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderFractionallySizedOverflowBox renderObject) {
    renderObject
      ..alignment = alignment
      ..widthFactor = widthFactor
      ..heightFactor = heightFactor
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DoubleProperty('widthFactor', widthFactor, defaultValue: null));
    properties.add(DoubleProperty('heightFactor', heightFactor, defaultValue: null));
  }
}

/// A box that limits its size only when it's unconstrained.
///
/// If this widget's maximum width is unconstrained then its child's width is
/// limited to [maxWidth]. Similarly, if this widget's maximum height is
/// unconstrained then its child's height is limited to [maxHeight].
///
/// This has the effect of giving the child a natural dimension in unbounded
/// environments. For example, by providing a [maxHeight] to a widget that
/// normally tries to be as big as possible, the widget will normally size
/// itself to fit its parent, but when placed in a vertical list, it will take
/// on the given height.
///
/// This is useful when composing widgets that normally try to match their
/// parents' size, so that they behave reasonably in lists (which are
/// unbounded).
///
/// See also:
///
///  * [ConstrainedBox], which applies its constraints in all cases, not just
///    when the incoming constraints are unbounded.
///  * [SizedBox], which lets you specify tight constraints by explicitly
///    specifying the height or width.
///  * The [catalog of layout widgets](https://flutter.io/widgets/layout/).
class LimitedBox extends SingleChildRenderObjectWidget {
  /// Creates a box that limits its size only when it's unconstrained.
  ///
  /// The [maxWidth] and [maxHeight] arguments must not be null and must not be
  /// negative.
  const LimitedBox({
    Key key,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    Widget child,
  }) : assert(maxWidth != null && maxWidth >= 0.0),
       assert(maxHeight != null && maxHeight >= 0.0),
       super(key: key, child: child);

  /// The maximum width limit to apply in the absence of a
  /// [BoxConstraints.maxWidth] constraint.
  final double maxWidth;

  /// The maximum height limit to apply in the absence of a
  /// [BoxConstraints.maxHeight] constraint.
  final double maxHeight;

  @override
  RenderLimitedBox createRenderObject(BuildContext context) {
    return RenderLimitedBox(
      maxWidth: maxWidth,
      maxHeight: maxHeight
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderLimitedBox renderObject) {
    renderObject
      ..maxWidth = maxWidth
      ..maxHeight = maxHeight;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('maxWidth', maxWidth, defaultValue: double.infinity));
    properties.add(DoubleProperty('maxHeight', maxHeight, defaultValue: double.infinity));
  }
}

/// 一个小部件，OverflowBox允许它的child控件，溢出它的父控件，进行绘制，不会报OverFlow的错误。
/// See also:
///
///  * [RenderConstrainedOverflowBox] for details about how [OverflowBox] is
///    rendered.
///  * [SizedOverflowBox], a widget that is a specific size but passes its
///    original constraints through to its child, which may then overflow.
///  * [ConstrainedBox], a widget that imposes additional constraints on its
///    child.
///  * [UnconstrainedBox], a container that tries to let its child draw without
///    constraints.
///  * [SizedBox], a box with a specified size.
///  * The [catalog of layout widgets](https://flutter.io/widgets/layout/).
class OverflowBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that lets its child overflow itself.
  const OverflowBox({
    Key key,
    this.alignment = Alignment.center,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    Widget child,
  }) : super(key: key, child: child);

  /// 跟上面的解释是一样的
  final AlignmentGeometry alignment;

  /// 设置child的最小宽度
  /// 如果为空，则默认是使用来自OverflowBox的父节点的约束
  final double minWidth;

  /// 设置child的最大宽度
  /// 如果为空，则默认是使用来自OverflowBox的父节点的约束
  final double maxWidth;

  /// 设置child的最小高度
  final double minHeight;
  ///设置child的最大高度
  final double maxHeight;

  @override
  RenderConstrainedOverflowBox createRenderObject(BuildContext context) {
    return RenderConstrainedOverflowBox(
      alignment: alignment,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderConstrainedOverflowBox renderObject) {
    renderObject
      ..alignment = alignment
      ..minWidth = minWidth
      ..maxWidth = maxWidth
      ..minHeight = minHeight
      ..maxHeight = maxHeight
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DoubleProperty('minWidth', minWidth, defaultValue: null));
    properties.add(DoubleProperty('maxWidth', maxWidth, defaultValue: null));
    properties.add(DoubleProperty('minHeight', minHeight, defaultValue: null));
    properties.add(DoubleProperty('maxHeight', maxHeight, defaultValue: null));
  }
}

/// 原理跟上面的OverflowBox差不多
class SizedOverflowBox extends SingleChildRenderObjectWidget {
  /// Creates a widget of a given size that lets its child overflow.
  ///
  /// The [size] argument must not be null.
  const SizedOverflowBox({
    Key key,
    @required this.size,
    this.alignment = Alignment.center,
    Widget child,
  }) : assert(size != null),
       assert(alignment != null),
       super(key: key, child: child);


  final AlignmentGeometry alignment;

  /// The size this widget should attempt to be.
  final Size size;

  @override
  RenderSizedOverflowBox createRenderObject(BuildContext context) {
    return RenderSizedOverflowBox(
      alignment: alignment,
      requestedSize: size,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderSizedOverflowBox renderObject) {
    renderObject
      ..alignment = alignment
      ..requestedSize = size
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DiagnosticsProperty<Size>('size', size, defaultValue: null));
  }
}
```