class UserModel {
  String name;
  String email;
  String password;
  String confirmPassword = "";

  UserModel({this.email = "", this.password = "", this.name = ""});
}
