import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungdriver/screens/about_me.dart';
import 'package:ungdriver/screens/authen.dart';
import 'package:ungdriver/screens/show_list_job.dart';

class ListJob extends StatefulWidget {
  @override
  _ListJobState createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  String nameLogin;
  Widget currentWidget = ShowListJob();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentWidget,
      appBar: AppBar(),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showHead(),
                buildListTileHome(),
                buildListTileAboutMe(),
              ],
            ),
            buildListTileSignOut(),
          ],
        ),
      ),
    );
  }

  ListTile buildListTileHome() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = ShowListJob();
          });
        },
        leading: Icon(
          Icons.add_alert,
          size: 36,
          color: Colors.pink[800],
        ),
        title: Text('List Job'),
        subtitle: Text('แสดงงานที่ รับผิดชอบอยู่'),
      );

  ListTile buildListTileAboutMe() => ListTile(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            currentWidget = AboutMe();
          });
        },
        leading: Icon(
          Icons.contact_mail,
          size: 36,
          color: Colors.blue[700],
        ),
        title: Text('About Me'),
        subtitle: Text('รายละเอียด User'),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/draw.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(nameLogin == null ? '' : nameLogin),
      accountEmail: Text('ใช้งานอยู่'),
    );
  }

  Column buildListTileSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.red),
          child: ListTile(
            leading: Icon(Icons.exit_to_app, size: 36, color: Colors.white),
            title: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'ออกจาก User ไป Login ใหม่',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              clearPreferance();
            },
          ),
        ),
      ],
    );
  }

  Future<Null> clearPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear().then((value) => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Authen(),
        ),
        (route) => false));
  }

  Future<Null> findLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameLogin = preferences.getString('Name');
    });
    print('nameLogin = $nameLogin');
  }
}
