import 'package:cruduser/models/user.dart';
import 'package:cruduser/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';

import 'addUser.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Usuários"),
          actions: _buildActions(),
        ),
        body: ListView.builder(
            itemCount: users == null ? 0 : users.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                child: new Container(
                    child: new Center(
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            flex: 0,
                            child: CircleAvatar(
                              radius: 15.0,
                              child: Icon(Icons.person),
                              backgroundColor: const Color(0xFF20283e),
                            ),
                          ),
                          new Expanded(
                            // flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                users[index].name,
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.lightBlueAccent),
                              ),
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Checkbox(
                                key: Key("value"),
                                value: users[index].isDeleted,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            textDirection: TextDirection.ltr,
                            children: <Widget>[
                              new IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: const Color(0xFF167F67),
                                ),
                                onPressed: () => edit(users[index], context),
                              ),
                              new IconButton(
                                  icon: const Icon(Icons.delete_forever,
                                      color: const Color(0xFF167F67)),
                                  onPressed: () {
                                    _showMyDialog(context, users[index], index);
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
              );
            }));
  }

  Future<void> _showMyDialog(BuildContext ctx, User user, index) async {
    return showDialog<void>(
      context: ctx,
      barrierDismissible: false, // user must tap button!
      builder: (ctx) {
        return AlertDialog(
          title: Text('Remover'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Você deseja remove o usuário ${user.name}'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            RaisedButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  _delete(users[index]);
                  users.removeAt(index);
                });
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future _loadData() async {
    var users = await DatabaseHelper.internal().getUser();

    if (users.length > 0) {
      setState(() {
        this.users = users;
      });
    }
  }

  List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: const Icon(
          Icons.group_add,
          color: Colors.white,
        ),
        onPressed: _openAddUserDialog,
      ),
    ];
  }

  Future _openAddUserDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new AddUser(false, new User()),
    );

    _loadData();
  }

  edit(User user, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => new AddUser(true, user),
    );
    _loadData();
  }

  String getShortName(User user) {
    String shortName = "";
    if (user.name != null) {
      shortName = user.name.substring(0, 1) + ".";
    }

    if (user.name != null) {
      shortName = shortName + user.login.substring(0, 1);
    }
    return shortName;
  }

  _delete(User user) async {
    await DatabaseHelper.internal().deleteUsers(user);
  }

  Future<List<User>> getUser() {
    return DatabaseHelper.internal().getUser();
  }
}
