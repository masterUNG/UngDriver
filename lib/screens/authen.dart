import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungdriver/models/user_model.dart';
import 'package:ungdriver/screens/listjob.dart';
import 'package:ungdriver/utility/my_constant.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String user, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/wall.jpg'), fit: BoxFit.cover),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildContainer(),
                  buildTextFieldUser(),
                  buildTextFieldPassword(),
                  buildRaisedButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildRaisedButton() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: RaisedButton(
          child: Text('Login'),
          onPressed: () {
            print('user ===>> $user, password = $password');
            if (user == null ||
                user.isEmpty ||
                password == null ||
                password.isEmpty) {
              print('Have Space');
              normalDialog('Please Fill Every Blank');
            } else {
              checkAuthen();
            }
          },
        ),
      );

  Future<Null> normalDialog(String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
        title: Text(string),
      ),
    );
  }

  Container buildTextFieldUser() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            labelText: 'User :',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Container buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password :',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Container buildContainer() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  Future<Null> checkAuthen() async {
    String urlAPI =
        '${MyConstant().domain}/pooh/getUserWhereUserUng.php?isAdd=true&User=$user';

    try {
      var result = await InternetAddress.lookup('392c785b81a3.ngrok.io');
      if ((result.isNotEmpty) && (result[0].rawAddress.isNotEmpty)) {
        print('Have Internet');
        await Dio().get(urlAPI).then((value) {
          print('res = $value');

          if (value.toString() == 'null') {
            normalDialog('ไม่มี $user ใน ฐานข้อมูลของเรา');
          } else {
            var result = json.decode(value.data);
            print('result = $result');
            for (var json in result) {
              print('json = $json');
              UserModel model = UserModel.fromJson(json);
              if (password == model.password) {
                savePreferanceAndRouteToService(model);
              } else {
                normalDialog('Please Try Again Password False');
              }
            }
          }
        });
      }
    } catch (e) {
      normalDialog('ไม่มี Internet โปรดลองใหม่ คะ');
    }
  }

  Future<Null> savePreferanceAndRouteToService(UserModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('id', model.id);
    preferences.setString('Name', model.name);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ListJob(),
        ),
        (route) => false);
  }

  Future<Null> checkPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id');
    print('id = $id');

    if (id.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ListJob(),
          ),
          (route) => false);
    }
  }
}
