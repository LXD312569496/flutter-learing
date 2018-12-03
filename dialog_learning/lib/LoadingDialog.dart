import 'package:flutter/material.dart';
import 'package:random_pk/random_pk.dart';

class LoadingDialog extends Dialog {
  String text;
  bool cancelable;//是否允许点击对话框外的区域，然后隐藏对话框
  LoadingDialog({@required this.text,this.cancelable=true});

  @override
  Widget build(BuildContext context) {
    //创建透明层
    return new Material(
        //透明类型
        type: MaterialType.transparency,
        //最外层的点击事件，用于点击隐藏对话框
        child: new GestureDetector(
          onTap: () {
            if(cancelable){
              Navigator.of(context).pop();
            }
          },
          child: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            //捕捉中间的点击事件，不会退出对话框
            child: new GestureDetector(
              onTap: (){},
              child: new Center(
                child: new SizedBox(
                  width: 120,
                  height: 120,
                  child: new Container(
                    decoration: ShapeDecoration(
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new CircularProgressIndicator(),
                        new SizedBox(
                          height: 20,
                        ),
                        new Text(
                          text,
                          style: new TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ),
        ));
  }
}
