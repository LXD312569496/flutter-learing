import 'package:flutter/material.dart';

class DialogUtil {
  /*
  1.因为Dialog也是属于Navigator管理的，所以关闭对话框，直接用 Navigator.of(context).pop就行了
  2.ShowDialog()方法返回的是Future值,如果调用Navigator.of(context).pop()方法的时候，可以传递一些数值由Future返回。
    那么就可以用then()监听这个future所返回的数据了
   */
  Future<T> showMyDialog<T>(BuildContext context,
      {Widget title,
      Widget content,
      VoidCallback onConfim,
      VoidCallback onCancle}) {
    return showDialog<T>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              new FlatButton(
                onPressed: onConfim,
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: onCancle,
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  /**
   *Dialog对话框里面包裹的是一个Column,需要在外面嵌套一层SingleChildScrollView，不然也会出现问题
   */
  Future<T> showMyDialogWithColumn<T>(BuildContext context,
      {Widget title,
      Column column,
      VoidCallback onConfim,
      VoidCallback onCancel}) {
    return showDialog<T>(
        context: context,
        builder: (context) {
          return new AlertDialog(
            title: title,
            content: new SingleChildScrollView(
              child: column,
            ),
            actions: <Widget>[
              new FlatButton(
                onPressed: onConfim,
                child: new Text("确认"),
              ),
              new FlatButton(
                onPressed: onCancel,
                child: new Text("取消"),
              ),
            ],
          );
        });
  }

  /**
   * Dialog对话框里面包含的是一个Listview，如果直接包含一个Listview会报错
   *    解决方法：要将ListView包装在具有特定宽度和高度的Container中
      如果Container没有定义这两个属性的话，会报错，无法显示ListView
   */

  Future<T> showMyDialogWithListView<T>(BuildContext context,
      {ListView listview,
      Widget title,
      double width,
      double height,
      VoidCallback onConfirm,
      VoidCallback onCancel}) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: title,
          content: new Container(
            width: width,
            height: height,
            child: listview,
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: onConfirm,
              child: new Text("确认"),
            ),
            new FlatButton(
              onPressed: onCancel,
              child: new Text("取消"),
            ),
          ],
        );
      },
    );

//如果直接将ListView放在dialog中，会报错，比如
//下面这种写法会报错：I/flutter (10721): ══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
//    I/flutter (10721): The following assertion was thrown during performLayout():
//    I/flutter (10721): RenderShrinkWrappingViewport does not support returning intrinsic dimensions.
//    I/flutter (10721): Calculating the intrinsic dimensions would require instantiating every child of the viewport, which
//    I/flutter (10721): defeats the point of viewports being lazy.
//    I/flutter (10721): If you are merely trying to shrink-wrap the viewport in the main axis direction, you should be able
//    I/flutter (10721): to achieve that effect by just giving the viewport loose constraints, without needing to measure its
//    I/flutter (10721): intrinsic dimensions.
//    I/flutter (10721):
//    I/flutter (10721): When the exception was thrown, this was the stack:
//    I/flutter (10721): #0      RenderShrinkWrappingViewport.debugThrowIfNotCheckingIntrinsics.<anonymous closure> (package:flutter/src/rendering/viewport.dart:1544:9)
//    I/flutter (10721): #1      RenderShrinkWrappingViewport.debugThrowIfNotCheckingIntrinsics (package:flutter/src/rendering/viewport.dart:1554:6)
//    I/flutter (10721): #2      RenderViewportBase.computeMaxIntrinsicWidth (package:flutter/src/rendering/viewport.dart:321:12)
//    I/flutter (10721): #3      RenderBox._computeIntrinsicDimension.<anonymous closure> (package:flutter/src/rendering/box.dart:1109:23)
//    I/flutter (10721): #4      __InternalLinkedHashMap&_HashVMBase&MapMixin&_LinkedHashMapMixin.putIfAbsent (dart:collection/runtime/libcompact_hash.dart:277:23)
//    I/flutter (10721): #5      RenderBox._computeIntrinsicDimension (package:flutter/src/rendering/box.dart:1107:41)
//    I/flutter (10721): #6      RenderBox.getMaxIntrinsicWidth (package:flutter/src/rendering/box.dart:1291:12)
//    I/flutter (10721): #7      _RenderProxyBox&RenderBox&RenderObjectWithChildMixin&RenderProxyBoxMixin.computeMaxIntrinsicWidth (package:flutter/src/rendering/proxy_box.dart:81:20)

//        showDialog(context: context, builder: (context) {
//      return new AlertDialog(title: new Text("title"),
//        content: new SingleChildScrollView(
//          child: new Container(
//            height: 200,
//            child: new ListView.builder(
//              itemBuilder: (context, index) {
//                return new SizedBox(height: 100, child: new Text("1"),);
//              }, itemCount: 10, shrinkWrap: true,),
//          ),
//        ),
//        actions: <Widget>[
//          new FlatButton(onPressed: () {}, child: new Text("确认"),),
//          new FlatButton(onPressed: () {}, child: new Text("取消"),),
//        ],);
//    });
  }
}
