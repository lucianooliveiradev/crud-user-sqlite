import 'package:cruduser/util/navDrawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final String title;
  Home({Key key, this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: NavDrawer(),
      appBar: new AppBar(
        title: Text("Home"),
      ),
      body: Center(child: FlutterLogo(size: 150,)),
    );
  }

}
