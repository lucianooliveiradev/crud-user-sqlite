class User {
  int id;
  String name;
  String login;
  String password;
  bool isDeleted;
  // String token;

  User({
    this.id,
    this.name,
    this.login,
    this.password,
    this.isDeleted,
    // this.token
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    login = json['login'];
    password = json['password'];
    isDeleted = json['isDeleted'];
    // token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['login'] = this.login;
    data['password'] = this.password;
    data['isDeleted'] = this.isDeleted;
    // data['token'] = this.token;
    return data;
  }
}
