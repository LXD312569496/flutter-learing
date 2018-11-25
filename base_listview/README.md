# 封装一个简单的listview，下拉刷新上拉加载
![https://github.com/LXD312569496/flutter-learing/blob/master/base_listview/pic.jpg](https://github.com/LXD312569496/flutter-learing/blob/master/base_listview/pic.jpg)

## Getting Started

### 1.需求场景
在开发的过程中，经常要用到一个具有下拉刷新和上拉加载更多功能的listview
，代码的实现思路基本是差不多的。所以有必要封装一个通用的listview，方便使用。
### 2.需要用到的控件
1. 下拉刷新RefreshIndicator
2. FutureBuilder:Flutter应用中的异步模型，基于与Future交互的最新快照来构建自身的widget
3. ScrollController,可以监听listview的滑动状态
4. typedef：在Dart语言中,方法也是对象. 使用typedef,或者function-type alias来为方法类型命名,
然后可以使用命名的方法.当把方法类型赋值给一个变量的时候,typedef保留类型信息.
具体使用方法：[http://dart.goodev.org/guides/language/language-tour#typedefs](http://dart.goodev.org/guides/language/language-tour#typedefs)
### 3.实现思路，布局方式
目标：外部使用BaseListView的时候，只需要传入一个页面请求的操作和item构造的方法就可以使用。

##### 1. 定义typedef
将页面请求的方法定义为PageRequest，将构造子项的方法定义为ItemBuilder。
比如下面，PageRequest的返回值是列表数据的future，参数值是当前分页和每页页数。在BaseListView中定义一个
PageRequest的变量给外面赋值，然后就可以通过变量调用外部的异步操作。
ItemBuilder主要是提供给外部进行自定义构造子项，参数是数据源list和当前位置position。
根据需要可以定义更多的typedef，这里就只定义这两个。
```
//类型定义
typedef Future<List<T>> PageRequest<T>(int page, int pageSize);
typedef Widget ItemBuilder<T>(List<T> list, int position);
```
##### 2. FutureBuilder+RefreshIndicator实现懒加载和下拉刷新
这个之前已经实现过，可以看：[https://github.com/LXD312569496/flutter-learing/blob/master/future_builder_learning/README.md](https://github.com/LXD312569496/flutter-learing/blob/master/future_builder_learning/README.md)

##### 3.利用ScrollController实现加载更多的功能
ListView中有一个ScrollController类型的参数，可以利用controller来监听listview的滑动状态，'
当滑动到底部的时候，可以loadmore操作
```
ListView({
    Key key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController controller,
    bool primary,
    ScrollPhysics physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry padding,
    this.itemExtent,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double cacheExtent,
    List<Widget> children = const <Widget>[],
    int semanticChildCount,
  })

```

##### 4. 一些默认的widget
* 底部的加载菊花：当在进行loadmore操作的时候，显示底部的加载菊花，所以当在进行loadmore操作的时候，
list的长度要加1，然后把菊花这个item放到最后
* 加载数据出错的状态页面，点击可以重试
* 加载数据为空的状态页面


### 4. 代码实现
```
    /**这部分代码主要是设置滑动监听，滑动到距离底部100单位的时候，开始进行loadmore操作
    如果controller.position.pixels==controller.position.maxScrollExtent再去
    进行loadmore操作的话，实际的显示和操作会有点奇怪，所以这里设置距离底部100
    */
    controller = new ScrollController();
    controller.addListener(() {
      if (controller.position.pixels >=
          controller.position.maxScrollExtent - 100) {
        if (!isLoading) {
          isLoading = true;
          loadmore();
        }
      }
    });
```

```
  /**
   * 构造FutureBuilder
   */
FutureBuilder<List<T>> buildFutureBuilder() {
    return new FutureBuilder<List<T>>(
      builder: (context, AsyncSnapshot<List<T>> async) {
        if (async.connectionState == ConnectionState.active ||
            async.connectionState == ConnectionState.waiting) {
          isLoading = true;
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
        if (async.connectionState == ConnectionState.done) {
          isLoading = false;
          if (async.hasError) {
            //有错误的时候
            return new RetryItem(() {
              refresh();
            });
          } else if (!async.hasData) {
            //返回值为空的时候
            return new EmptyItem(() {
              refresh();
            });
          } else if (async.hasData) {
            //如果是刷新的操作
            if (widget.page == 0) {
              _list.addAll(async.data);
            }
            if (widget.total > 0 && widget.total <= _list.length) {
              widget.enableLoadmore = false;
            } else {
              widget.enableLoadmore = true;
            }

            debugPrint(
                "loadData hasData:page:${widget.page},pageSize:${widget.pageSize},list:${_list.length}");

            //计算最终的list长度
            int length = _list.length + (widget.hasHeader ? 1 : 0);

            return new RefreshIndicator(
                child: new ListView.separated(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: widget.enableLoadmore ? controller : null,
                  itemBuilder: (context, index) {
//                TODO:头部的更新，可能要放在外面，放在里面的话也行，不过要封装获取头部future的逻辑,然后提供一个外部builder给外部进行构造
//                目前需要在外面判断position是否为0去构造头部
//                if (widget.hasHeader && index == 0 && widget.header != null) {
//                  return widget.header;
//                }
                    //可以加载更多的时候，最后一个item显示菊花
                    if (widget.enableLoadmore && index == length) {
                      return new LoadMoreItem();
                    }
                    return widget.itemBuilder(_list, index);
                  },
                  itemCount: length + (widget.enableLoadmore ? 1 : 0),
                  separatorBuilder: (BuildContext context, int index) {
                    return new Divider();
                  },
                ),
                onRefresh: refresh);
          }
        }
      },
      future: future,
    );
  }
```

下面是跟获取数据有关的几个方法：loadmore()，refresh(),loadData()。
loadData()会调用之前定义的页面请求PageRequest方法
```
Future refresh() async {
    debugPrint("loadData:refresh,list:${_list.length}");
    if (!widget.enableRefresh) {
      return;
    }
    if (isLoading) {
      return;
    }

    _list.clear();
    setState(() {
      isLoading = true;
      widget.page = 0;
      future = loadData(widget.page, widget.pageSize);
      futureBuilder = buildFutureBuilder();
    });
  }

  void loadmore() async {
    debugPrint("loadData:loadmore,list:${_list.length}");
    loadData(++widget.page, widget.pageSize).then((List<T> data) {
      setState(() {
        isLoading = false;

        _list.addAll(data);
        futureBuilder = buildFutureBuilder();
      });
    });
  }

  Future<List<T>> loadData(int page, int pageSize) async {
    debugPrint("loadData:page:$page,pageSize:$pageSize,list:${_list.length}");
    return await widget.pageRequest(page, pageSize);
  }
```


### 5.注意的问题和踩坑 
   1. 防止FutureBuilder进行不必要的重绘：这里我采用的方法，是将getData（）赋值给一个future的成员变量，
    用它来保存getData（）的结果，以避免不必要的重绘
    参考文章：[https://blog.csdn.net/u011272795/article/details/83010974](https://blog.csdn.net/u011272795/article/details/83010974)
   2. FutureBuilder和RefreshIndicator的嵌套问题，到底谁是谁的child，这里我是把RefreshIndicator作为FutureBuilder
    的孩子。如果将RefreshIndicator放在外层，FutureBuilder作为child的话，当RefreshIndicator调用onrefreh刷新数据并用
    setState（）去更新界面的时候，那FutureBuilder也会再次经历生命周期，所以导致获取数据的逻辑会被走两遍

### 6.下一步TODO
   * 存在的问题：当所有数据都已请求回来后，设置不能再加载更多，这个时候会多刷新来一次页面，暂时还未解决这个问题。
   * 继续完善这个Baselistview。
   * 封装另外一种Baselistview，用RefreshIndicator和NotificationListener来封装就行。