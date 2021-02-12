import 'package:cruduser/models/user.dart';
import 'package:cruduser/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final user;
  final isEdit;

  AddUser(this.isEdit, this.user);

  @override
  _AddUserState createState() => _AddUserState(this.isEdit, this.user);
}

class _AddUserState extends State<AddUser> {
  var name = TextEditingController();
  var login = TextEditingController();
  var password = TextEditingController();
  bool sucessAdd = false;

  final User user;
  final isEdit;

  _AddUserState(this.isEdit, this.user);

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      name.text = user.name;
      login.text = user.login;
      password.text = user.password;
    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Editar Usuário' : 'Novo Usuário'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Nome", name),
            getTextField("Login", login),
            getTextField("Senha", password),
            Container(
              child: ListTile(
                leading: Checkbox(
                  value: user.isDeleted == null ? false : user.isDeleted,
                  onChanged: (value) {
                    setState(() {
                      user.isDeleted = value;
                    });
                  },
                  activeColor: Colors.lightGreen,
                  key: Key("teste"),
                ),
                key: Key("value"),
                title: Text("Ativo?"),
              ),
            ),
            new GestureDetector(
              onTap: () {
                addRecord(isEdit);
                Navigator.of(context).pop(sucessAdd);
              },
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(isEdit ? "Editar" : "Adicionar",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Future addRecord(bool isEdit) async {
    var db = new DatabaseHelper();

    var user = new User(
        id: this.user.id == null ? 0 : this.user.id,
        name: name.text,
        login: login.text,
        password: password.text,
        isDeleted: this.user.isDeleted == null ? false : this.user.isDeleted);
    if (isEdit) {
      await db.update(user);
      sucessAdd = true;
    } else {
      user.id = null;
      await db.saveUser(user);
      sucessAdd = true;
    }
  }
}
