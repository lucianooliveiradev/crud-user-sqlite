import 'package:cruduser/pages/home/home.dart';
import 'package:cruduser/pages/user/listUser.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor:  const Color(0xFF0D9AEC),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFFFFAD32),
      ),
      home: Home(),
      routes: <String, WidgetBuilder> {
        '/home': (BuildContext context) => new Home(),
        '/user-list' : (BuildContext context) => new UserList(),
      },
    );
  }
}

