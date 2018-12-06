import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_demo/style/theme.dart' as theme;

/**
 * 注册界面
 */
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 23),
        child: new Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,),
                width: 300,
                height: 360,
                child: buildSignUpTextForm()
            ),

            new Positioned(child: new Center(child:
            new Container(
              padding: EdgeInsets.only(
                  top: 10, bottom: 10, left: 42, right: 42),
              decoration: new BoxDecoration(
                gradient: theme.Theme.primaryGradient,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: new Text("SignUp",
                style: new TextStyle(fontSize: 25, color: Colors.white),),
            ),), top: 340,)

          ],
        )
    );
  }

  Widget buildSignUpTextForm() {
    return new Form(child: new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //用户名字
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              decoration: new InputDecoration(
                  icon: new Icon(FontAwesomeIcons.user, color: Colors.black,),
                  hintText: "Name",
                  border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),
        //邮箱
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              decoration: new InputDecoration(
                  icon: new Icon(Icons.email, color: Colors.black,),
                  hintText: "Email Address",
                  border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),
        //密码
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              decoration: new InputDecoration(
                icon: new Icon(Icons.lock, color: Colors.black,),
                hintText: "Password",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(Icons.remove_red_eye, color: Colors.black,),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        new Container(
          height: 1,
          width: 250,
          color: Colors.grey[400],
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 20, bottom: 20),
            child: new TextFormField(
              decoration: new InputDecoration(
                icon: new Icon(Icons.lock, color: Colors.black,),
                hintText: "Confirm Passowrd",
                border: InputBorder.none,
                suffixIcon: new IconButton(
                    icon: new Icon(Icons.remove_red_eye, color: Colors.black,),
                    onPressed: () {}),
              ),
              obscureText: true,
              style: new TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),

      ],
    ));
  }

}