import 'package:flutter/material.dart';
import 'package:login_demo/model/user.dart';

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
